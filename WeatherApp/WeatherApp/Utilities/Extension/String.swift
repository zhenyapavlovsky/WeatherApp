//
//  String.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 11.10.2023.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func hourFormatted() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return self
    }
    
    func isCurrentHour() -> Bool {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let date = inputFormatter.date(from: self) {
            let currentHour = Calendar.current.component(.hour, from: Date())
            let hour = Calendar.current.component(.hour, from: date)
            return hour == currentHour
        }
        return false
    }
    
    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM, d"
            return outputFormatter.string(from: date)
        }
        return self
    }
}
