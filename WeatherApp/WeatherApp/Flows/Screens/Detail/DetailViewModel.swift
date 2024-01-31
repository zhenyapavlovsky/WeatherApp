//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 30.10.2023.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    @Published var forecast: [ForecastWeatherReport]?
    @Published var errorState: ErrorState?
    @Published var loadingState = true
    @Published var cityName: String
    
    private var weatherService: WeatherService
    private var locationManager: LocationManager
    
    init(
        cityName: String = "Wroclaw",
        locationManager: LocationManager,
        weatherService: WeatherService = WeatherServiceImpl()
    ) {
        self.cityName = cityName
        self.weatherService = weatherService
        self.locationManager = locationManager
        setupLocationManager()
    }
    
    enum Result {
        case navigationBack
    }
    
    var onResult: ((Result) -> Void)?
    
    func navigateBack() {
        onResult?(.navigationBack)
    }
    
    private func setupLocationManager() {
        locationManager.onCityNameUpdate = { [weak self] cityName in
            self?.cityName = cityName
            self?.getForecastWeather()
        }
    }
    
    func getForecastWeather() {
        self.loadingState = true
        weatherService.getForecastWeather(forCity: cityName) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingState = false
                switch result {
                case .success(let reports):
                    self?.forecast = reports
                    self?.errorState = nil
                case .failure(let error):
                    self?.handleWeatherServiceError(error)
                }
            }
        }
    }
    
    private func handleWeatherServiceError(_ error: Error) {
        let errorMessage: String
        if let serverError = error as? ServerError {
            errorMessage = serverError.code != 200 ? serverError.message : "Something went wrong"
        } else {
            errorMessage = error.localizedDescription
        }
        self.errorState = ErrorState(
            errorMessage: errorMessage,
            retryAction: {
                if let cityName = self.locationManager.selectedCityName {
                    self.getForecastWeather()
                }
            }
        )
    }
}
