//
//  DomainModelConvertible.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation

protocol DomainModelConvertible {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}
