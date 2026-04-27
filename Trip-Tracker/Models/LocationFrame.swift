//
//  LocationFrame.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

/*
    Temp struct.
    Saves data from location manager.
 */

import CoreLocation
import Foundation

struct LocationFrame {
    let timestamp: Date
    let coordinate: CLLocationCoordinate2D
    let speedKmh: Double?
}
