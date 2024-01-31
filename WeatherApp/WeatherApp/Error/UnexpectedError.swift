//
//  UnexpectedError.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 14.11.2023.
//

import Foundation

struct UnexpectedError: Error {
    var localizedDescription: String {
        return "An unexpected error occurred"
    }
}
