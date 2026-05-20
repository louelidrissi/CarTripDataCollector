//
//  PhysioCollector.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//
import Foundation

class PhysioCollector {

    var onNewSample: ((PhysioSample) -> Void)?

    func handleHR(value: Double, time: Date) {
        let sample = PhysioSample(
            timestamp: time,
            heartRate: value,
            hrv: nil
        )
        onNewSample?(sample)
    }

    func handleHRV(value: Double, time: Date) {
        let sample = PhysioSample(
            timestamp: time,
            heartRate: nil,
            hrv: value
        )
        onNewSample?(sample)
    }
}
