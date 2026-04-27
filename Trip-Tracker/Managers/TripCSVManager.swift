//
//  TripCSVManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/18/26.
//

import Foundation

class TripCSVManager {
    private let fileManager: FileManager
    private let documentsURL: URL //file path is represented by a URL, not a path‑string.
    
    // initiate File Manager & URL
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.documentsURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)[0] // in iOS has only one dir, get it
    }
    
    func save(trip: Trip, filename: String = "trip_frames.csv") throws {
        // create string from Trip
        let csvString = createCSVString(for: trip)

        // create objects/pointers of nested path by appending path to component to a path componenet
        let folderURL = documentsURL.appendingPathComponent("trips_csv")
        let fileURL = folderURL.appendingPathComponent(filename)
        
        //print("💾 CSV will be saved to: \(url.absoluteString)")

        // If no file exist at dir, creat it
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        // add to file
        try csvString.write(
            to: fileURL,
            atomically: true, // make sure only complete/untruncated files are saved by writing first on a temp file if app crashes or disk has no space
            encoding: .utf8 // set rule to write chars into bytes in fileURL
        )

        print("Saved CSV to: \(fileURL)")
    }
    
    func createCSVString(for trip: Trip) -> String {
        let csvHeader = "trip_id,frame_index,timestamp,lat,lon,speed_kmh,temp_c,weather_condition,road_type,road_name,traffic_density\n"// no space
        
        var rows: [String] = [csvHeader]
        
        // get the values of all properties for each trip
        for (index, location) in trip.locations.enumerated() {
            let timestamp = location.timestamp.iso8601_zzz // date format, see extension below
            let speed = location.speedKmh ?? 0.0
            let tempC = location.weather?.tempC ?? -999.0
            let condition = location.weather?.condition ?? "unknown"
            let roadType = location.roadInfo.type.rawValue
            let roadName = location.roadInfo.name ?? "unknown"
            let trafficDensity = location.trafficDensity.rawValue.capitalized
            
            // make a row with all the properties to be stored
            let row = "\(trip.id.uuidString),\(index + 1),\"\(timestamp)\",\(location.lat),\(location.lon),\(speed),\(tempC),\"\(condition)\",\"\(roadType)\",\"\(roadName)\",\"\(trafficDensity)\"\n"
            rows.append(row)
        }
        return rows.joined()
        
    
    }
}

// date helper
extension Date {
    var iso8601_zzz: String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.string(from: self)
    }
}
