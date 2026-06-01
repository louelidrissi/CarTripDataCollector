//
//  TripTackerEvent.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import Foundation

extension TripTracker {
    
    func handleAnnotationActivity(_ activity: DriverActivity) {
        // gets called from view passing by view model
        guard var trip = currentTrip else { return }
        
        // calls annotation logic (either start or close annotation) and update trip annotations
        if let annotation = annotationManager.updateActivityState(activity) {
            
            print("Annotation CLOSED:")
            print("start:", annotation.startTime)
            print("end:", annotation.endTime ?? Date())
            print("activity:", annotation.activity)
            print("gaze:", annotation.gaze)

            trip.annotations.append(annotation)
            
            print("Trip now has annotations:", trip.annotations.count)
            
        } else {
            print("Annotation STARTED (no close yet)")
        }

        currentTrip = trip
    }
    

    func updateGaze(_ gaze: GazeDirection) {
        annotationManager.updateGaze(gaze)
    }
    
    func currentAnnotation() -> DriverAnnotation? {
        annotationManager.getActiveAnnotation()
    }
}
