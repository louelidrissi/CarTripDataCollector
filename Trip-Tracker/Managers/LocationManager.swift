//
//  LocationManger.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

import Foundation // for dates
import Combine
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // talks to GPS
    //  ObservableObject ??
    
    private let manager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var didCreateFrame: ((LocationFrame) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.allowsBackgroundLocationUpdates = true
        manager.distanceFilter = 10  // 10 meters
    }
    
    // MAIN METHODS - Call in Trip Tracker
    
    // method 1
    func requestPermission() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .denied, .restricted:
            // show UI to open settings etc.
            break
        default:
            startUpdatingLocation()
        }
    }
    
    // method 2
    func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        manager.startUpdatingLocation()
    }
    
    // method 3
    func stopUpdatingLocation() {
            manager.stopUpdatingLocation()
    }
    
    // DELEGATE CALLBACKS - Called by iOS
    
    // Callback 1
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }

            let frame = LocationFrame(
                timestamp: location.timestamp,
                coordinate: location.coordinate,
                speedKmh: location.speed >= 0 ? location.speed * 3.6 : nil
            )

            didCreateFrame?(frame)
        }
    
    // Callback 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("LocationManager error:", error)
        }
    
    // Callback 3
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                startUpdatingLocation()
            }
        }
}
