//
//  Models.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.10.2023.
//

import Foundation

struct CurrentWeatherDTO: Codable {
    
    let temp: Decimal
    let wind: Decimal
    let humidity: Int
    let condition: Condition
    
    struct Condition: Codable {
        let text: String
        let icon: String
    }
    
    private enum CodingKeys : String, CodingKey {
        case temp = "temp_c"
        case wind = "wind_kph"
        case humidity
        case condition
    }
}

struct CurrentWeatherResponse: Codable {
    
    let location: Location
    let current: CurrentWeatherDTO
    
    struct Location: Codable {
        let name: String
    }
}


