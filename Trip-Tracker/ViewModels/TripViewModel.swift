//
//  TripViewModel.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//
import Foundation
import Combine // published is built on combine

@MainActor
final class TripViewModel: ObservableObject {

    // UI State

    @Published var isTracking = false

    @Published var currentTemp: Double = 0
    @Published var condition: String = "?"

    @Published var currentLocation: TripLocation?
    @Published var currentRoadInfo: RoadInfo?

    @Published var locationsCount = 0

    @Published var selectedGaze: GazeDirection = .forward
    @Published var selectedActivity: DriverActivity = .normalDriving

    @Published var lastActivityChangeTime: Date?
    @Published var lastGazeChangeTime: Date?

    @Published var annotationLog: [String] = []

    @Published var activeAnnotation: DriverAnnotation?
    @Published var lastCompletedAnnotation: DriverAnnotation?

    // Health State

    @Published var tripStatus: TripStatus = .good
    @Published var weatherStatus: TripStatus = .good
    @Published var roadStatus: TripStatus = .good

    // Dependencies

    private let tripTracker: TripTracker
    private let tripStatusEval = TripStatusEval()
    
    private let csvService = TripCSVService()
    private let tripIndexStore = TripIndexStore()

    //  Init

    init(tripTracker: TripTracker) {
        self.tripTracker = tripTracker
        self.tripTracker.viewModel = self

        print("VM INIT:", ObjectIdentifier(self))
    }

    // Trip Control

    func startTripVM() {
        isTracking = true
        tripTracker.startTripFromViewModel()
    }

    func stopTripVM() {
        isTracking = false
        tripTracker.stopTripFromViewModel()
    }

    //  Location Updates

    func updateCurrentLocation(_ location: TripLocation) {
        currentLocation = location
        currentRoadInfo = location.roadInfo
        incrementLocation()

        refreshTripStatus()
    }

    func incrementLocation() {
        locationsCount += 1
    }

    //  Weather UI update (optional display only)

    func updateWeather(temp: Double, condition: String) {
        currentTemp = temp
        self.condition = condition
    }

    // STATUS ENGINE (single source of truth)

    func refreshTripStatus() {

        let weather = tripStatusEval.evaluate(
            weatherSuccess: tripTracker.weatherManager.successTime,
            weatherFailure: tripTracker.weatherManager.failureTime,
            roadSuccess: nil,
            roadFailure: nil
        )

        let road = tripStatusEval.evaluate(
            weatherSuccess: nil,
            weatherFailure: nil,
            roadSuccess: tripTracker.roadManager.successTime,
            roadFailure: tripTracker.roadManager.failureTime
        )

        weatherStatus = weather
        roadStatus = road

        tripStatus = worse(weather, road)
    }

    //  User interactions

    func didTapActivity(_ activity: DriverActivity) {

        selectedActivity = activity

        let now = Date()
        lastActivityChangeTime = now

        annotationLog.insert(
            "Activity → \(activity.rawValue) @ \(DateFormatterUtils.formattedTime(now))",
            at: 0
        )

        tripTracker.handleAnnotationActivity(activity)

        activeAnnotation = tripTracker.annotationManager.activeAnnotation
        lastCompletedAnnotation = tripTracker.annotationManager.lastCompletedAnnotation
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
