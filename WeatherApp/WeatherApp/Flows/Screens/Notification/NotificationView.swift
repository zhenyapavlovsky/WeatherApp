//
//  NotificationView.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 22.12.2023.
//

import SwiftUI

struct NotificationView: View {
    
    @ObservedObject var viewModel: NotificationViewModel
    
    var body: some View {
        infoRectangle
    }
}

private extension NotificationView {
    
    var infoRectangle: some View {
        VStack {
            Image.vectorImage
                .padding(.top, 15)
            VStack(alignment: .leading) {
                Text("Your notifications")
                    .foregroundColor(.buttonText)
                    .shadow(color: Color.black.opacity(0.10), radius: 1, x: -2, y: 3)
                    .font(.system(size: 22, weight: .heavy))
                    .padding()
                ScrollView {
                    VStack(alignment: .leading) {
                        if !viewModel.newNotifications.isEmpty {
                            newNotifications
                        }
                        if !viewModel.earlierNotifications.isEmpty {
                            erlierNotifications
                        }
                    }
                    .padding(.bottom, 19)
                }
            }
        }
        .background {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(30)
        }
    }
    
    var newNotifications: some View {
        VStack(alignment: .leading) {
            Text("New")
                .font(.system(size: 13, weight: .medium))
                .padding(.leading, 15)
            ForEach(viewModel.notifications.filter { $0.isNew }) { notification in
                createNewNotificationRow(notification: notification)
            }
            .background(Color.notificationBackground)
        }
        .foregroundColor(Color.buttonText)
    }
    
    
    var erlierNotifications: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Earlier")
                .foregroundColor(.buttonText)
                .font(.system(size: 11, weight: .medium))
                .padding(.leading, 15)
            VStack(spacing: 0) {
                ForEach(viewModel.notifications.filter { !$0.isNew }) { notification in
                    createOldNotificationRow(notification: notification)
                }
            }
            .foregroundColor(Color.textFade)
        }
        .padding(.top, 5)
    }
    
    func createNewNotificationRow(notification: Notification) -> some View {
        VStack {
            HStack(spacing: 20) {
                Image.windyImage
                VStack(alignment: .leading, spacing: 10) {
                    Text(notification.date.formattedDate)
                        .font(.system(size: 10, weight: .light))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Text(notification.title)
                        .font(.system(size: 13, weight: .bold))
                }
                Button {
                    viewModel.markNotificationAsRead(notificationId: notification.id)
                } label: {
                    Image.downImage
                }
            }
            .padding()
        }
    }
    
    func createOldNotificationRow(notification: Notification) -> some View {
        VStack {
            HStack(spacing: 20) {
                Image.windyImage
                VStack(alignment: .leading, spacing: 10) {
                    Text(notification.date.formattedDate)
                        .font(.system(size: 10, weight: .light))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Text(notification.title)
                        .font(.system(size: 13, weight: .regular))
                }
                Button {} label: {
                    Image.downImage
                }
            }
            .padding()
        }
        .foregroundColor(Color.textFade)
    }
}


#Preview {
    NotificationView(viewModel: NotificationViewModel(dataProvider: NotificationsDataProviderImpl()))
}
