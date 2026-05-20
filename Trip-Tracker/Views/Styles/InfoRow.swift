//
//  InfoRow.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/17/26.
//
import SwiftUI

struct InfoRow: View {

    let title: String
    let value: String

    var body: some View {

        VStack(alignment: .leading, spacing: 1) {

            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .bold()
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
       
        .padding(3)
        .background(Color.white.opacity(0.7))
        .cornerRadius(8)
    }
}
