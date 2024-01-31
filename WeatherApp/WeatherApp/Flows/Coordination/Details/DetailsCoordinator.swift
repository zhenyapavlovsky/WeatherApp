//
//  DetailsCoordinator.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import Foundation

class DetailsCoordinator: ObservableObject {
    
    enum Result {
        case navigationBack
    }
    
    var onResult: ((Result) -> Void)?
    var detailsViewModel: DetailViewModel
    
    init(detailsViewModel: DetailViewModel) {
        self.detailsViewModel = detailsViewModel
        detailsViewModel.onResult = { [weak self] result in
            switch result {
            case .navigationBack:
                self?.onResult?(.navigationBack)
            }
        }
    }
}
