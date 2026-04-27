//
//  Traffic.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/25/26.
//

enum TrafficDensity: String, Codable {
    case none          // no traffic influence (stationary or off‑road)
    case veryLight     // almost no vehicles
    case light         // light flow
    case moderate      // normal flow
    case heavy         // noticeably slow
    case veryHeavy     // crawling / stop‑and‑go
    case unknown       // cannot determine
}
