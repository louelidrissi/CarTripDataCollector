//
//  RoadManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/24/26.
//

import CoreLocation
import MapKit // iOS 26+ reverse geocoding

class RoadManager {
    // Dictionary with coordKey → RoadType for instant lookup of already classified points
    private var roadClassificationMap: [String: RoadType] = [:]
        
    public func getRoadType(_ coordinate: CLLocationCoordinate2D) async -> RoadType {
        
        // round up coords to 6 decimals
        let coordinateKey = String(format: "%.6f,%.6f", coordinate.latitude, coordinate.longitude)
        
        // check if road already classified in the dictionary
        if let knownClassification = roadClassificationMap[coordinateKey] {
            return knownClassification
        }
        
        // if not yet classified, geocode
        let newClassification = await performRoadClassification(coordinate)
        
        // add new road classification to map
        roadClassificationMap[coordinateKey] = newClassification
        
        return newClassification
        
    }
    
    private func performRoadClassification(_ coordinate: CLLocationCoordinate2D) async -> RoadType {
        
        // convert coords to CLLocation for MapKit API
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // reverse geocode to any type of roads/places in region,
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "" // add specific string to text search region
        
        // Search region around GPS point, i.e. 100 m x 100 m
        searchRequest.region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 100,  // north-south
                    longitudinalMeters: 100  // east-west
                )
        
        do {
            
            let localSearch = MKLocalSearch(request: searchRequest)
            let response = try await localSearch.start()
            
            // return response in an array of of roads matching the query and get the first item from it if matches found
            guard let bestMatch = response.mapItems.first else {
                return .localStreet
            }
            return extractRoadType(from: bestMatch)
        } catch {
                print("MapKit error: \(error)")
                return .unknown
            }
        
    }
    
    private func extractRoadType(from mapItem: MKMapItem) -> RoadType {
        let name = (mapItem.name ?? "").uppercased()

        guard let address = mapItem.address else {
            return .localStreet
        }
        let fullAddress = address.fullAddress.uppercased()

        print(" Name: '\(name)' | Address: '\(fullAddress)'")

        let highwayKeywords = ["A1", "A2", "N1", "N2", "AUTOROUTE"]
        let arterialKeywords = ["AV", "BD", "BOULEVARD", "AVENUE"]

        if highwayKeywords.contains(where: { name.contains($0) || fullAddress.contains($0) }) {
            return .highway
        }
        if arterialKeywords.contains(where: { name.contains($0) || fullAddress.contains($0) }) {
            return .arterial
        }
        if fullAddress.contains("N°") || fullAddress.contains("#") {
            return .residential
        }

        return .localStreet
    }
}


