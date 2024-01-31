//
//  View.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 16.10.2023.
//

import Foundation
import SwiftUI

extension View {
    
    func customShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.10), radius: 1, x: -2, y: 3)
    }
}
