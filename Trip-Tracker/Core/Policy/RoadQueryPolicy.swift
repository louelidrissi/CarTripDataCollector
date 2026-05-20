//
//  Road.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/10/26.
//

import Foundation
import CoreLocation

final class RoadQueryPolicy {

    private let distanceThreshold: Double = 100
    private let timeThreshold: TimeInterval = 30

    private var lastRoadInfo: RoadInfo?
    private var lastLocation: CLLocationCoordinate2D?
    private var lastTime: Date?

    // BELOW does fetch constitute the function get Road Infox
    func getRoadInfoIfNeeded(
        coordinate: CLLocationCoordinate2D,
        timestamp: Date,
        fetch: (CLLocationCoordinate2D) async -> RoadInfo?
    ) async -> RoadInfo? {

        if shouldCallOverpass(coordinate: coordinate, timestamp: timestamp) {
            lastRoadInfo = await fetch(coordinate)
        }

        return lastRoadInfo
    }

    func shouldCallOverpass(
        coordinate: CLLocationCoordinate2D,
        timestamp: Date
    ) -> Bool {

        guard let lastLocation, let lastTime else {
            self.lastLocation = coordinate
            self.lastTime = timestamp
            return true
        }

        let distance =
            LocationUtils.haversineDistance(
                lat1: lastLocation.latitude,
                lon1: lastLocation.longitude,
                lat2: coordinate.latitude,
                lon2: coordinate.longitude
            )

        let timeDelta = timestamp.timeIntervalSince(lastTime)

        let shouldFetch =
            distance >= distanceThreshold ||
            timeDelta >= timeThreshold

        if shouldFetch {
            self.lastLocation = coordinate
            self.lastTime = timestamp
        }

        return shouldFetch
    }
}
