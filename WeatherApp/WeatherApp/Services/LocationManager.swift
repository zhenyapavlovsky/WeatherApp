//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 24.11.2023.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var selectedCityName: String?
    private let locationManager = CLLocationManager()
    var didChangeAuthorization: ((CLAuthorizationStatus) -> Void)?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onCityNameUpdate: ((String) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func saveLocation(_ coordinate: CLLocationCoordinate2D) {
        coordinates = coordinate
    }

    func saveCityName(_ cityName: String) {
        selectedCityName = cityName
        onCityNameUpdate?(cityName)
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .notDetermined {
            requestLocationPermission()
        }
        didChangeAuthorization?(authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.coordinates = location.coordinate
        self.onLocationUpdate?(location.coordinate)
    }

    func handleAuthorizationStatusAction() {
        switch authorizationStatus {
        case .denied:
            requestLocationPermission()
        case .restricted:
            SettingsHelper.openAppSettings()
        default:
            break
        }
    }
}
