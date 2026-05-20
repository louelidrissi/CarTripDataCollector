//
//  TripTrackerLocation.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//

import Foundation

/*
    handling location frame when trip in progress

 */

extension TripTracker {
    func handleLocationFrame(_ frame: LocationFrame){
        //print("Location frame: \(frame.coordinate)")
        
        guard var trip = currentTrip else { return }
        
        Task {
            let tripLocation = await locationPipeline.process(
                frame: frame
            )
            
            //print("Traffic: \(flow)")
            
         //   print("MAIN THREAD?", Thread.isMainThread)
            
            trip.locations.append(tripLocation)
         //   print("tripLocation", tripLocation)
            
       //     print("LOCATION:", tripLocation.coordinate)
         //   print("SPEED:", tripLocation.speedKmh ?? 0)
            
            currentTrip = trip
            
            viewModel?.updateCurrentLocation(tripLocation)
            viewModel?.incrementLocation()
            
        }
    }
}
