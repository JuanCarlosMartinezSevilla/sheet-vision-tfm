//
//  Notifications.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 18/5/23.
//

import Foundation

import UserNotifications

// Function to send a notification
func sendNotification() {
    let content = UNMutableNotificationContent()
        content.title = "Request Finished"
        content.body = "The request has completed successfully."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "RequestNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Handle error
                print("Failed to schedule notification: \(error)")
            } else {
                // Notification scheduled successfully
            }
        }
}
