//
//  TripStatusEval.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/27/26.
//

/*
     Check how fresh data must be to trust it.
         ≤ 5 min old → GOOD
         5–15 min old → DEGRADED
         15 min old → POOR
 
 */
import Foundation

enum TripStatus {
    case good
    case degraded
    case poor
}

final class TripStatusEval {

    private let goodThreshold: TimeInterval = 60 * 5
    private let degradedThreshold: TimeInterval = 60 * 15

    func evaluate(
        weatherSuccess: Date?,
        weatherFailure: Date?,
        roadSuccess: Date?,
        roadFailure: Date?
    ) -> TripStatus {

        let now = Date()

        let weatherScore = score(
            success: weatherSuccess,
            failure: weatherFailure,
            now: now
        )

        let roadScore = score(
            success: roadSuccess,
            failure: roadFailure,
            now: now
        )
        
        // system is only as strong as its weakest part.
        switch min(weatherScore, roadScore) {
        case 0: return .good
        case 1: return .degraded
        default: return .poor
        }
    }

    private func score(
        success: Date?,
        failure: Date?,
        now: Date
    ) -> Int {
        
        // If it failed recently → treat system as BAD immediately
        if let failure, now.timeIntervalSince(failure) < goodThreshold {
            return 2
        }
        
        // If we never got data → system is BAD
        guard let success else { return 2 }

        // check freshness
        let age = now.timeIntervalSince(success)

        if age <= goodThreshold { return 0 }
        if age <= degradedThreshold { return 1 }
        return 2
    }
}
