//
//  TrafficLevel.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/20/26.
//

final class TrafficClassifier {

    func classify(_ f: TrafficFeatures) -> TrafficFlow {

        let avgStopDuration =
            f.totalStopTime / max(1, Double(f.stopCount))

        // Heavy congestion
        if f.stopCount > 5
            || avgStopDuration > 10
            || f.lowSpeedTime > 120 {

            return .congestedFlow
        }

        // Moderate traffic
        if f.stopCount > 2
            || f.lowSpeedTime > 30 {

            return .interruptedFlow
        }

        // Smooth driving
        return .freeFlow
    }
}
