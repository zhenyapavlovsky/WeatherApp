//
//  ErrorState.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 24.11.2023.
//

import Foundation

struct ErrorState {
    
    var buttonMessage: String = "Try again"
    let errorMessage: String
    let retryAction: () -> Void
}
