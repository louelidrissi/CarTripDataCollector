//
//  Traffic.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/25/26.
//
import Foundation

struct TrafficFeatures {
    var stopCount: Int
    var totalStopTime: TimeInterval
    var lowSpeedTime: TimeInterval
    var avgSpeed: Double
}

enum TrafficFlow {
    case freeFlow
    case interruptedFlow
    case congestedFlow
}
