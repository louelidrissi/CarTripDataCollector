//
//  LocationUtils.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/10/26.
//

import Foundation
import CoreLocation

enum LocationUtils {

    static func haversineDistance(
        lat1: Double,
        lon1: Double,
        lat2: Double,
        lon2: Double
    ) -> Double {

        let R = 6371.0 // Earth radius in km

        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180

        let a =
            sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1 * .pi / 180) *
            cos(lat2 * .pi / 180) *
            sin(dLon / 2) * sin(dLon / 2)

        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return R * c
    }
}
