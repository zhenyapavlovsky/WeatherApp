//
//  DomainEntity.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation

protocol DomainEntity: Identifiable {
    
    var id: String { get }
}
