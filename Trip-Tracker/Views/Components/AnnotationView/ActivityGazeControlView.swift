//
//  ActivityGazeControlView.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/17/26.
//
import SwiftUI

struct ActivityGazeControlView: View {

    @ObservedObject var vm: TripViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
       // GridItem(.flexible())
    ]

    var body: some View {

        VStack(spacing: 4) {

            // GAZE (single row, small)
            HStack(spacing: 6) {

                GazeButton(title: "Forward",
                           value: .forward,
                           selected: vm.selectedGaze) {
                    vm.selectedGaze = $0
                    vm.didTapGaze($0)
                }

                GazeButton(title: "Downward",
                           value: .downward,
                           selected: vm.selectedGaze) {
                    vm.selectedGaze = $0
                    vm.didTapGaze($0)
                }

                GazeButton(title: "Sideward",
                           value: .sideward,
                           selected: vm.selectedGaze) {
                    vm.selectedGaze = $0
                    vm.didTapGaze($0)
                }
            }

            // ACTIVITY (GRID = 2 rows automatically)
            LazyVGrid(columns: columns, spacing: 6) {

//                ActivityButton(title: "Normal",
//                               value: .normalDriving,
//                               selected: vm.selectedActivity) {
//                    vm.selectedActivity = $0
//                    vm.didTapActivity($0)
//                }

                ActivityButton(title: "Talk",
                               value: .talking,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }

                ActivityButton(title: "Yawn",
                               value: .yawning,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }

                ActivityButton(title: "Phone",
                               value: .usingPhone,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }

                ActivityButton(title: "Drink",
                               value: .eatingDrinking,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }

                ActivityButton(title: "Controls",
                               value: .interactingWithControls,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }

                ActivityButton(title: "Reach",
                               value: .reachingForObjects,
                               selected: vm.selectedActivity) {
                    vm.selectedActivity = $0
                    vm.didTapActivity($0)
                }
            }
        }
        .padding(8)
        .background(Color.black.opacity(0.05))
        .cornerRadius(10)
    }
}
