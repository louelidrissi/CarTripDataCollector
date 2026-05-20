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
    
    // dependencies
    // not private cause called in extention
   
    let tripManager: TripManager
    let locationManager: LocationManager // global by default ???
    let weatherManager: WeatherManager
    let roadManager: RoadManager
    //private let videoManager: VideoManager
    
    let locationPipeline: LocationPipeline
    
    //private let physioCollector: PhysioCollector
    
    // Helpers
    let roadQueryPolicy = RoadQueryPolicy()
    let trafficManager = TrafficManager()
    let annotationManager = AnnotationManager()
    
    var tripStartTime: Date?
    
    let tripCSVService: TripCSVService
    let tripIndexStore: TripIndexStore
    var currentTripIndex: Int?
    
    //    private let tripCSVManager = TripCSVManager()
    
    weak var viewModel: TripViewModel? // for live UI updates
    
    // inject dependencies
    init(
        locationManager: LocationManager,
        tripManager: TripManager,
        weatherManager: WeatherManager,
        roadManager: RoadManager,
        
        tripIndexStore: TripIndexStore,
        tripCSVService: TripCSVService
        // physioCollector: PhysioCollector
        // videoManager: VideoManager,
        //        roadQueryPolicy: RoadQueryPolicy
        //        trafficDensityManager: TrafficManager
        //viewModel: TripViewModel? = nil
    ) {
        self.locationManager = locationManager
        self.tripManager = tripManager
        self.weatherManager = weatherManager
        self.roadManager = roadManager
        //    self.physioCollector = physioCollector
        // self.videoManager = videoManager
        
        self.locationPipeline = LocationPipeline(
            weatherManager: weatherManager,
            roadManager: roadManager,
            viewModel: viewModel
        )
        
        self.tripIndexStore = tripIndexStore
        self.tripCSVService = tripCSVService
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
    
}
    











//    private func setupPhysioStream() {
//        let healthStream = HealthStreamService()
//
//        healthStream.onHR = { [weak self] value, time in
//            self?.physioCollector.handleHR(value: value, time: time)
//        }
//
//        healthStream.onHRV = { [weak self] value, time in
//            self?.physioCollector.handleHRV(value: value, time: time)
//        }
//
//        healthStream.requestAuthorization()
//        healthStream.startHRStream()
//        healthStream.startHRVStream()
//    }
    
    
//    private func handlePhysioSample(_ sample: PhysioSample) {
//        print("PHYSIO:", sample)
//        guard let start = tripStartTime else { return }
//        
//        let relativeTime = sample.timestamp.timeIntervalSince(start)
//        
//        print("Physio @", relativeTime)
//        
//        // Future:
//        // - align with GPS
//        // - build ML window
//        // - write to dataset
//    }
    
  
    
//    func printDocumentsPath() {
//        guard let docs = FileManager.default
//            .urls(for: .documentDirectory, in: .userDomainMask).first
//        else {
//            print("Could not get Documents folder")
//            return
//        }
//        print(" Documents path: \(docs.path)")
//    
//    }

