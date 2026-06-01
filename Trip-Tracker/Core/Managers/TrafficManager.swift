//
//  TrafficManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//

import Foundation
import CoreLocation
final class TrafficManager {

    // MARK: - State

    private var lastTimestamp: Date?
    private var stopStart: Date?
    private var isStopped = false

    private var speedSampleCount = 0

    // MARK: - Features

    private var features = TrafficFeatures(
        stopCount: 0,
        totalStopTime: 0,
        lowSpeedTime: 0,
        avgSpeed: 0
    )

    // MARK: - Thresholds (km/h)

    private let stopEnterThreshold = 2.0
    private let stopExitThreshold = 5.0
    private let lowSpeedThreshold = 15.0

    // MARK: - Update (speed is already km/h)

    func update(speed: Double?, timestamp: Date) -> TrafficFeatures {

        guard let speed = speed else {
            lastTimestamp = timestamp
            return features
        }

        defer {
            lastTimestamp = timestamp
        }

        guard let lastTimestamp else {
            self.lastTimestamp = timestamp
            return features
        }

        let deltaTime = timestamp.timeIntervalSince(lastTimestamp)

        // MARK: - STOP DETECTION (hysteresis)

        if !isStopped && speed < stopEnterThreshold {

            isStopped = true
            stopStart = timestamp
            features.stopCount += 1
        }

        if isStopped && speed > stopExitThreshold {

            isStopped = false

            if let stopStart {
                features.totalStopTime += timestamp.timeIntervalSince(stopStart)
            }

            self.stopStart = nil
        }

        // MARK: - LOW SPEED TIME (time-based)

        if speed < lowSpeedThreshold {
            features.lowSpeedTime += deltaTime
        }

        // MARK: - AVERAGE SPEED (correct running average)

        speedSampleCount += 1

        features.avgSpeed =
            (features.avgSpeed * Double(speedSampleCount - 1) + speed)
            / Double(speedSampleCount)

        return features
    }

    // MARK: - Classification

    func classify(_ f: TrafficFeatures) -> TrafficFlow {

        let avgStopDuration =
            f.totalStopTime / max(1, Double(f.stopCount))

        // Heavy congestion
        if f.stopCount > 5 ||
           avgStopDuration > 10 ||
           f.lowSpeedTime > 120 {

            return .congestedFlow
        }

        // Moderate traffic
        if f.stopCount > 2 ||
           f.lowSpeedTime > 30 {

            return .interruptedFlow
        }

        return .freeFlow
    }

    // MARK: - Finalize Trip

    func finalizeTrip(at timestamp: Date) {

        guard isStopped, let stopStart else { return }

        features.totalStopTime += timestamp.timeIntervalSince(stopStart)

        self.stopStart = nil
        isStopped = false
    }
}


//
//final class TrafficManager {
//
//    // MARK: - State
//
//    private var lastTimestamp: Date?
//
//    private var stopStart: Date?
//
//    private var isStopped = false
//
//    private var speedSampleCount = 0
//
//    // MARK: - Features
//
//    private var features = TrafficFeatures(
//        stopCount: 0,
//        totalStopTime: 0,
//        lowSpeedTime: 0,
//        avgSpeed: 0
//    )
//
//    // MARK: - Thresholds (km/h)
//
//    /// Enter stop state
//    private let stopEnterThreshold = 2.0
//
//    /// Exit stop state
//    private let stopExitThreshold = 5.0
//
//    /// Crawling / dense traffic
//    private let lowSpeedThreshold = 15.0
//
//    // MARK: - Update
//
//    func update(speed: Double?, timestamp: Date) -> TrafficFeatures {
//
//        guard let speedMS = speed else {
//            return features
//        }
//
//        // Convert CoreLocation m/s → km/h
//        let speed = speedMS * 3.6
//
//        defer {
//            lastTimestamp = timestamp
//        }
//
//        guard let lastTimestamp else {
//            lastTimestamp = timestamp
//            return features
//        }
//
//        let deltaTime =
//            timestamp.timeIntervalSince(lastTimestamp)
//
//        // MARK: - Stop Detection
//
//        // Enter stop state
//        if !isStopped && speed < stopEnterThreshold {
//
//            isStopped = true
//
//            stopStart = timestamp
//
//            features.stopCount += 1
//        }
//
//        // Exit stop state
//        if isStopped && speed > stopExitThreshold {
//
//            isStopped = false
//
//            if let stopStart {
//
//                features.totalStopTime +=
//                    timestamp.timeIntervalSince(stopStart)
//            }
//
//            self.stopStart = nil
//        }
//
//        // MARK: - Low Speed Time
//
//        if speed < lowSpeedThreshold {
//
//            features.lowSpeedTime += deltaTime
//        }
//
//        // MARK: - Running Average Speed
//
//        speedSampleCount += 1
//
//        features.avgSpeed =
//            (
//                features.avgSpeed
//                * Double(speedSampleCount - 1)
//                + speed
//            )
//            / Double(speedSampleCount)
//
//        return features
//    }
//}
//
//
////
////final class TrafficManager {
////
////    private var lastSpeed: Double?
////    private var lastTimestamp: Date?
////
////    private var stopStart: Date?
////
////    private var features = TrafficFeatures(
////        stopCount: 0,
////        totalStopTime: 0,
////        lowSpeedTime: 0,
////        avgSpeed: 0
////    )
////
////    // thresholds
////    private let stopSpeedThreshold = 2.0
////    private let lowSpeedThreshold = 15.0
////
////    func update(speed: Double?, timestamp: Date) -> TrafficFeatures {
////
////        guard let speed = speed else {
////            return features
////        }
////
////        // STOP detection
////        if speed < stopSpeedThreshold {
////            if stopStart == nil {
////                stopStart = timestamp
////                features.stopCount += 1
////            }
////        } else {
////            // how long the car stayed stopped, then reset.
////            if let start = stopStart {
////                features.totalStopTime += timestamp.timeIntervalSince(start)
////                stopStart = nil
////            }
////        }
////
////        // how many frames the car is moving slowly
////        if speed < lowSpeedThreshold {
////            features.lowSpeedTime += 1   // assume per frame
////        }
////
////        // simple running avg (optional)
////        features.avgSpeed =
////            (features.avgSpeed + speed) / 2
////
////        lastSpeed = speed
////        lastTimestamp = timestamp
////
////        return features
////    }
////}
