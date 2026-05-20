//
//  LocationPipeline.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//

final class LocationPipeline {

    private let weatherManager: WeatherManager
    private let roadManager: RoadManager
    
    private let trafficManager = TrafficManager()
    private let roadPolicy = RoadQueryPolicy()
    
    private weak var viewModel: TripViewModel?

    // where connection of systems happen
    init(weatherManager: WeatherManager,
         roadManager: RoadManager,
         viewModel: TripViewModel?) {
        self.weatherManager = weatherManager
        self.roadManager = roadManager
        self.viewModel = viewModel
        
        self.weatherManager.onApiCall = {  [weak self] in
                    Task { @MainActor in
                        viewModel?.incrementWeather()
                    }
                }
        self.roadManager.onApiCall = { [weak self] in
             Task { @MainActor in
                 viewModel?.incrementRoad()
             }
         }
    }

    func process(frame: LocationFrame) async -> TripLocation {

        let weather = await weatherManager.fetchWeatherOrCached(
            coordinate: frame.coordinate
        )
        //print("WEATHER RESULT:", weather)
        
        let roadInfo = await roadPolicy.getRoadInfoIfNeeded(
            coordinate: frame.coordinate,
            timestamp: frame.timestamp,
            fetch: { coord in
                await roadManager.getRoadInfo(at: coord)
            }
        )
        
        // debugging

//        if let roadInfo {
//
//            print("🛣 ROAD INFO (Pipeline)")
//
//            print("highway:", roadInfo.highway ?? "nil")
//            print("ref:", roadInfo.ref ?? "nil")
//            print("area:", roadInfo.area ?? "nil")
//
//            print("lanes:", roadInfo.lanes ?? -1)
//            print("maxSpeed:", roadInfo.maxSpeed ?? -1)
//
//            print("oneway:", roadInfo.oneway)
//            print("junction:", roadInfo.junction ?? "nil")
//            print("tram:", roadInfo.hasTram)
//        }

//        
        let features = trafficManager.update(
            speed: frame.speedKmh,
            timestamp: frame.timestamp
        )

        let flow = trafficManager.classify(features)

        let traffic = TrafficInfo(
            features: features,
            level: flow
        )

        return TripLocation(
            timestamp: frame.timestamp,
            coordinate: frame.coordinate,
            speedKmh: frame.speedKmh,
            weather: weather,
            roadInfo: roadInfo,
            traffic: traffic
        )
    }
}





//            let weather = await weatherManager.fetchWeatherOrCached(coordinate: frame.coordinate)
//
//            if let weather = weather {
//
//                viewModel?.updateWeather(
//                    temp: weather.tempC,
//                    condition: weather.condition
//                )
//
//                viewModel?.incrementApiCall()
//
//                //print("API Weather: \(weather.tempC)°C \(weather.condition)")
//            } else {
//                print(" Cached weather")
//            }
//
//            let roadInfo = await roadQueryPolicy.getRoadInfoIfNeeded(
//                coordinate: frame.coordinate,
//                timestamp: frame.timestamp,
//                fetch: { coord in
//                    await roadManager.getRoadInfo(at: coord)
//                }
//            )
//
//            let features = trafficManager.update(
//                        speed: frame.speedKmh,
//                        timestamp: frame.timestamp
//                    )
//
//            let flow = trafficManager.classify(features)
//
//            let trafficInfo = TrafficInfo(features: features,
//                                          level: flow)
//
//            let tripLocation = TripLocation(
//                timestamp: frame.timestamp,
//                coordinate: frame.coordinate,
//                speedKmh: frame.speedKmh,
//                weather: weather,
//                roadInfo: roadInfo,
//                traffic: trafficInfo,
//            )
//
            
