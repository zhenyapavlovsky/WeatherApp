//
//  MapScreenViewModel.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 09.11.2023.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    
    @Published var selectedLocation: Location?
    @Published var searchLocations: [SearchCityReport] = []
    @Published var errorState: ErrorState?
    @Published var searchText = ""
    @Published var showHomeView = false
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50, longitude: 30),
        span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
    )
    
    private let geocoder = CLGeocoder()
    private var weatherService: WeatherService
    private var locationManager: LocationManager
    
    var currentCity: String {
        locationManager.selectedCityName ?? "Wroclaw"
    }
    
    init(weatherService: WeatherService = WeatherServiceImpl(),  locationManager: LocationManager) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    enum Result: Equatable {
        case navigationBack
        case selectedCity(location: Location)
    }
    
    var onResult: ((Result) -> Void)?
    
    func navigateBack() {
        onResult?(.navigationBack)
    }
    
    func onSelectedCity(location: Location) {
        onResult?(.selectedCity(location: location))
    }
    
    func selectCity(_ city: SearchCityReport) {
        let newLocation = Location(id: city.id, name: city.name, latitude: city.lat, longitude: city.lon)
        selectedLocation = newLocation
        mapRegion.center = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
        locationManager.saveCityName(city.name)
        onResult?(.selectedCity(location: newLocation))
    }
    
    func getSearchCity(forCity city: String) {
        weatherService.getSearchCity(forCity: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let cityReports):
                    self.searchLocations = cityReports
                case .failure(let error):
                    self.handleSearchError(error)
                }
            }
        }
    }
    
    func reverseGeocodeLocation(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Error reverse geocoding location: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let city = placemark.locality {
                DispatchQueue.main.async {
                    self.selectedLocation = Location(id: Int.random(in: 1...10000), name: city, latitude: latitude, longitude: longitude)
                    self.mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.locationManager.saveCityName(city)
                }
            }
        }
    }
    
    private func handleSearchError(_ error: Error) {
        let errorMessage: String
        if let serverError = error as? ServerError {
            errorMessage = serverError.code != 200 ? serverError.message : "Something went wrong"
        } else {
            errorMessage = error.localizedDescription
        }
        self.errorState = ErrorState(
            errorMessage: errorMessage,
            retryAction: {
                self.getSearchCity(forCity: self.searchText)
            }
        )
        self.searchLocations = []
    }
}
