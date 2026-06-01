//
//  Road.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/25/26.
//

import Foundation

struct RoadInfo: Codable {

    // Main road classification
    let highway: String?
    let ref: String?
    let area: String?

    // Expected road speed (km/h)
    let maxSpeed: Double?
    
    let lanes: Int?
    // One direction road
    let oneway: Bool
    // "roundabout"
    let junction: String?
    // Whether tram rails/tracks exist nearby
    let hasTram: Bool
}

enum RoadContext {
    case highway
    case mainRoad
    case localRoad
    case serviceRoad
}
