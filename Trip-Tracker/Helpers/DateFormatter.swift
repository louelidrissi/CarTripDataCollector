//
//  DateFormatter.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/13/26.
//
import Foundation

struct DateFormatterUtils {

    static func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}

