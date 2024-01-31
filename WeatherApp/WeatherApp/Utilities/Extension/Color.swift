//
//  Color.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 16.10.2023.
//

import Foundation
import SwiftUI

extension Color {
    
    static var customGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.linearGradientFirst, Color.linearGradientSecond]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
