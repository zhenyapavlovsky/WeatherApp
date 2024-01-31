//
//  NotificationViewModel.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 22.12.2023.
//

import Foundation

class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [Notification] = []
    
    private var dataProvider: NotificationsDataProvider
    private var notificationManager: NotificationManager
    
    var newNotifications: [Notification] {
        notifications.filter { $0.isNew }
    }
    
    var earlierNotifications: [Notification] {
        notifications.filter { !$0.isNew }
    }
    
    init(
        dataProvider: NotificationsDataProvider,
        notificationManager: NotificationManager = NotificationManager()
    ) {
        self.dataProvider = dataProvider
        self.notificationManager = notificationManager
        loadNotificationManagerNotifications()
    }
    
    func markNotificationAsRead(notificationId: String) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isNew = false
            dataProvider.saveNotifications(notifications: [notifications[index]]) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self?.loadNotificationManagerNotifications()
                    case .failure(let error):
                        print("Error updating notification status in Realm: \(error)")
                    }
                }
            }
        }
    }
    
    func loadNotificationManagerNotifications() {
        dataProvider.getNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    self?.notifications = notifications
                case .failure(let error):
                    print("Error loading notifications: \(error)")
                }
            }
        }
    }
}
