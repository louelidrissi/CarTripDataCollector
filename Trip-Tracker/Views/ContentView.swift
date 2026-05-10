//
//  ContentView.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

import CoreLocation
import SwiftData
import SwiftUI

struct ContentView: View {
    // UI listens to TripViewModel
    @StateObject private var vm: TripViewModel // State Object wraps the Published values to be observed by Swift UI
    
    // initialize trip tracker
    init() {
        let locationManager = LocationManager()
        let tripManager = TripManager()
        let weatherManager = WeatherManager()
        let roadManager = RoadManager()
        //let trafficDensityManager = TrafficManager()
    //    let roadQueryPolicy = RoadQueryPolicy()
        
        let tripTracker = TripTracker(
            locationManager: locationManager,
            tripManager: tripManager,
            weatherManager: weatherManager,
            roadManager: roadManager,
       //     roadQueryPolicy: roadQueryPolicy
//            trafficDensityManager: trafficDensityManager
        
        )
        _vm = StateObject(wrappedValue: TripViewModel(tripTracker: tripTracker))
        
       // tripTracker.viewModel = vm // call vm in Trip Tracker
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. Status
            Text(vm.isTracking ? "Tracking" : "Stopped")
                .font(.title2)
                .foregroundColor(vm.isTracking ? .green : .red)

            // 2. Weather Display
            VStack {
                Text("\(vm.currentTemp, specifier: "%.1f")°C")
                    .font(.largeTitle)
                    .bold()
                Text(vm.condition)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            // 3. Stats
            HStack {
                VStack {
                    Text("\(vm.locationsCount)")
                        .font(.title)
                    Text("Locations")
                        .font(.caption)
                }
                VStack {
                    Text("\(vm.apiCalls)")
                        .font(.title)
                    Text("API Calls")
                        .font(.caption)
                }
            }

            // 4. Current frame / all TripTracker properties
            if let location = vm.currentLocation {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("📍 Current frame")
                        .font(.headline)
                        .bold()
                    
                    // Coordinate
                    Text("Lat: \(location.coordinate.latitude, specifier: "%.6f")")
                    Text("Lon: \(location.coordinate.longitude, specifier: "%.6f")")
                    
                    // Speed
                    Text("Speed: \(location.speedKmh ?? 0, specifier: "%.1f") km/h")
                    
                    // Weather (optional)
                    if let weather = location.weather {
                        Text("\(weather.tempC, specifier: "%.1f")°C · \(weather.condition)")
                    } else {
                        Text("Weather: (not available / cached)")
                    }
                    // Road Info (optional as well)
                    if let road = location.roadInfo {
                        Text("Road: \(road.highway ?? "unknown")")
                        
                        if let speed = road.maxSpeed {
                            Text("Speed limit: \(speed, specifier: "%.0f") km/h")
                        }
                        
                        if let lanes = road.lanes {
                            Text("Lanes: \(lanes)")
                        }
                        
                        Text("Tram: \(road.hasTram ? "yes" : "no")")
                    } else {
                        Text("Road: loading / not fetched yet")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("Waiting for first location...")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            // 5. Big Start / Stop Button
            Button(vm.isTracking ? "End Trip" : "Start Trip") {
                if vm.isTracking {
                    vm.stopTripVM()
                } else {
                    vm.startTripVM()
                }
            }
            .font(.title2)
            .padding()
            .background(vm.isTracking ? .red : .green)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        
        .padding()
    }
}
