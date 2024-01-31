//
//  NotificationsDataProvider.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation


protocol NotificationsDataProvider {
    
    func getNotifications(completion: @escaping (Swift.Result<[Notification], Error>) -> Void)
    func saveNotifications(notifications: [Notification], completion: @escaping (Swift.Result<Void, Error>) -> Void)
}

class NotificationsDataProviderImpl: NotificationsDataProvider {
    
    private let notificationsRepository: RealmRepository<Notification, NotificationRealm>
    
    init() {
        self.notificationsRepository = RealmRepository<Notification, NotificationRealm>()
    }

    func getNotifications(completion: @escaping (Swift.Result<[Notification], Error>) -> Void) {
        notificationsRepository.get { result in
            switch result {
            case .success(let notificationRealmObjects):
                let notifications = notificationRealmObjects.compactMap { $0.toDomainModel() }
                completion(.success(notifications))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveNotifications(notifications: [Notification], completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        notificationsRepository.updateAndSave(notifications, completion: completion)
    }
}
