//
//  Traffic.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/25/26.
//
import Foundation

struct TrafficInfo: Codable {
    let features: TrafficFeatures
    let level: TrafficFlow
}

struct TrafficFeatures: Codable {
    var stopCount: Int
    var totalStopTime: TimeInterval
    var lowSpeedTime: TimeInterval
    var avgSpeed: Double
}

enum TrafficFlow: String, Codable {
    case freeFlow
    case interruptedFlow
    case congestedFlow
}
