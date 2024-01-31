//
//  RealmRepository.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation
import RealmSwift

class RealmRepository<DomainModel: DomainEntity, RepositoryModel: RepositoryEntity>: Repository {
    
    typealias Result = Swift.Result

    func get(completion: @escaping (Result<[RepositoryModel], Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                let values = realm.objects(RepositoryModel.self)
                completion(.success(Array(values)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateAndSave(_ array: [DomainModel], completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                var realmEntities = [RepositoryModel]()
                
                for domainModel in array {
                    if let realmEntity: RepositoryModel = RepositoryModel.create() as? RepositoryModel {
                        realmEntity.setData(from: domainModel)
                        realmEntities.append(realmEntity)
                    }
                }
                
                if let realmObjects = realmEntities as? [Object] {
                    try realm.write {
                        realm.add(realmObjects, update: Realm.UpdatePolicy.modified)
                    }
                    completion(.success(Void()))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
