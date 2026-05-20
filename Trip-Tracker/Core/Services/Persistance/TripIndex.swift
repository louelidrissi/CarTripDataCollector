//
//  TripIndex.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/15/26.
//

import Foundation

final class TripIndexStore {

    private let key = "trip_counter"

    // current saved value
    var current: Int {
        UserDefaults.standard.integer(forKey: key)
    }

    // returns next trip index (1, 2, 3...)
    func next() -> Int {
        let nextValue = current + 1
        UserDefaults.standard.set(nextValue, forKey: key)
        return nextValue
    }

    // optional reset (useful for testing)
    func reset() {
        UserDefaults.standard.set(0, forKey: key)
    }
}
