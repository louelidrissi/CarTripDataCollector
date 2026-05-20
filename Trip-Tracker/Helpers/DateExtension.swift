//
//  DateExtension.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/15/26.
//
/*
    Extension of Foundation type Date.
    ISO 8601 format for dates and times.
    timestamp custom prefix.
 */
import Foundation

extension Date {

    private static let formatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    var timestampISO8601: String {
        Self.formatter.string(from: self)
    }
}
