//
//  SettingsHelper.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 04.01.2024.
//

import Foundation
import UIKit

class SettingsHelper {
    
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
