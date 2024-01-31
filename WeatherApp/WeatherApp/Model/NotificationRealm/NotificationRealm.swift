//
//  NotificationRealm.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 15.01.2024.
//

import Foundation
import RealmSwift

class NotificationRealm: Object, RepositoryEntity {
    
    static func create() -> any RepositoryEntity {
        return NotificationRealm()
    }
    
    func setData(from entity: any DomainEntity) {
        guard let notification = entity as? Notification else {
            return
        }
        self.id = notification.id
        self.title = notification.title
        self.date = notification.date
        self.isNew = notification.isNew
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isNew: Bool = false
    
    class func from(notification: Notification) -> NotificationRealm {
        let notificationRealm = NotificationRealm()
        
        notificationRealm.setData(from: notification)
        
        return notificationRealm
    }
}

extension NotificationRealm: DomainModelConvertible {
    
    func toDomainModel() -> Notification {
        return Notification(
            id: self.id,
            title: self.title,
            date: self.date,
            isNew: self.isNew
        )
    }
}
