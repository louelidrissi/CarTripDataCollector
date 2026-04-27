//
//  TripManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

/*
 Current trip is obsesrved
 */
import SwiftData
import Foundation // for dates
import Combine

final class TripManager: ObservableObject {

    @Published var trips: [Trip] = []
    @Published var currentTrip: Trip? = nil
    
    func startTrip(_ trip: Trip) {
            currentTrip = trip
        }

    func endTrip(_ finishedTrip: Trip) {
        trips.append(finishedTrip)
        currentTrip = nil
    }
}

