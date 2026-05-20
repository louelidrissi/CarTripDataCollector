//
//  PhysioSample.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//

/*
 one measurement of that signal
 */

import Foundation
    
struct PhysioSample {
    let timestamp: Date
    let heartRate: Double?
    let hrv: Double?
}
