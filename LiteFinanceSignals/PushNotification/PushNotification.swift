//
//  PushNotification.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation
import UserNotifications
import UIKit


class PushNotification: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    
    func dispatchNotification(nameTool: String, recommend: String, timeZone: String, timeInterval: TimeInterval, identifier: String) {
        //let identifier = "slangisecnanifetil.practiceProtocol"
        let title = "Новый сигнал".localized()
        let body = "\(nameTool): \(recommend) \(timeZone)"
//        let hour = 12
//        let minute = 01
       // let isDaily = true
        
        
//        notificationCenter.requestAuthorization(options: options) { success, error in
//            if !success {
//                print("User has declined notifications")
//            }
//        }
        
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
        //self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        self.notificationCenter.add(request) { error in
            if let error = error {
                print("error local notification \(error.localizedDescription)")
            } else {
                print("enable send notice")
            }
        }
        
    }
    
    func turnOffNotifications(identifier: String) {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        self.notificationCenter.removeAllDeliveredNotifications()
        self.notificationCenter.removeAllPendingNotificationRequests()
        
        self.notificationCenter.requestAuthorization { success, error in
            if error == nil {
                print("error cancel")
            }
            
            print("success cancel notice \(success)")
        }
    }
    
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        completionHandler([.alert,.sound])
//    }
    
    
}
