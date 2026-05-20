//
//  Weather.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/18/26.
//

/*
    Create a struct that would store info from openweathermap.
    JSON fields to fecth for saving :
          coord,
          weather,
          base,
          main,
          visibility,
          rain,
          clouds,
          dt,
          timezone
*/

import Foundation

// Raw OpenWeather API Response (Full JSON)
struct OpenWeatherResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherCondition]
    let base: String
    let main: MainConditions
    let visibility: Int?
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let timezone: Int
}

// Components (Helpers)
struct Coordinates: Codable {
    let lon, lat: Double
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String      // "Clear", "Rain"
    let description: String
    let icon: String
}

struct MainConditions: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

struct Clouds: Codable { let all: Int }
struct Rain: Codable {
    let oneH: Double?
    enum CodingKeys: String, CodingKey { case oneH = "1h" }
}

// FINAL TripWeather (final csv)
struct TripWeather: Codable {
    let timestamp: Date
    let lat: Double, lon: Double
    
    let tempC: Double
    let feelsLikeC: Double
    let condition: String
    let humidity: Int
    let visibilityMeters: Int
    let rainMMH: Double
    let cloudCoverPct: Int
}
