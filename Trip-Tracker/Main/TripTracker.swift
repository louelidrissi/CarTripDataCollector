//
//  TripTracker.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//
// how to collect and assemble data from all managers into a trip.

import CoreLocation
import Foundation // for dates
import Combine

class TripTracker: ObservableObject {
    
    @Published var currentTrip: Trip?
    
    private let tripManager: TripManager
    private let locationManager: LocationManager // global by default
    private let weatherManager: WeatherManager
    private let roadManager: RoadManager
    private let roadQueryPolicy = RoadQueryPolicy()
    private let trafficManager = TrafficManager()
//    private let trafficDensityManager: TrafficManager
    
//    private let tripCSVManager = TripCSVManager()
    
    weak var viewModel: TripViewModel? // for live UI updates
    
    // initialize Trip Tracker
    init(
        locationManager: LocationManager,
        tripManager: TripManager,
        weatherManager: WeatherManager,
        roadManager: RoadManager,
//        roadQueryPolicy: RoadQueryPolicy
//        trafficDensityManager: TrafficManager
        //viewModel: TripViewModel? = nil
    ) {
        self.locationManager = locationManager
        self.tripManager = tripManager
        self.weatherManager = weatherManager
        self.roadManager = roadManager
//        self.roadQueryPolicy = roadQueryPolicy
//        self.trafficDensityManager = trafficDensityManager
        
        //self.viewModel = viewModel
    }
    
    func startTripFromViewModel() {
            viewModel?.isTracking = true   // main thread, no DispatchQueue
            startTrip()                    // calls your existing startTrip
        }
    
    func stopTripFromViewModel() {
        viewModel?.isTracking = false   // update UI state
        stopTrip()                      // reuse your existing full logic
    }
    
    // Method 1
    func startTrip() {
        guard currentTrip == nil else { return }
        
        let trip = Trip(
            id: UUID(),
            startTime: Date(),
            endTime: nil,
            locations: []
        )
        currentTrip = trip
        tripManager.startTrip(trip)
        
        // call delegate for user authorization to start tracking
        locationManager.requestPermission()
        print("after permissiong method call")
        print("")
        
        // Track each frame from Location Manager
        locationManager.didCreateFrame = { [weak self] frame in
            self?.handleLocationFrame(frame)
        }
        
        
    }
    
    // method 2 (trip in progress)
    private func handleLocationFrame(_ frame: LocationFrame) {
        print("📍 Location frame: \(frame.coordinate)")
        
        guard var trip = currentTrip else { return }
        
        Task {
            let weather = await weatherManager.fetchWeatherOrCached(coordinate: frame.coordinate)
            
            if let weather = weather {
                
                viewModel?.updateWeather(
                    temp: weather.tempC,
                    condition: weather.condition
                )
                
                viewModel?.incrementApiCall()
                
                print("API Weather: \(weather.tempC)°C \(weather.condition)")
            } else {
                print(" Cached weather")
            }
            
            let roadInfo = await roadQueryPolicy.getRoadInfoIfNeeded(
                coordinate: frame.coordinate,
                timestamp: frame.timestamp,
                fetch: { coord in
                    await roadManager.getRoadInfo(at: coord)
                }
            )
            
            let tripLocation = TripLocation(
                timestamp: frame.timestamp,
                coordinate: frame.coordinate,
                speedKmh: frame.speedKmh,
                weather: weather,
                roadInfo: roadInfo,
//                trafficDensity: trafficDensity  
            )
            
            let features = trafficManager.update(
                        speed: frame.speedKmh,
                        timestamp: frame.timestamp
                    )
            
            let trafficFlow = trafficManager.classify(features)

            print("🚦 Traffic: \(trafficFlow)")
            
            trip.locations.append(tripLocation)
            print("tripLocation", tripLocation)
            
            currentTrip = trip
            
            viewModel?.updateCurrentLocation(tripLocation)
            
            viewModel?.incrementLocation()
        }
    }
    
    
    // Method 3
    func stopTrip() {
  //      printDocumentsPath()
        
        guard let currentTrip = currentTrip else { return }
        print("Trip stopped, \(currentTrip.locations.count) frames recorded:")
        
//        for (index, location) in currentTrip.locations.enumerated() {
//            let spd = location.speedKmh ?? 0
//            print(" \(index + 1)|\(location.timestamp)|\(location.lat),\(location.lon)|\(spd) km/h")
//        }
        
        // Tell TripManager the trip is done
        tripManager.endTrip(currentTrip)
        
        // set file name based on id
       // let filename = "\(currentTrip.id.uuidString)_frames.csv"
        
        // Save current trip in CSV
//        do {
//            try tripCSVManager.save(trip: currentTrip, filename: filename)
//            print("CSV saved to: \(filename)")
//        } catch {
//            print("Error saving CSV: \(error)")
//        }
//        
        // Reset
        locationManager.didCreateFrame = nil
        locationManager.stopUpdatingLocation()
        
        self.currentTrip = nil
        print("finished reset of current trip.")
    }
    
//    func printDocumentsPath() {
//        guard let docs = FileManager.default
//            .urls(for: .documentDirectory, in: .userDomainMask).first
//        else {
//            print("Could not get Documents folder")
//            return
//        }
//        print("📍 Documents path: \(docs.path)")
//    
//    }
}
