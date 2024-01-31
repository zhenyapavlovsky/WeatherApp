//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.12.2023.
//

import Foundation

class HomeCoordinator: ObservableObject {
    
    enum Route {
        case map(coordinator: MapCoordinator)
        case details(coordinator: DetailsCoordinator)
    }
    
    @Published var route: Route?
    
    var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        homeViewModel.onResult = { [weak self] result in
            switch result {
            case .onDetailsSelected:
                self?.routeToDetailsView()
            case .onMapSelected:
                self?.routeToMapView()
            }
        }
    }
    
    func routeToDetailsView() {
        let detailViewModel = DetailViewModel(
            cityName: homeViewModel.cityName,
            locationManager: LocationManager(),
            weatherService: WeatherServiceImpl()
        )
        
        let detailsCoordinator = DetailsCoordinator(detailsViewModel: detailViewModel)
        detailsCoordinator.onResult = { [weak self] result in
            switch result {
            case .navigationBack:
                self?.route = nil
            }
        }
        route = .details(coordinator: detailsCoordinator)
    }
    
    func routeToMapView() {
        let mapCoordinator = MapCoordinator(
            mapViewModel: MapViewModel(
                weatherService: WeatherServiceImpl(),
                locationManager: LocationManager()
            )
        )
        mapCoordinator.onResult = { result in
            switch result {
            case.navigationBack:
                self.route = nil
            case .selectedCity(let location):
                self.route = nil
                self.homeViewModel.cityName = location.name
            }
        }
        route = .map(coordinator: mapCoordinator)
    }
}
