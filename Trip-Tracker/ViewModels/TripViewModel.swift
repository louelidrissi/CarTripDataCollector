//
//  TripViewModel.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//
import Foundation
import Combine // published is built on combine

@MainActor // used to avoid thread issues
final class TripViewModel: ObservableObject {
    @Published var isTracking = false
    
    // SwiftUI automatically refreshes UI
    @Published var currentTemp: Double = 0
    @Published var currentLocation: TripLocation?
    
    
    @Published var condition: String = "?"
    @Published var locationsCount = 0
    @Published var weatherApiCalls = 0
    @Published var roadInfoApiCalls = 0
    
    
    @Published var currentRoadInfo: RoadInfo?
    
    @Published var selectedGaze: GazeDirection = .forward
    @Published var selectedActivity: DriverActivity = .normalDriving
    
    @Published var lastActivityChangeTime: Date?
    @Published var lastGazeChangeTime: Date?
    
    @Published var annotationLog: [String] = []
    
    // For showing annotation timestamps in UI
    @Published var activeAnnotation: DriverAnnotation?
    @Published var lastCompletedAnnotation: DriverAnnotation?
  
    private let tripTracker: TripTracker
    
    init(tripTracker: TripTracker) {
        self.tripTracker = tripTracker
        self.tripTracker.viewModel = self // wire vm
        
        print("VM INIT:", ObjectIdentifier(self))
        
    }
    
    // user actions
    func startTripVM() {
        print("START TRIP")
        isTracking = true
        tripTracker.startTripFromViewModel()
    }
    
    func stopTripVM() {
        tripTracker.stopTripFromViewModel()
        //tripTracker.stopTrip()
        print("END TRIP")
        isTracking = false
    }
    
    // WeatherManager calls this
    func updateWeather(temp: Double, condition: String) {
        currentTemp = temp
        self.condition = condition
      //  print("WEATHER: \(temp)°C \(condition)")
    }
    
    func incrementLocation() {
        locationsCount += 1
    }
    
    func incrementWeather() {
        weatherApiCalls += 1
       // print("API CALL #\(apiCalls)")
    }
    
    func incrementRoad() {
        roadInfoApiCalls += 1
       // print("API CALL #\(apiCalls)")
    }
    
    // receives updates from TripTracker
    func updateCurrentLocation(_ location: TripLocation) {
            currentLocation = location
            currentRoadInfo = location.roadInfo
        }
    
    func didTapActivity(_ activity: DriverActivity) {
        
        selectedActivity = activity

        let now = Date()
        lastActivityChangeTime = now

        annotationLog.insert(
            "Activity → \(activity.rawValue) @ \(DateFormatterUtils.formattedTime(now))",
            at: 0
        )

       tripTracker.handleAnnotationActivity(activity)
        
        //activeAnnotation = tripTracker.currentAnnotation()
        activeAnnotation =
                tripTracker.annotationManager.activeAnnotation

        lastCompletedAnnotation =
            tripTracker.annotationManager.lastCompletedAnnotation
    }
    
    func didTapGaze(_ gaze: GazeDirection) {
        selectedGaze = gaze

        let now = Date()
        lastGazeChangeTime = now

        annotationLog.insert(
            "Gaze → \(gaze.rawValue) @ \(DateFormatterUtils.formattedTime(now))",
            at: 0
        )

        tripTracker.updateGaze(gaze)
    }
}
