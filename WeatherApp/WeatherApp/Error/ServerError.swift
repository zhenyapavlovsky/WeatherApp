//
//  ServerError.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 11.11.2023.
//

import Foundation

struct ServerError: Codable, Error {
    let code: Int
    let message: String
}
