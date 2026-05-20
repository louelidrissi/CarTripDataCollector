//
//  TripLocationInfo.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI
import CoreLocation
import SwiftUI

struct LocationInfoView: View {

    @ObservedObject var vm: TripViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        if let location = vm.currentLocation {
            ScrollView {
                
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Current frame")
                        .font(.system(size: 14, weight: .semibold))
                        .bold()
                    
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    
                    LazyVGrid(
                        columns: columns,
                        alignment: .leading,
                        spacing: 9
                    ) {
                        
                        InfoRow(
                            title: "Lat",
                            value: String(format: "%.6f", lat)
                        )
                        
                        InfoRow(
                            title: "Lon",
                            value: String(format: "%.6f", lon)
                        )
                        
                        InfoRow(
                            title: "Speed",
                            value: location.speedKmh != nil
                            ? String(format: "%.1f km/h", location.speedKmh!)
                            : "unknown"
                        )
                        
                        InfoRow(
                            title: "Weather",
                            value: location.weather != nil
                            ? String(
                                format: "%.1f°C · %@",
                                location.weather!.tempC,
                                location.weather!.condition
                            )
                            : "unavailable"
                        )
                        
                        InfoRow(
                            title: "Road",
                            value: location.roadInfo?.highway ?? "unknown"
                        )
                        InfoRow(title: "Area",
                                value: location.roadInfo?.area ?? "unknown")
                        
                        InfoRow(title: "Ref",
                                value: location.roadInfo?.ref ?? "unknown")
                        
                        
                        InfoRow(
                            title: "Speed limit",
                            value: location.roadInfo?.maxSpeed != nil
                            ? String(
                                format: "%.0f km/h",
                                location.roadInfo!.maxSpeed!
                            )
                            : "unknown"
                        )
                        
                        InfoRow(
                            title: "Lanes",
                            value: location.roadInfo?.lanes.map { String($0) } ?? "unknown"
                        )
                        
                        InfoRow(
                            title: "Tram",
                            value: location.roadInfo?.hasTram == true
                            ? "yes"
                            : "no"
                        )
                        
                        InfoRow(
                            title: "Traffic",
                            value: location.traffic?.level.rawValue
                            ?? "unavailable"
                        )
                        
                        InfoRow(
                            title: "Avg speed",
                            value: location.traffic != nil
                            ? String(
                                format: "%.1f km/h",
                                location.traffic!.features.avgSpeed
                            )
                            : "unknown"
                        )
                        
                        InfoRow(
                            title: "Stop count",
                            value: location.traffic != nil
                            ? "\(location.traffic!.features.stopCount)"
                            : "unknown"
                        )
                    }
                }
                .padding()
            }
            
            .frame(maxHeight: 600)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

        } else {

            Text("Waiting for first location...")
                .foregroundColor(.secondary)
        }
    }
}

//
//struct LocationInfoView: View {
//    @ObservedObject var vm: TripViewModel
//    
//    var body: some View {
//        if let location = vm.currentLocation {
//            VStack(alignment: .leading, spacing: 6) {
//                Text("Current frame")
//                                        .font(.headline)
//                                        .bold()
//                
//                let lat = location.coordinate.latitude
//                let lon = location.coordinate.longitude
//
//                Text("Lat: \(lat, specifier: "%.6f")")
//                Text("Lon: \(lon, specifier: "%.6f")")
//
//                if let speed = location.speedKmh {
//                    Text("Speed: \(speed, specifier: "%.1f") km/h")
//                } else {
//                    Text("Speed: unknown")
//                }
//                if let weather = location.weather {
//                    Text("\(weather.tempC, specifier: "%.1f")°C · \(weather.condition)")
//                } else {
//                        Text("Weather: (not available / cached)")
//                    }
//
//                if let road = location.roadInfo {
//                    Text("Road: \(road.highway ?? "unknown")")
//                    
//                    if let speed = road.maxSpeed {
//                        Text("Speed limit: \(speed, specifier: "%.0f") km/h")
//                    }
//                    
//                    if let lanes = road.lanes {
//                        Text("Lanes: \(lanes)")
//                    }
//                    // need to also add if statement, need to deal with edge cases with all 
//                    Text("Tram: \(road.hasTram ? "yes" : "no")")
//                    
//                } else {
//                    Text("Road: loading / not fetched yet")
//                        .foregroundColor(.secondary)
//                }
//                
//                
//                if let traffic = location.traffic {
//
//                    Text("Traffic: \(traffic.level.rawValue)")
//
//                    Text("Stop count: \(traffic.features.stopCount)")
//
//                    Text("Avg speed: \(traffic.features.avgSpeed, specifier: "%.1f") km/h")
//
//                } else {
//                    Text("Traffic: unavailable")
//                        .foregroundColor(.secondary)
//                }
//            }
//            .padding()
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(8)
//
//        } else {
//            Text("Waiting for first location...")
//                .foregroundColor(.secondary)
//        }
//    }
//}
