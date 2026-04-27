//
//  Trip.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//
import Foundation
import CoreLocation

/*
    Tip Model.
    & Trip Location Model.
*/

// only built in types are codable
// coord2D are core location structs

struct TripLocation: Codable {
    let timestamp: Date
    let lat: Double
    let lon: Double // unwrap below since not codable by default
    let speedKmh: Double?
    let weather: TripWeather?
    let roadInfo: RoadInfo
    let trafficDensity: TrafficDensity
    
    init(
            timestamp: Date,
            coordinate: CLLocationCoordinate2D,
            speedKmh: Double?,
            weather: TripWeather?,
            roadInfo: RoadInfo,
            trafficDensity: TrafficDensity,
            
        ) {
            self.timestamp = timestamp
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
            self.speedKmh = speedKmh
            self.weather = weather
            self.roadInfo = roadInfo
            self.trafficDensity = trafficDensity
        }
    
    var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
}

struct Trip: Codable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var locations: [TripLocation]
}
