//
//  TripTrackerLifecycle.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import Foundation

extension TripTracker {
    
    func startTrip() {
        guard currentTrip == nil else { return }
        
        let tripIndex = tripIndexStore.next()
        currentTripIndex = tripIndex
        
        let trip = Trip(
            id: UUID(),
            startTime: Date(),
            endTime: nil,
            locations: [],
            annotations: []
        )
        
        currentTrip = trip
        print(" INDEX Trip started :", tripIndex)
        
        tripManager.startTrip(trip)
        
       // let sessionStart = trip.startTime
        
//        videoManager.startRecording(
//            sessionId: trip.id,
//            startTime: sessionStart
//        )
//
        // call delegate for user authorization to start tracking
        locationManager.requestPermission()
        
        // Track each frame from Location Manager
        locationManager.didCreateFrame = { [weak self] frame in
            self?.handleLocationFrame(frame)
        }
        
        locationManager.startUpdatingLocation()
        
       // setupPhysioStream()
        
    }
    
    
    func stopTrip() {
        //      printDocumentsPath()
        
        // create local variable current trip
        guard let currentTrip = currentTrip else { return }
        print("Trip stopped, \(currentTrip.locations.count) frames recorded:")
        
        // Tell TripManager the trip is done
        tripManager.endTrip(currentTrip)
        
        if let index = currentTripIndex {
            print("Saving trip index:", index)
            // save trip TO CSV with index
            try? tripCSVService.save(trip: currentTrip, tripIndex: index)
        
        }
        
        // Reset All
        
        locationManager.didCreateFrame = nil
        locationManager.stopUpdatingLocation()
        
        self.currentTrip = nil // update property current trip
        tripStartTime = nil
        currentTripIndex = nil
     //   print("finished reset of current trip.")
    }
}



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
