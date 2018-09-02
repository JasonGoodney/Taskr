//
//  AlarmScheduler.swift
//  Taskr
//
//  Created by Jason Goodney on 9/1/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import UserNotifications

protocol NotificationScheduler {
    //var object: Task
    
    func scheduleUserNotifications(for task: Task)
    func cancelUserNotifications(for task: Task)
}

extension NotificationScheduler {
    func scheduleUserNotifications(for task: Task) {
        guard let name = task.name, let note = task.note, let due = task.due, let uuid = task.uuid else { return }
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = note
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: due)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error adding notification \(error)\n\(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for task: Task) {
        guard let uuid = task.uuid else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid.uuidString])
    }
}

