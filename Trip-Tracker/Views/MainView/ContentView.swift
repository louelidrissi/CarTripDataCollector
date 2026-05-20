//
//  ContentView.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 4/17/26.
//

import CoreLocation
import SwiftData
import SwiftUI

struct ContentView: View {
    // UI listens to TripViewModel
    @StateObject private var vm: TripViewModel // State Object wraps the Published values to be observed by Swift UI
    
    // initialize trip tracker
    init() {
        let locationManager = LocationManager()
        let tripManager = TripManager()
        let weatherManager = WeatherManager()
        let roadManager = RoadManager()
        
        let csvService = TripCSVService()
        let tripIndexStore = TripIndexStore()
        //let trafficDensityManager = TrafficManager()
        //    let roadQueryPolicy = RoadQueryPolicy()
        
        let tripTracker = TripTracker(
            // core
            locationManager: locationManager,
            tripManager: tripManager,
            weatherManager: weatherManager,
            roadManager: roadManager,
            // save
            tripIndexStore: tripIndexStore,
            tripCSVService: csvService,
            
            //     roadQueryPolicy: roadQueryPolicy
            //            trafficDensityManager: trafficDensityManager
            
        )
        
        _vm = StateObject(wrappedValue: TripViewModel(tripTracker: tripTracker))
        
        // tripTracker.viewModel = vm // call vm in Trip Tracker
    }
    
    var body: some View {
        
      
                VStack {
        
                    ScrollView {
                        VStack(spacing: 10) {
        
                            //TripStatusView(vm: vm)
                            TripControlButton(vm: vm)
        
                            TripMetricsView(vm: vm)
        
                            LocationInfoView(vm: vm)
        
        
                        }
                        .padding()
                    }
        
//                   AnnotationControlView(vm: vm)
                       
                        
                    AnnotationStatusView(vm: vm)
                        .padding(.horizontal, 8)
                       // .padding(.bottom, 1)
        
                    ActivityGazeControlView(vm: vm)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .frame(maxHeight: 220)
                    }
                }
    }
    


