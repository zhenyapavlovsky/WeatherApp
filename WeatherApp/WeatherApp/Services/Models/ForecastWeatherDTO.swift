//
//  ForecastWeatherDTO.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.10.2023.
//

import Foundation

struct ForecastWeatherDTO: Codable {
    
    let forecastday: [ForecastDay]
    
    struct ForecastDay: Codable {
        
        let date: String
        let day: DayInfo
        let hour: [HourInfo]
        
        struct DayInfo: Codable {
            
            let averageC: Decimal
            let condition: Condition
            
            struct Condition: Codable {
                let text: String
                let icon: String
            }
            
            private enum CodingKeys : String, CodingKey {
                case averageC = "avgtemp_c"
                case condition
            }
        }
        
        struct HourInfo: Codable {
            
            let time: String
            let temp: Decimal
            let condition: Condition
            
            struct Condition: Codable {
                let text: String
                let icon: String
            }
            
            private enum CodingKeys : String, CodingKey {
                case time
                case temp = "temp_c"
                case condition
            }
        }
    }
}

struct ForecastWeatherResponse: Codable {
    
    let forecast: ForecastWeatherDTO
    let alerts: [AlertInfo]?
    
    struct AlertInfo: Codable {
        
        let headline: String
    }
}


