//
//  Repository.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation

protocol Repository {
    associatedtype DomainModel
    associatedtype RepositoryModel

    func get(completion: @escaping (Swift.Result<[RepositoryModel], Error>) -> Void)
    func updateAndSave(_ array: [DomainModel], completion: @escaping (Swift.Result<Void, Error>) -> Void)
}
