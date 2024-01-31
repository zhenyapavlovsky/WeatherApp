//
//  CurrentWeatherReport.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation

struct CurrentWeatherReport: Identifiable {
    
    var id: UUID
    var temperature: Int
    var iconURL: URL?
    var windSpeed: Double
    var humidity: Double
    var city: String
    var isSelected: Bool
}

extension CurrentWeatherResponse: DomainModelConvertible {
    
    func toDomainModel() -> CurrentWeatherReport {
        return CurrentWeatherReport(
            id: UUID(),
            temperature: NSDecimalNumber(decimal: current.temp).intValue,
            iconURL: URL(string: current.condition.icon),
            windSpeed: NSDecimalNumber(decimal: current.wind).doubleValue,
            humidity: Double(current.humidity),
            city: location.name,
            isSelected: false
        )
    }
}
