//
//  TrafficManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//

import Foundation
import CoreLocation

final class TrafficManager {

    private var lastSpeed: Double?
    private var lastTimestamp: Date?

    private var stopStart: Date?

    private var features = TrafficFeatures(
        stopCount: 0,
        totalStopTime: 0,
        lowSpeedTime: 0,
        avgSpeed: 0
    )

    // thresholds
    private let stopSpeedThreshold = 2.0
    private let lowSpeedThreshold = 15.0

    func update(speed: Double?, timestamp: Date) -> TrafficFeatures {

        guard let speed = speed else {
            return features
        }

        // STOP detection
        if speed < stopSpeedThreshold {
            if stopStart == nil {
                stopStart = timestamp
                features.stopCount += 1
            }
        } else {
            // how long the car stayed stopped, then reset.
            if let start = stopStart {
                features.totalStopTime += timestamp.timeIntervalSince(start)
                stopStart = nil
            }
        }

        // how many frames the car is moving slowly
        if speed < lowSpeedThreshold {
            features.lowSpeedTime += 1   // assume per frame
        }

        // simple running avg (optional)
        features.avgSpeed =
            (features.avgSpeed + speed) / 2

        lastSpeed = speed
        lastTimestamp = timestamp

        return features
    }
}

// MARK: - Traffic Flow Classification

extension TrafficManager {

    /// Converts raw traffic features into a traffic flow label
    /// This is a rule-based classifier (not ML)
    /// It maps driving patterns → traffic conditions
    func classify(_ f: TrafficFeatures) -> TrafficFlow {

        // MARK: Feature interpretation

        /// Number of full stops (e.g. red lights, congestion, roundabouts)
        let stopRate = f.stopCount

        /// Average time spent per stop
        /// (total stopped time divided by number of stops)
        let stopTimeRatio =
            f.totalStopTime / max(1, Double(f.stopCount))

        /// Total time spent moving slowly (crawling traffic)
        let lowSpeedTime = f.lowSpeedTime

        // MARK: - Congested flow (heavy traffic)

        /// Many stops OR very long stop durations
        if stopRate > 5 || stopTimeRatio > 10 {
            return .congestedFlow
        }

        // MARK: - Interrupted flow (signals / roundabouts / mild traffic)

        /// Some stops OR long periods of slow movement
        if stopRate > 2 || lowSpeedTime > 20 {
            return .interruptedFlow
        }

        // MARK: - Free flow (smooth driving)

        /// Low stops and minimal slow movement
        return .freeFlow
    }
}
