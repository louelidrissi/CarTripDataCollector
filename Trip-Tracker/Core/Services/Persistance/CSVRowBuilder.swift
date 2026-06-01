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
import Foundation
import CoreLocation

struct CSVRowBuilder {

    static func header() -> String {
        return [
            "trip_id",
            "frame_index",
            "timestamp",
            "latitude",
            "longitude",
            "speed_kmh",
            "temp_c",
            "weather_condition",
            "road_highway",
            "road_maxspeed",
            "road_lanes",
            "road_oneway",
            "road_tram",
            "traffic_level",
            "stop_count",
            "avg_speed",
            "driver_activity",
            "driver_gaze"
        ].joined(separator: ",")
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

        let activity = location.activity?.rawValue ?? ""
        let gaze = location.gaze?.rawValue ?? ""

        
        let maxSpeed = road?.maxSpeed.map { String($0) } ?? ""
        let lanes = road?.lanes.map { String($0) } ?? ""

        return """
        \(trip.id.uuidString),\
        \(index + 1),\
        \(timestamp),\
        \(location.coordinate.latitude),\
        \(location.coordinate.longitude),\
        \(speed.map { String($0) } ?? ""),\
        \(weather.map { String($0.tempC) } ?? ""),\
        \(weather?.condition ?? ""),\
        \(road?.highway ?? ""),\
        \(maxSpeed),\
        \(lanes),\
        \(road?.oneway == true ? "1" : "0"),\
        \(road?.hasTram == true ? "1" : "0"),\
        \(traffic?.level.rawValue ?? ""),\
        \(traffic.map { String($0.features.stopCount) } ?? ""),\
        \(traffic.map { String($0.features.avgSpeed) } ?? ""),\
        \(activity),\
        \(gaze)
        """
    }
}
