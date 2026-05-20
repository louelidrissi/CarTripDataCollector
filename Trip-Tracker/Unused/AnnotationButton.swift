//
//  AnnotationButton.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//
import SwiftUI

struct AnnotationButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}
