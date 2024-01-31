//
//  SearchCityReport.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation

struct SearchCityReport {
    
    let id: Int
    let name: String
    let country: String
    let lat: Double
    let lon: Double
} 

extension SearchCityDTO: DomainModelConvertible {
    
    func toDomainModel() -> SearchCityReport {
        return SearchCityReport(
            id: self.id,
            name: self.name,
            country: self.country,
            lat: self.lat,
            lon: self.lon
        )
    }
}
