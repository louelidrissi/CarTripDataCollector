//
//  ShareFile.swift
//  Trip-Tracker
//
//  Created by Lou El Idrissi on 5/28/26.
//

import UIKit

func shareFile(url: URL) {
    let activityVC = UIActivityViewController(
        activityItems: [url],
        applicationActivities: nil
    )

    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let root = scene.windows.first?.rootViewController {
        root.present(activityVC, animated: true)
    }
}
