//
//  ActivityButtons.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import SwiftUI

struct ActivityButton: View {

    let title: String
    let value: DriverActivity
    let selected: DriverActivity
    let onTap: (DriverActivity) -> Void

    var body: some View {

        Button {
            onTap(value)
        } label: {
            Text(title)
                .font(.system(size: 16))
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity)
                .background(selected == value ? Color.green : Color.gray.opacity(0.25))
                .cornerRadius(6)
        }
    }
}
