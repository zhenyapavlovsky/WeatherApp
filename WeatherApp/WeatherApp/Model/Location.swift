//
//  Location.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 09.11.2023.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    let id: Int
    var name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }    
}
