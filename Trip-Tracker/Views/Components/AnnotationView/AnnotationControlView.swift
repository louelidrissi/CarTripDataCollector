//
//  TripDriverInfo.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI

struct AnnotationControlView: View {

    @ObservedObject var vm: TripViewModel

    var body: some View {

        VStack(spacing: 10) {

           
            AnnotationStatusView(vm: vm)

            //Spacer()

            ActivityGazeControlView(vm: vm)
                .frame(maxHeight: 220)
        }
        .padding()
    }
}

//
//struct AnnotationControlView: View {
//    @ObservedObject var vm: TripViewModel
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            VStack(spacing: 12) {
//
//                Text("Gaze")
//                    .font(.caption)
//
//                HStack {
//                    GazeButton(title: "Forward", value: .forward, selected: vm.selectedGaze) {
//                        vm.selectedGaze = $0
//                        vm.didTapGaze($0)
//                    }
//
//                    GazeButton(title: "Down", value: .downward, selected: vm.selectedGaze) {
//                        vm.selectedGaze = $0
//                        vm.didTapGaze($0)
//                    }
//
//                    GazeButton(title: "Side", value: .sideward, selected: vm.selectedGaze) {
//                        vm.selectedGaze = $0
//                        vm.didTapGaze($0)
//                    }
//                }
//
//                Text("Activity")
//                    .font(.caption)
//
//                HStack {
//                    ActivityButton(title: "Normal", value: .normalDriving, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//
//                    ActivityButton(title: "Talking", value: .talking, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//
//                    ActivityButton(title: "Yawning", value: .yawning, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//
//                    ActivityButton(title: "PhoneUse", value: .usingPhone, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//                    
//                    ActivityButton(title: "Drinking", value: .eatingDrinking, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//                    ActivityButton(title: "Controls", value: .interactingWithControls, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//                    ActivityButton(title: "Reaching", value: .reachingForObjects, selected: vm.selectedActivity) {
//                        vm.selectedActivity = $0
//                        vm.didTapActivity($0)
//                    }
//                }
//                if let annotation =
//                    vm.activeAnnotation ?? vm.lastCompletedAnnotation {
//
//                    VStack(alignment: .leading, spacing: 4) {
//
//                        Text("Current Annotation")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//
//                        Text("Activity: \(annotation.activity.rawValue)")
//
//                        Text(
//                            "Started: \(DateFormatterUtils.formattedTime(annotation.startTime))"
//                        )
//
//                        if let end = annotation.endTime {
//
//                            Text(
//                                "Ended: \(DateFormatterUtils.formattedTime(end))"
//                            )
//                            .foregroundColor(.green)
//
//                    } else {
//
//                        Text("Recording...")
//                            .foregroundColor(.red)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(8)
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(8)
//            }
//            }
//            .padding()
//            .background(Color.black.opacity(0.05))
//        }
//    }
//}
