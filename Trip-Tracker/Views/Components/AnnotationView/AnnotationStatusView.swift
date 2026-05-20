//
//  AnnotationStatusView.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/17/26.
//

import SwiftUI

struct AnnotationStatusView: View {

    @ObservedObject var vm: TripViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 3) {

            // HISTORY (LEFT)
            VStack(alignment: .leading, spacing: 1) {

                Text("LAST")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                if let last = vm.lastCompletedAnnotation {

                    Text(last.activity.rawValue)
                        .font(.system(size: 14, weight: .medium))

                    Text(DateFormatterUtils.formattedTime(last.startTime))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                    if let end = last.endTime {
                        Text(DateFormatterUtils.formattedTime(end))
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    }

                } else {
                    Text("—")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            // ACTIVE (RIGHT)
            VStack(alignment: .leading, spacing: 1) {

                Text("ACTIVE")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)

                if let active = vm.activeAnnotation {

                    Text(active.activity.rawValue)
                        .font(.system(size: 14, weight: .medium))

                    Text(DateFormatterUtils.formattedTime(active.startTime))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                } else {
                    Text("Normal")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)
        }
    }
}
