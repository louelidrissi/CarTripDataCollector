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

        guard let currentTrip = currentTrip else { return }
        guard let index = currentTripIndex else { return }
        
        tripManager.endTrip(currentTrip)

        do {
            let fileURL = try tripCSVService.save(trip: currentTrip, tripIndex: index)

            // share right after saving
            shareFile(url: fileURL)

        } catch {
            print("CSV save failed:", error)
        }
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
