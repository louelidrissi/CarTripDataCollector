//
//  GazeButtons.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI

struct GazeButton: View {

    let title: String
    let value: GazeDirection
    let selected: GazeDirection
    let onTap: (GazeDirection) -> Void

    var body: some View {

        Button {
            onTap(value)
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(selected == value ? Color.green : Color.gray.opacity(0.25))
                .cornerRadius(6)
        }
    }
}
