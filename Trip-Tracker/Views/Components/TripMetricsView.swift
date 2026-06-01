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

        HStack(spacing: 16) {

            Text("Loc \(vm.locationsCount)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)

            statusPill("W", vm.weatherStatus)

            statusPill("R", vm.roadStatus)
        }
    }

    // UI helper

    private func statusPill(_ label: String, _ status: TripStatus) -> some View {
        Text("\(label) \(statusSymbol(status))")
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor(status).opacity(0.15))
            .foregroundColor(statusColor(status))
            .clipShape(Capsule())
    }

    private func statusSymbol(_ status: TripStatus) -> String {
        switch status {
        case .good: return "●"
        case .degraded: return "●"
        case .poor: return "●"
        }
    }

    private func statusColor(_ status: TripStatus) -> Color {
        switch status {
        case .good: return .green
        case .degraded: return .orange
        case .poor: return .red
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
