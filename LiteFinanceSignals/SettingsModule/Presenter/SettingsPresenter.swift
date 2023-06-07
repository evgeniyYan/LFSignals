//
//  SettingsPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import UserNotifications

protocol SettingsProtocol: AnyObject {
    func setChildView(notice: NoticeView, update: UpdateView, hints: HintsView, design: DesignView)
    func success(customBar: CustomBar)
}

protocol SettingsPresenterProtocol: AnyObject {
    init(view: SettingsProtocol, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol)
    var noticeView: NoticeView! {get set}
    func toogleBlock(block: UIView, switcher: CustomSwitch, arr: [ButtonActive])
    func toggleNoticeView(sender: ButtonActive)
    func toggleOtherUpdateView(sender: ButtonActive, arr: [ButtonActive])
    func toggleOtherModeView(sender: ButtonActive, arr: [ButtonActive])
    func toggleModeApp(sender: ButtonActive)
    func toggleActiveButtons(view: UIView, arr: [ButtonActive])
    func toggleHintsView(switcher: CustomSwitch)
    func delegateTimerRepeat(text: String)
    var signalsPresenter: SignalsPresenterProtocol! {get set}
    func runPushNotice(completion: @escaping(Bool) -> Void)
}


class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsProtocol?
    var network: NetworkProtocol!
    var router: RouterProtocol?
    var customBar: CustomBarProtocol!
    var noticeView: NoticeView!
    var updateView: UpdateView!
    var hintsView: HintsView!
    var designView: DesignView!
    var checkRecommendButton = [String]()
    var checkUpdateButton = [String]()
    var signalsPresenter: SignalsPresenterProtocol!
    
    required init(view: SettingsProtocol, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol) {
        self.view = view
        self.network = network
        self.router = router
        self.customBar = customBar
        createChildViews(presenter: self)
    }
    
    func createChildViews(presenter: SettingsPresenter) {
        let noticeView = NoticeView(presenter: presenter)
        let updateView = UpdateView(presenter: presenter)
        let hintsView = HintsView(presenter: presenter)
        let designView = DesignView(presenter: presenter)
        self.noticeView = noticeView
        self.updateView = updateView
        self.hintsView = hintsView
        self.designView = designView
        self.view?.setChildView(notice: noticeView, update: updateView, hints: hintsView, design: designView)
    }
    
    
    func toggleNoticeView(sender: ButtonActive) {
        self.checkRecommendButton = UserDefaults.standard.array(forKey: UserSettings.settingsRecommend)! as! [String]
      
        if sender.alpha == 0.5 {
            sender.WhiteTrue()
            checkRecommendButton.append(sender.titleLabel!.text!)
        } else {
            if self.checkRecommendButton.count > 1 {
                sender.GrayTrue()
                let new = checkRecommendButton.filter({$0 != sender.titleLabel!.text!})
                self.checkRecommendButton = new
            }
            
        }

        UserDefaults.standard.set(self.checkRecommendButton, forKey: UserSettings.settingsRecommend)
        
    }
    
    func toggleOtherUpdateView(sender: ButtonActive, arr: [ButtonActive]) {
        UserDefaults.standard.set("", forKey: UserSettings.settingsUpdate)
            sender.startWhiteFalse()
        UserDefaults.standard.set(sender.titleLabel!.text, forKey: UserSettings.settingsUpdate)
        let otherButton = arr.filter({$0.titleLabel?.text != sender.titleLabel?.text})

        for i in 0..<otherButton.count {
            otherButton[i].GrayTrue()
        }
    }
    
    func toggleOtherModeView(sender: ButtonActive, arr: [ButtonActive]) {
        UserDefaults.standard.set("", forKey: UserSettings.settingsMode)
            sender.startWhiteFalse()
        UserDefaults.standard.set(sender.titleLabel!.text, forKey: UserSettings.settingsMode)
        let otherButton = arr.filter({$0.titleLabel?.text != sender.titleLabel?.text})

        for i in 0..<otherButton.count {
            otherButton[i].GrayTrue()
        }
    }
    
    func delegateTimerRepeat(text: String) {
        let saveNumber = UserDefaults.standard.string(forKey: UserSettings.settingsUpdate)!
        print("save time \(saveNumber)")
        let number = Int(saveNumber.components(separatedBy: " ")[0])
        UserDefaults.standard.set(number, forKey: UserSettings.updateNumber)
        router?.timerRepear = TimeInterval(number!)
    }
    
    func toggleModeApp(sender: ButtonActive) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        _ = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        switch sender.titleLabel?.text?.localized() {
        case "Тёмное".localized():
            UserDefaults.standard.set("Тёмное".localized(), forKey: UserSettings.settingsMode)
            window?.overrideUserInterfaceStyle = .dark
        case "Светлое".localized():
            UserDefaults.standard.set("Светлое".localized(), forKey: UserSettings.settingsMode)
            window?.overrideUserInterfaceStyle = .light
        default:
            UserDefaults.standard.set("Системное".localized(), forKey: UserSettings.settingsMode)
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func toogleBlock(block: UIView, switcher: CustomSwitch, arr: [ButtonActive]) {
        
        if switcher.onTintColor == UIColor(red: 0.471, green: 0.471, blue: 0.502, alpha: 0.8) {
            switcher.statusOn()
            UIApplication.shared.unregisterForRemoteNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            PushNotification().notificationCenter.removeAllPendingNotificationRequests()
            block.alpha = 0.5
        } else {
            block.alpha = 1.0
            UIApplication.shared.registerForRemoteNotifications()
            switcher.statusOff()
            print(UIApplication.shared.isRegisteredForRemoteNotifications)
        }
        
       
    }
    
    func toggleActiveButtons(view: UIView, arr: [ButtonActive]) {
        if view.alpha == 0.5 {
            for i in 0..<arr.count {
                arr[i].isEnabled = false
            }
        } else {
            for i in 0..<arr.count {
                arr[i].isEnabled = true
            }
        }
    }
    
    
     
  func toggleHintsView(switcher: CustomSwitch) {
        if !switcher.isOn {
            UserDefaults.standard.set(true, forKey: UserSettings.hintsSwitcher)
            router?.delegateHintsBool(hidden: true)
            router?.setHintsBool()
        } else {
            UserDefaults.standard.set(false, forKey: UserSettings.hintsSwitcher)
            router?.delegateHintsBool(hidden: false)
            router?.setHintsBool()
        }
    }
    
    
//    func runPushNotice() -> UIAlertController {
//        var alertVC = UIAlertController()
//        PushNotification().notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
//            if error == nil {
//                print("success \(success)")
//            }
//
//            if !success {
//                PushNotification().notificationCenter.getNotificationSettings { settings in
//                    if settings.authorizationStatus != .authorized {
//
//                    }
//
//                }
//            } else {
//                alertVC = UIAlertController()
//            }
//        }
//
//        return alertVC
//    }
    
    func runPushNotice(completion: @escaping(Bool) -> Void) {
        PushNotification().notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if error == nil {
                print("success \(success)")
            }
            
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

