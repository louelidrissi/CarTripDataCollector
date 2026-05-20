//
//  TripCSVManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/18/26.
//

import Foundation

class TripCSVService {

    private let fileManager: FileManager
    private let documentsURL: URL

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.documentsURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func createCSVString(for trip: Trip, tripIndex: Int) -> String {

        var rows: [String] = []

        // HEADER FIRST
        rows.append(CSVRowBuilder.header())

        // DATA ROWS
        for (index, location) in trip.locations.enumerated() {
            let row = CSVRowBuilder.buildRow(
                trip: trip,
                index: index,
                location: location
            )
            rows.append(row)
        }

        return rows.joined(separator: "\n")
    }

    func save(trip: Trip, tripIndex: Int, filename: String = "trip_frames.csv") throws {

        let csvString = createCSVString(for: trip, tripIndex: tripIndex)

        let folderURL = documentsURL.appendingPathComponent("trips_csv")
        let fileURL = folderURL.appendingPathComponent(filename)

        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        try csvString.write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )

        print("Saved CSV to: \(fileURL)")
    }
}


//class TripCSVService {
//    
//    // Stored properties
//    private let fileManager: FileManager // System API used to manage files and directories
//    private let documentsURL: URL // Base URL to the app's Documents directory (file system path represented as URL)
//    
//    private let csvHeader =
//    "trip_id,frame_index,timestamp,lat,lon,speed,weather_temp,weather_condition,road_highway,road_max_speed,road_lanes,has_tram,traffic_flow,stop_count,avg_speed\n" // no space
//    
//    // Dependency injection (for testability and flexibility)
//    init(fileManager: FileManager = .default) {
//        self.fileManager = fileManager
//        
//        // urls(for:in:) returns an array of URLs
//        self.documentsURL = fileManager
//            .urls(for: .documentDirectory, in: .userDomainMask)[0] // iOS returns an array, but only one Documents directory exists in App Sandbox, so we take first one found
//    }
//    
//    // Helper
//    func createCSVString(for trip: Trip, tripIndex: Int) -> String {
//
//        var rows: [String] = [csvHeader] // // Initialize CSV with header row array
//        
//        // Convert each location frame into a CSV row
//        for (index, location) in trip.locations.enumerated() {
//            let row = CSVRowBuilder.buildRow(
//                    trip: trip,
//                    index: index,
//                    location: location
//            )
//            rows.append(row)
//        }
//        return rows.joined()
//        
//    
//    }
//    
//    // Method
//    func save(trip: Trip,tripIndex: Int, filename: String = "trip_frames.csv") throws {
//        // Convert Trip model into CSV formatted string
//        let csvString = createCSVString(for: trip, tripIndex: tripIndex)
//
//        // Build file path
//        
//        // Create folder and file URLs inside Documents directory
//        let folderURL = documentsURL.appendingPathComponent("trips_csv")
//        let fileURL = folderURL.appendingPathComponent(filename)
//        
//        //print("CSV will be saved to: \(url.absoluteString)")
//        
//        // Create directory if it doesn't already exist
//        if !fileManager.fileExists(atPath: folderURL.path) {
//            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
//        }
//        
//        // Write CSV string to file
//        try csvString.write(
//            to: fileURL,
//            atomically: true, // make sure only complete/untruncated files are saved by writing first on a temp file if app crashes or disk has no space
//            encoding: .utf8 // set rule to write chars into bytes in fileURL
//        )
//
//        print("Saved CSV to: \(fileURL)")
//    }
//}
