//
//  RoadManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//
import Foundation
import CoreLocation


final class RoadManager {

    var onApiCall: (() -> Void)?
    

    // Trip health tracking
    private var lastSuccessTime: Date?
    private var lastFailureTime: Date?
    
    var successTime: Date? {
           lastSuccessTime
       }

   var failureTime: Date? {
       lastFailureTime
   }


    private let overpassURL =
        "https://overpass-api.de/api/interpreter"

    // Public API

    func getRoadInfo(
        at coordinate: CLLocationCoordinate2D
    ) async -> RoadInfo? {

        print("BEFORE CALLING OVERPASS")

        let query = buildOverpassQuery(for: coordinate)

        guard let url = URL(string: overpassURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = query.data(using: .utf8)

        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        do {
            onApiCall?() // API event (request started)
            
            let (data, response) = try await URLSession.shared.data(for: request)

            //  HTTP validation
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                lastFailureTime = Date()
                return nil
            }

            // Detect Overpass HTML fallback
            if let raw = String(data: data, encoding: .utf8) {

                print("OSM response:", raw)

                // Overpass timeout HTML page
                if raw.contains("<html") {
                    print("Received HTML instead of JSON")
                    lastFailureTime = Date()
                    return nil
                }
            }
            
            // JSON parsing
            guard
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let elements = json["elements"] as? [[String: Any]]
            else {
                lastFailureTime = Date()
                return nil
            }
            
            // Extract first roa
            for element in elements {
                
                guard
                    let tags = element["tags"] as? [String: String],
                    let highway = tags["highway"]
                else {
                    continue
                }
                
                let road = parseRoadInfo(tags: tags, highway: highway)
                
                lastSuccessTime = Date() // SUCCESS tracking

                return road
            }
            
            return nil

        } catch {
            lastFailureTime = Date() // FAILURE tracking
            print("RoadManager error:", error)
            return nil
        } 
    }

    // Overpass query

    private func buildOverpassQuery(
        for coordinate: CLLocationCoordinate2D
    ) -> String {

        return """
        [out:json];
        (
          way(around:50,\(coordinate.latitude),\(coordinate.longitude))["highway"];
        );
        out tags;
        """
    }

    // Parsing

    private func parseRoadInfo(
        tags: [String: String],
        highway: String
    ) -> RoadInfo {

        let ref = tags["ref"]

        let area =
            tags["name"] ??
            tags["addr:city"] ??
            tags["addr:suburb"]

        let maxSpeed = parseMaxSpeed(tags["maxspeed"])
        let lanes = parseInt(tags["lanes"])

        let isRoundabout = tags["junction"] == "roundabout"
        let junction = isRoundabout ? "roundabout" : tags["junction"]

        let oneway =
            tags["oneway"] == "yes" ||
            tags["oneway"] == "1" ||
            tags["oneway"] == "-1"

        let hasTram =
            tags["railway"] == "tram" ||
            tags["railway"] == "light_rail" ||
            tags["railway"] == "tram_stop"

        return RoadInfo(
            highway: highway,
            ref: ref,
            area: area,
            maxSpeed: maxSpeed,   // ALWAYS km/h now
            lanes: lanes,
            oneway: oneway,
            junction: junction,
            hasTram: hasTram
        )
    }

    // Helpers

    private func parseMaxSpeed(_ value: String?) -> Double? {
        guard let value else { return nil }

        let cleaned = value.lowercased()
            .trimmingCharacters(in: .whitespaces)

        // Extract numeric part (handles "50 mph", "50", "30 km/h")
        let numberString = cleaned.split(separator: " ").first ?? ""
        guard let speed = Double(numberString) else {
            return nil
        }

        // Convert mph → km/h
        if cleaned.contains("mph") {
            return speed * 1.60934
        }

        // Default assumption: km/h
        return speed
    }

    private func parseInt(_ value: String?) -> Int? {
        guard let value else { return nil }
        let first = value.split(separator: ";").first ?? ""
        return Int(first)
    }
}
