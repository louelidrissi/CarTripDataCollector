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

    private let overpassURL =
        "https://overpass-api.de/api/interpreter"


    func getRoadInfo(
        at coordinate: CLLocationCoordinate2D
    ) async -> RoadInfo? {

        print("BEFORE CALLING OVERPASS")

        let query =
            buildOverpassQuery(
                for: coordinate
            )

        guard let url = URL(string: overpassURL) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody =
            query.data(
                using: .utf8
            )

        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            let (data, _) =
                try await URLSession.shared.data(
                    for: request
                )
            onApiCall?()

            if let raw =
                String(
                    data: data,
                    encoding: .utf8
                ) {
                print("OSM response:", raw)
            }

            guard
                let json =
                    try JSONSerialization.jsonObject(
                        with: data
                    ) as? [String: Any],
                let elements =
                    json["elements"] as? [[String: Any]]
            else {
                return nil
            }

            for element in elements {

                guard
                    let tags =
                        element["tags"] as? [String: String],
                    let highway =
                        tags["highway"]
                else {
                    continue
                }

                return parseRoadInfo(
                    tags: tags,
                    highway: highway
                )
            }

            return nil

        } catch {

            print("RoadManager error:", error)

            return nil
        }
    }
    
    private func buildOverpassQuery(
        for coordinate: CLLocationCoordinate2D
    ) -> String {

        return """
        [out:json];
        (
          way(around:20,\(coordinate.latitude),\(coordinate.longitude))["highway"];
        );
        out geom;
        """
    }

   

    private func parseRoadInfo(
        tags: [String: String],
        highway: String
    ) -> RoadInfo {
        
        let ref = tags["ref"]

        let area =
           tags["name"] ??
           tags["addr:city"] ??
           tags["addr:suburb"]

        let maxSpeed = parseDouble(tags["maxspeed"])
        
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
            maxSpeed: maxSpeed,
            lanes: lanes,
            oneway: oneway,
            junction: junction,
            hasTram: hasTram
        )
    }
}

private func parseInt(_ value: String?) -> Int? {
        guard let value else { return nil }
        let first = value.split(separator: ";").first ?? ""
        return Int(first)
    }

private func parseDouble(_ value: String?) -> Double? {
    guard let value else { return nil }
    let first = value.split(separator: " ").first ?? ""
    return Double(first)
}



//final class OverpassClient {
//
//    private let urlString = "https://overpass-api.de/api/interpreter"
//
//    func fetchWays(
//        at coordinate: CLLocationCoordinate2D
//    ) async throws -> [[String: Any]] {
//
//        let query = """
//        [out:json];
//        (
//          way(around:50,\(coordinate.latitude),\(coordinate.longitude))["highway"];
//        );
//        out tags;
//        """
//
//        guard let url = URL(string: urlString) else {
//            return []
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = query.data(using: .utf8)
//
//        request.setValue(
//            "application/x-www-form-urlencoded",
//            forHTTPHeaderField: "Content-Type"
//        )
//
//        let (data, _) = try await URLSession.shared.data(for: request)
//
//        guard
//            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//            let elements = json["elements"] as? [[String: Any]]
//        else {
//            return []
//        }
//
//        return elements
//    }
//}
