//
//  StateAnnotation.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/12/26.
//


import Foundation

struct DriverAnnotation: Codable {

    let startTime: Date
    var endTime: Date?

    let gaze: GazeDirection
    let activity: DriverActivity
  
}

enum GazeDirection: String, Codable {
    case forward
    case downward
    case sideward
}

enum DriverActivity: String, Codable {
    case normalDriving
    case talking
    case yawning
    case usingPhone
    case eatingDrinking
    case interactingWithControls
    case reachingForObjects
}
