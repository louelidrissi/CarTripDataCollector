//
//  TripMetrics.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI


struct TripMetricsView: View {

    @ObservedObject var vm: TripViewModel

    var body: some View {

        HStack(spacing: 10) {
            Text("Frame \(vm.locationsCount)")
                    .font(.system(size: 14, weight: .medium))

            Text("API \(vm.weatherApiCalls)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Text("API \(vm.roadInfoApiCalls)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            
        }
    }
}


//
//struct TripMetricsView: View {
//    @ObservedObject var vm: TripViewModel
//
//    var body: some View {
//        HStack(spacing: 20) {
//            VStack {
//                Text("\(vm.locationsCount)")
//                Text("Locations")
//            }
//
//            VStack {
//                Text("\(vm.apiCalls)")
//                Text("API Calls")
//            }
//        }
//    }
//}
