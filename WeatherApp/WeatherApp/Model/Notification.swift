//
//  Notification.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation

struct Notification: DomainEntity {
    
    let id: String
    let title: String
    let date: Date
    var isNew: Bool
}
