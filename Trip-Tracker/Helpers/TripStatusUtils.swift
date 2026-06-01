//
//  TripStatusUtils.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/27/26.
//

import Foundation

func worse(_ a: TripStatus, _ b: TripStatus) -> TripStatus {
    let rank: [TripStatus: Int] = [
        .good: 0,
        .degraded: 1,
        .poor: 2
    ]

    return (rank[a] ?? 0) >= (rank[b] ?? 0) ? a : b
}
