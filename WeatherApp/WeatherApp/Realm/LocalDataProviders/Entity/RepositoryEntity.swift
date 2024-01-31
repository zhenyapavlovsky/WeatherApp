//
//  RepositoryEntity.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation
import RealmSwift

protocol RepositoryEntity: RealmFetchable, KeypathSortable {
    static func create() -> any RepositoryEntity
    func setData(from entity: any DomainEntity)
}
