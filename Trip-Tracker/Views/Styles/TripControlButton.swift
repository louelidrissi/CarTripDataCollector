//
//  TripControlButton.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI


struct TripControlButton: View {
    
    @ObservedObject var vm: TripViewModel
    var body: some View {
        
        HStack(spacing: 10) {
            
            // Status indicator
            Text(vm.isTracking ? "● Tracking" : "● Stopped")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(vm.isTracking ? .green : .red)
            
            Spacer()
            
            // Toggle button (icon only)
            Button {
                vm.isTracking ? vm.stopTripVM() : vm.startTripVM()
            } label: {
                Text(vm.isTracking ? "■" : "▶")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 28, height: 28)
                    .background(vm.isTracking ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
//
//struct TripControlButton: View {
//
//    @ObservedObject var vm: TripViewModel
//
//    var body: some View {
//
//        Button(vm.isTracking ? "End" : "Start") {
//            vm.isTracking ? vm.stopTripVM() : vm.startTripVM()
//        }
//        .font(.system(size: 12, weight: .semibold))
//        .padding(.vertical, 6)
//        .padding(.horizontal, 10)
//        .background(vm.isTracking ? Color.red : Color.green)
//        .foregroundColor(.white)
//        .cornerRadius(8)
//    }
//}
