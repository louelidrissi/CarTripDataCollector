//
//  HealthStream.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//
/*
    NOTE : HR/HRV is measured by Apple Watch but accessed via HealthKit on iOS
 
        They only comes from Apple Watch sensors
        & stored in HealthKit
 */

import Foundation
import HealthKit

final class HealthStreamService {

    private let healthStore = HKHealthStore()

    var onHR: ((Double, Date) -> Void)?
    var onHRV: ((Double, Date) -> Void)?

    // Authorization
    func requestAuthorization() {

        let types: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]

        healthStore.requestAuthorization(toShare: [], read: types) { success, _ in
            print("HealthKit authorized:", success)
        }
    }

    // HR STREAM
    func startHRStream() {

        let type = HKObjectType.quantityType(forIdentifier: .heartRate)!

        let query = HKAnchoredObjectQuery(
            type: type,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, _ in
            self?.processHR(samples)
        }

        query.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.processHR(samples)
        }

        healthStore.execute(query)
    }

    private func processHR(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }

        for sample in samples {
            let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            onHR?(value, sample.startDate)
        }
    }

    // HRV STREAM
    func startHRVStream() {

        let type = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!

        let query = HKAnchoredObjectQuery(
            type: type,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, _ in
            self?.processHRV(samples)
        }

        query.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.processHRV(samples)
        }

        healthStore.execute(query)
    }

    private func processHRV(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }

        for sample in samples {
            let value = sample.quantity.doubleValue(
                for: HKUnit.secondUnit(with: .milli)
            )
            onHRV?(value, sample.startDate)
        }
    }
}
