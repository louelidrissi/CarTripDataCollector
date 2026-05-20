//
//  WeatherManager.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

/*
    Fetch weather at location asynchronously
        (allows for code to run in between task start and end )
 
    Only fetch when weather changes
 
    Connect to openweathermap API
 
 */


/*
    JSON:
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
import CoreLocation


class WeatherManager {
    
    // PROPERTIES
    private let apiKey = Secrets.apiKey
    
    //previous coordinates for when weather was updated.
    private var prevWeatherLat: Double?
    private var prevWeatherLon: Double?
    
    // previous timestamp for when weather was updated.
    private var lastFetchTime: Date?
    
    // last fetched weather
    private var lastWeather: TripWeather?
    
    // Thresholds that determines when would weather be updated
    private let timeThreshold: TimeInterval = 15 * 60  // 15 minutes
    private let distanceThreshold: Double = 5.0        // 5 km
       
    var onApiCall: (() -> Void)?
    
    // HELPER FUNCTION 1
    private func updateLastFetch(lat: Double, lon: Double, updateTime: Bool = false) {
       
        prevWeatherLat = lat
        prevWeatherLon = lon
        if updateTime {
            lastFetchTime = Date()
        }
    }
   
    // HELPER FUNCTION 3
    private func extractTripWeather(from api: OpenWeatherResponse, at lat: Double, lon: Double) -> TripWeather {
        TripWeather(
            timestamp: Date(),
            lat: lat,
            lon: lon,
            tempC: api.main.temp,
            feelsLikeC: api.main.feelsLike,
            condition: api.weather[0].main,
            humidity: api.main.humidity,
            visibilityMeters: api.visibility ?? 10000,
            rainMMH: api.rain?.oneH ?? 0,
            cloudCoverPct: api.clouds.all
        )
    }
    
    
    // catch error when fetching and return nil since optional value in trip location
    // make sure when not fetched, return weather in memory 
    func fetchWeatherOrCached(coordinate: CLLocationCoordinate2D) async -> TripWeather? {
        if shouldFetchWeather(coordinate: coordinate) {
            do {
                let newWeather = try await fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude)
                lastWeather = newWeather
                return newWeather
            } catch {
                print("WeatherManager fetch error: \(error)")
                return lastWeather   // fall back to last
            }
        } else {
            return lastWeather
        }
    }
    
    // METHOD 1
    func shouldFetchWeather(coordinate: CLLocationCoordinate2D) -> Bool {
        
        // Unwrap safely current coordinate values
        let currentLat = coordinate.latitude
        let currentLon = coordinate.longitude
        
        // unwrap safely previous properties. First run, values are nil.
        guard let lastTime = lastFetchTime,
              let prevLat = prevWeatherLat,
              let prevLon = prevWeatherLon
        else {
            updateLastFetch(lat: currentLat, lon: currentLon,  updateTime: true)
            return true
        }
        
        // get current time and determine if time condition for update was met
        let now = Date()
        if now.timeIntervalSince(lastTime) >= timeThreshold {
            updateLastFetch(lat: currentLat, lon: currentLon,  updateTime: true)
            return true
        }
        
        // calculate current distance from last fetched weather (hypo)
        let distanceKm = LocationUtils.haversineDistance(lat1: prevLat, lon1: prevLon,
                lat2: currentLat, lon2: currentLon)

       // determine if distance condition for update was met
            // distance unit is in degrees, such as 0.01° ≈ 1.1 km
            // no arithmeticwith optional values (?)
        if distanceKm >= distanceThreshold {
            updateLastFetch(lat: currentLat, lon: currentLon,  updateTime: true)
            return true
        }
        
        // update previous values
        updateLastFetch(lat: currentLat, lon: currentLon)
        return false
    }

//    
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        return formatter.string(from: date)
//    }
//
    // METHOD 2
    func fetchWeather(lat: Double, lon: Double) async throws -> TripWeather { //removed since I want current, date: Date

        // use command (URL) from API Documentation to fetch weather data
        // reminder: APIs (URLS) is a string
        
        // convert date to String
        //let dateString = formatDate(date)
        
        // ! forces unwrapping,

        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather" )
        else {
            print("Invalid base URL")
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
//            URLQueryItem(name: "exclude", value: "hourly,daily,minutely,alerts"), // only current
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
        ]

        // catch url error
        guard let url = components.url else {
            print("weather response from URL failed")
            throw URLError(.badURL) // internal Swift error enum/static property
           
        }
        // get shared data if url doesn't fail
        // data is .., response is ...
        let (data, response) = try await URLSession.shared.data(from: url) // _ ignore value of HTTP metadata
        
        onApiCall?()
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        
        else {
            throw URLError(.badServerResponse)
        }
        
        let apiResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)

        let tripWeather = extractTripWeather(from: apiResponse, at: lat, lon: lon)

        // Update current coordinates to prev
        updateLastFetch(lat: lat, lon: lon,  updateTime: true)

        
        return tripWeather
            
        }
}
