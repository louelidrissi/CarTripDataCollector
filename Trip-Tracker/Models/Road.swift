//
//  Road.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/25/26.
//

import CoreLocation

struct RoadInfo: Codable {
    let type: RoadType
    let name: String?    // the actual road name from MapKit
}

// enum for CSV such as each case is a string, codable to save, and iterable
enum RoadType: String, Codable, CaseIterable {
    case highway     // A1, N1 autoroutes
    case arterial    // Bd, Av boulevards
    case localStreet // Rue normale
    case residential // House numbers
    case unknown     // Geocoding failed
}
