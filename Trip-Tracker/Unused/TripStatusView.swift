//
//  TripStatus.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI

struct TripStatusView: View {

    @ObservedObject var vm: TripViewModel

    var body: some View {

        Text(vm.isTracking ? "Tracking" : "Stopped")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(vm.isTracking ? .green : .red)
    }
}
