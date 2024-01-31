//
//  ForecastWeatherReport.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation

struct ForecastWeatherReport: Identifiable {
    
    var id: UUID
    var date: String
    var averageTemperature: Int
    var iconURL: URL?
    var hourlyReports: [HourlyWeatherReport]
    var alerts: [Alert]
    
    struct HourlyWeatherReport {

        var time: String
        var temperature: Int
        var iconURL: URL?
    }
    
    struct Alert: Identifiable {
        
        let id: UUID
        let headline: String
    }
}

extension ForecastWeatherDTO: DomainModelConvertible {
    
    func toDomainModel() -> [ForecastWeatherReport] {
        return forecastday.map { $0.toDomainModel() }
    }
}

extension ForecastWeatherDTO.ForecastDay: DomainModelConvertible {
    
    func toDomainModel() -> ForecastWeatherReport {
        ForecastWeatherReport(
            id: UUID(),
            date: self.date,
            averageTemperature: NSDecimalNumber(decimal: self.day.averageC).intValue,
            iconURL: URL(string: self.day.condition.icon),
            hourlyReports: self.hour.map({ $0.toDomainModel() }),
            alerts: []
        )
    }
}

extension ForecastWeatherDTO.ForecastDay.HourInfo: DomainModelConvertible {
    
    func toDomainModel() -> ForecastWeatherReport.HourlyWeatherReport {
        ForecastWeatherReport.HourlyWeatherReport(
            time: self.time,
            temperature: NSDecimalNumber(decimal: self.temp).intValue,
            iconURL: URL(string: self.condition.icon)
        )
    }
}

extension ForecastWeatherResponse: DomainModelConvertible {
    
    func toDomainModel() -> [ForecastWeatherReport] {
        return forecast.forecastday.map { day in
            var report = day.toDomainModel()
            report.alerts = self.alerts?.map { alertInfo in
                ForecastWeatherReport.Alert(
                    id: UUID(),
                    headline: alertInfo.headline
                )
            } ?? []
            return report
        }
    }
}
