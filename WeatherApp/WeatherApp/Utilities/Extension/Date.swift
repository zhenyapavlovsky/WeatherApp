//
//  Date.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation

extension Date {
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: self)
    }
    
    var dayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, d"
        return formatter.string(from: self)
    }
}
