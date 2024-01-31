//
//  SearchWeatherDTO.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.10.2023.
//

import Foundation

struct SearchCityDTO: Codable {
    
    let id: Int
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}

struct SearchWeatherResponse: Codable {
    
    let search: [SearchCityDTO]
}
