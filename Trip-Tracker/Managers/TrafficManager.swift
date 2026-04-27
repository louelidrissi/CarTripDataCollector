//
//  TrafficManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//

import Foundation
import CoreLocation

class TrafficManager {
    // speed threshold for hours of the day ?? can i get it ??
    // it would depend on time of day. Think about it for now.
    private let neutralSpeedThresholds: [TrafficDensity: Double] = [
            .none: 1000,        // effectively unused
            .veryLight: 60,
            .light: 40,
            .moderate: 25,
            .heavy: 12,
            .veryHeavy: 0
        ]
    
    func density(speedKmh: Double?, roadType: RoadType) -> TrafficDensity {
        
        // unwrap speed to check if known
        guard let speed = speedKmh else {
                    return .unknown
                }
        
        // if stopping
        if speed < 2.0 {
                return .veryHeavy
            }

        let thresholds: [TrafficDensity: Double]

           switch roadType {
           case .highway:
               // Casablanca autoroute: 90–120 km/h = veryLight, 40–70 = moderate, < 40 = heavy
               thresholds = [
                   .veryLight: 90,
                   .light: 70,
                   .moderate: 50,
                   .heavy: 30
               ]

           case .arterial:
               // City boulevards / main roads
               thresholds = [
                   .veryLight: 50,
                   .light: 40,
                   .moderate: 25,
                   .heavy: 12
               ]
           case .localStreet, .residential:
                       // Small streets / residential
                       thresholds = [
                           .veryLight: 30,
                           .light: 20,
                           .moderate: 12,
                           .heavy: 6
                       ]

                   case .unknown:
                       // Neutral fallback: like arterial / mid‑day
                       thresholds = [
                           .veryLight: 50,
                           .light: 35,
                           .moderate: 20,
                           .heavy: 10
                       ]
                   }

    let sortedPairs = thresholds
                .sorted { pair1, pair2 in pair1.value > pair2.value }

            // Step 5: find the highest label whose threshold is lower than speed
            for (label, threshold) in sortedPairs {
                if speed > threshold {
                    return label
                }
            }

            // Below all thresholds → veryHeavy
            return .veryHeavy

    }
}

          
        
