//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation
import CoreLocation
import UserNotifications

class HomeViewModel: ObservableObject {
    
    @Published var weatherReport: CurrentWeatherReport?
    @Published var errorState: ErrorState?
    @Published var loadingState = true
    @Published var cityName: String
    @Published var showingNotificationView = false
    @Published var notifications: [Notification] = []
    @Published var unreadCount: Int = 0
    
    private var weatherService: WeatherService
    private var locationManager: LocationManager
    private var notificationManager: NotificationManager
    private var notificationDataProvider: NotificationsDataProvider

    
    init(
        cityName: String = "Wroclaw",
        locationManager: LocationManager,
        weatherService: WeatherService = WeatherServiceImpl(),
        notificationManager: NotificationManager = NotificationManager(),
        notificationDataProvider: NotificationsDataProvider = NotificationsDataProviderImpl()
    ) {
        self.cityName = cityName
        self.locationManager = locationManager
        self.weatherService = weatherService
        self.notificationManager = notificationManager
        self.notificationDataProvider = notificationDataProvider
        setupLocationManager()
    }
    
    enum Result: Equatable {
        case onMapSelected
        case onDetailsSelected
    }
    
    var onResult: ((Result) -> Void)?
    
    func selectDetails() {
        onResult?(.onDetailsSelected)
    }
    
    func selectMap() {
        onResult?(.onMapSelected)
    }
    
    private func setupLocationManager() {
        locationManager.onCityNameUpdate = { [weak self] cityName in
            self?.cityName = cityName
            self?.getRealtimeWeather()
        }
    }
    
    private func handleDeniedNotificationAuthorization() {
        SettingsHelper.openAppSettings()
    }
    
    func onNotificationBadgeClicked() {
        notificationManager.checkNotificationAuthorization { status in
            self.handleNotificationAuthorizationStatus(status)
            self.unreadCount = 0
        }
    }
    
    func getRealtimeWeather() {
        self.loadingState = true
        weatherService.getRealtimeWeather(forCity: cityName) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingState = false
                switch result {
                case .success(let report):
                    self?.weatherReport = report
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
                    self.getRealtimeWeather()
                }
            }
        )
    }
    
    private func handleLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            errorState = ErrorState(
                errorMessage: "Location permission denied. Please enable it in settings.",
                retryAction: {
                    self.locationManager.requestLocationPermission()
                }
            )
        case .restricted:
            errorState = ErrorState(
                errorMessage: "Location access is restricted. Please check your restrictions.",
                retryAction: {
                    SettingsHelper.openAppSettings()
                }
            )
        default:
            break
        }
    }
    
    func handleNotificationAuthorizationStatus(_ status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined:
            notificationManager.requestNotificationPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.showingNotificationView = true
                        self?.scheduleDailyNotification()
                    } else {
                        self?.errorState = ErrorState(
                            errorMessage: "Notification permission denied. Please enable it in settings.",
                            retryAction: {
                                self?.onNotificationBadgeClicked()
                            }
                        )
                    }
                }
            }
        case .denied:
            self.errorState = ErrorState(
                errorMessage: "Notification permission denied. Please enable it in settings.",
                retryAction: { [weak self] in
                    self?.handleDeniedNotificationAuthorization()
                }
            )
        case .authorized, .provisional, .ephemeral:
            self.showingNotificationView = true
        default:
            break
        }
    }
    
    private func scheduleDailyNotification() {
        let title = "A sunny day in your location, consider wearing your UV protection"
        let hour = 00
        let minute = 25
        let plannedDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
        
        
        notificationManager.scheduleNotification(title: title, hour: hour, minute: minute)
        saveLocalNotification(title: title, date: plannedDate, isNew: true)
        self.unreadCount += 1
    }
    
    func loadNotifications() {
        notificationDataProvider.getNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    self?.notifications = notifications
                case .failure(let error):
                    print("Error loading notifications: \(error)")
                }
            }
        }
    }
    
    func saveLocalNotification(title: String, date: Date, isNew: Bool) {
        let newNotification = Notification(
            id: UUID().uuidString,
            title: title,
            date: date,
            isNew: isNew)
        
        notificationDataProvider.saveNotifications(notifications: [newNotification]) { result in
            switch result {
            case .success():
                self.loadNotifications()
            case .failure(let error):
                print("Error saving notification: \(error)")
            }
        }
    }
}
