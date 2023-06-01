//
//  PushNotification.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation
import UserNotifications


class PushNotification {
    static let notificationCenter = UNUserNotificationCenter.current()
    static func dispatchNotification(nameTool: String, recommend: String, timeZone: String, timeInterval: TimeInterval, identifier: String) {
        //let identifier = "slangisecnanifetil.practiceProtocol"
        let title = "Новый сигнал".localized()
        let body = "\(nameTool): \(recommend) \(timeZone)"
//        let hour = 12
//        let minute = 01
       // let isDaily = true
        
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
//        let calendar = Calendar.current
//        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
//        dateComponents.hour = hour
//        dateComponents.minute = minute
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
    static func turnOffNotifications(identifier: String) {
        //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
