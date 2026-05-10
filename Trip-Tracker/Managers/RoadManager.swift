//
//  RoadManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//

import Foundation
import CoreLocation

final class RoadManager {

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
          way(around:50,\(coordinate.latitude),\(coordinate.longitude))["highway"];
        );
        out tags geom;
        """
    }

   

    private func parseRoadInfo(
        tags: [String: String],
        highway: String
    ) -> RoadInfo {

        let lanes =
            Int(
                tags["lanes"]?
                    .split(separator: ";")
                    .first ?? ""
            )

        let maxSpeed =
            Double(
                tags["maxspeed"]?
                    .split(separator: " ")
                    .first ?? ""
            )

        let isRoundabout =
            tags["junction"] == "roundabout"

        let hasTram =
            tags["railway"] == "tram" ||
            tags["railway"] == "light_rail" ||
            tags["railway"] == "tram_stop"

        return RoadInfo(
            highway: highway,
            maxSpeed: maxSpeed,
            lanes: lanes,
            junction: isRoundabout ? "roundabout" : nil,
            oneway: tags["oneway"] == "yes",
            hasTram: hasTram
        )
    }
}
