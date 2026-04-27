//
//  TripViewModel.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

import Combine // published is built on combine 

final class TripViewModel: ObservableObject {
    @Published var isTracking = false
    @Published var currentTemp: Double = 0
    @Published var condition: String = "?"
    @Published var locationsCount = 0
    @Published var apiCalls = 0
    @Published var currentLocation: TripLocation?
    @Published var currentRoadType: RoadType?
    
    private let tripTracker: TripTracker
    
    init(tripTracker: TripTracker) {
        self.tripTracker = tripTracker
        self.tripTracker.viewModel = self // wire vm
        
    }
    
    func startTripVM() {
        print("🚗 START TRIP")
        isTracking = true
        tripTracker.startTripFromViewModel()
    }
    
    func stopTripVM() {
        tripTracker.stopTripFromViewModel()
        //tripTracker.stopTrip()
        print("🛑 END TRIP")
        isTracking = false
    }
    
    // WeatherManager calls this
    func updateWeather(temp: Double, condition: String) {
        currentTemp = temp
        self.condition = condition
        print("🌤️ WEATHER: \(temp)°C \(condition)")
    }
    
    func incrementLocation() {
        locationsCount += 1
    }
    
    func incrementApiCall() {
        apiCalls += 1
        print("📡 API CALL #\(apiCalls)")
    }
    
    func updateCurrentLocation(_ location: TripLocation) {
            currentLocation = location
            //currentRoadType = location.roadInfo.type
        }
}
