//
//  CSVRowBuilder.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/15/26.
//
/*
    Notes: use .rawValue to convert enum to string in this case
 */
import Foundation
import CoreLocation

struct CSVRowBuilder {

    static func header() -> String {
        return """
        trip_id,frame_index,timestamp,latitude,longitude,speed_kmh,temp_c,weather_condition,road_highway,road_ref,road_area,road_maxspeed,road_lanes,road_oneway,road_tram,traffic_level,stop_count,avg_speed
        """
    }

    static func buildRow(
        trip: Trip,
        index: Int,
        location: TripLocation
    ) -> String {

        let timestamp = location.timestamp.timestampISO8601

        let speed = location.speedKmh
        let weather = location.weather
        let road = location.roadInfo
        let traffic = location.traffic

        return """
        \(trip.id.uuidString),\(index + 1),\(timestamp),\(location.coordinate.latitude),\(location.coordinate.longitude),\(speed ?? -1),\(weather?.tempC ?? -999),\(weather?.condition ?? "unknown"),\(road?.highway ?? "unknown"),\(road?.ref ?? "unknown"),\(road?.area ?? "unknown"),\(road?.maxSpeed ?? -1),\(road?.lanes ?? -1),\(road?.oneway ?? false),\(road?.hasTram ?? false),\(traffic?.level.rawValue ?? "unknown"),\(traffic?.features.stopCount ?? -1),\(traffic?.features.avgSpeed ?? -1)
        """
    }
}
