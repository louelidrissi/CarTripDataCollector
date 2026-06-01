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

    func save(trip: Trip, tripIndex: Int, filename: String = "trip_frames.csv") throws -> URL {

        let csvString = createCSVString(for: trip, tripIndex: tripIndex)

        let folderURL = documentsURL.appendingPathComponent("trips_csv")
        let fileURL = folderURL.appendingPathComponent(filename)

        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }

        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)

        print("Saved CSV to: \(fileURL)")

        return fileURL
    }
}

