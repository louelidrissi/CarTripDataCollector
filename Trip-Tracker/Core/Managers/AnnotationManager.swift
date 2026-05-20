//
//  AnnotationManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//

/*
 
     updateActivityState.
         IF same button pressed:
             stop current annotation

         IF different button pressed:
             close current annotation
             start new one
         
 
 */

import Foundation



final class AnnotationManager {

    private(set) var activeAnnotation: DriverAnnotation?
    private(set) var lastCompletedAnnotation: DriverAnnotation?

    private var currentActivity: DriverActivity = .normalDriving
    private var currentGaze: GazeDirection = .forward
    
    // Helper 1
    private func startAnnotation() {
        activeAnnotation = DriverAnnotation(
            startTime: Date(),
            endTime: nil,
            gaze: currentGaze,
            activity: currentActivity
        )
        print("🟣 START annotation:", activeAnnotation!)
    }
    
    // Helper 2
    private func closeAnnotation() -> DriverAnnotation? {

        guard var annotation = activeAnnotation else {
            print("🔴 No active annotation to close")
            return nil
        }

        annotation.endTime = Date()
        
        print("🔵 CLOSE annotation:")
            print("start:", annotation.startTime)
            print("end:", annotation.endTime!)

        lastCompletedAnnotation = annotation
        
        activeAnnotation = nil
        
        return annotation
    }
    
    // Main Method
    func updateActivityState(_ activity: DriverActivity) -> DriverAnnotation? {

        // if tapping same activity then end annotation
        if currentActivity == activity {

            currentActivity = .normalDriving // go back to default

            let finished = closeAnnotation() // set end time to now and active anotation to nil
            return finished // returns final annotation
        }

        // if some annotation was active, end it
        let finished = closeAnnotation()

        currentActivity = activity // update activity being selected right now

        startAnnotation() // start new annotation

        return finished // annotation with no end time
    }

    func updateGaze(_ gaze: GazeDirection) {
        currentGaze = gaze
    }
    
    func getActiveAnnotation() -> DriverAnnotation? {
        activeAnnotation
    }

}
