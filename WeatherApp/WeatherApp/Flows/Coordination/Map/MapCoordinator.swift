//
//  MapCoordinator.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import Foundation

class MapCoordinator: ObservableObject {
    
    enum Result: Equatable {
        case navigationBack
        case selectedCity(location: Location)
    }
    
    var onResult: ((Result) -> Void)?
    var mapViewModel: MapViewModel
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        mapViewModel.onResult = { [weak self] result in
            switch result {
            case .navigationBack:
                self?.onResult?(.navigationBack)
            case .selectedCity(let location):
                self?.onResult?(.selectedCity(location: location))
            }
        }
    }
}
