//
//  NotificationManager.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 28.12.2023.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var didChangeAuthorization: ((UNAuthorizationStatus) -> Void)?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func checkNotificationAuthorization(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    
    func scheduleNotification(title: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
        }
    }
    
    func deleteLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
