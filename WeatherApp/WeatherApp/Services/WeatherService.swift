//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 18.10.2023.
//

import Foundation

protocol WeatherService {
    
    func getRealtimeWeather(forCity city: String, completion: @escaping (Result<CurrentWeatherReport, Error>) -> Void)
    func getForecastWeather(forCity city: String, completion: @escaping (Result<[ForecastWeatherReport], Error>) -> Void)
    func getSearchCity(forCity city: String, completion: @escaping (Result<[SearchCityReport], Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    
    private let baseURL = "https://api.weatherapi.com/v1"
    private let cityQueryKey = "q"
    private let addDays = "days"
    
    let apiManager: APIManager
    
    init(apiManager: APIManager = APIManagerImpl.sharedInstance) {
        self.apiManager = apiManager
    }
    
    func getRealtimeWeather(forCity city: String, completion: @escaping (Result<CurrentWeatherReport, Error>) -> Void) {
        
        let urlString = "\(baseURL)/current.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ServerError(code: 400, message: "URL formation failed")))
            return
        }
        
        apiManager.request(with: url, method: .get, parameters: [cityQueryKey: city], headers: nil) { result in
            switch result {
            case .success(let data):
                guard let validData = data else {
                    completion(.failure(UnexpectedError()))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(CurrentWeatherResponse.self, from: validData)
                    let report = response.toDomainModel()
                    completion(.success(report))
                } catch {
                    completion(.failure(ServerError(code: 500, message: "Failed to decode weather data")))
                }
            case .failure:
                completion(.failure(UnexpectedError()))
            }
        }
    }
    
    func getForecastWeather(forCity city: String, completion: @escaping (Result<[ForecastWeatherReport], Error>) -> Void) {
        
        let urlString = "\(baseURL)/forecast.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ServerError(code: 400, message: "URL formation failed")))
            return
        }
        
        apiManager.request(with: url, method: .get, parameters: [cityQueryKey: city, addDays: "5"], headers: nil) { result in
            switch result {
            case .success(let data):
                guard let validData = data else {
                    completion(.failure(UnexpectedError()))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(ForecastWeatherResponse.self, from: validData)
                    let forecastReports = response.toDomainModel()
                    completion(.success(forecastReports))
                } catch {
                    completion(.failure(ServerError(code: 500, message: "Failed to decode forecast data")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSearchCity(forCity city: String, completion: @escaping (Result<[SearchCityReport], Error>) -> Void) {
        
        let urlString = "\(baseURL)/search.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ServerError(code: 400, message: "URL formation failed")))
            return
        }
        
        apiManager.request(with: url, method: .get, parameters: [cityQueryKey: city], headers: nil) { result in
            switch result {
            case .success(let data):
                guard let validData = data else {
                    completion(.failure(ServerError(code: 500, message: "No data received from server")))
                    return
                }
                do {
                    let reports = try JSONDecoder().decode([SearchCityDTO].self, from: validData).map { $0.toDomainModel() }
                    completion(.success(reports))
                } catch {
                    completion(.failure(ServerError(code: 500, message: "Failed to decode search city data")))
                }
            case .failure:
                completion(.failure(UnexpectedError()))
            }
        }
    }
}
