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

    // Expected road speed (km/h)
    let maxSpeed: Double?

    // Number of lanes
    let lanes: Int?

    // Example:
    // "roundabout"
    let junction: String?

    // One direction road
    let oneway: Bool

    // Whether tram rails/tracks exist nearby
    let hasTram: Bool
}
