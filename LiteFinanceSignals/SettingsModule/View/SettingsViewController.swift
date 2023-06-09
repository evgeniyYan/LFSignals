//
//  SettingsViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    var presenter: SettingsPresenterProtocol!
    var signalsPresenter: SignalsPresenterProtocol!

    var customBar = CustomBar()
    var scrollView = UIScrollView()
    
    let pushTitle = CustomTitle(text: "Push-уведомления от избранного".localized())
    let hintsTitle = CustomTitle(text: "Подсказки".localized())
    let updateTitle = CustomTitle(text: "Обновление сигналов".localized())
    
    let pushSwitch = CustomSwitch()
    let updateSwitch = CustomSwitch()
    let hintsSwitch = CustomSwitch()
    
    var noticeView: NoticeView!
    var updateView: UpdateView!
    //var hintsView: HintsView!
    var designView: DesignView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBGViewController()
        scrollView.backgroundColor = .customBGViewController()
        
        //UNUserNotificationCenter.current().delegate = self
       
        
        pushSwitch.addTarget(self, action: #selector(toggleSWitchPush), for: .valueChanged)
        updateSwitch.addTarget(self, action: #selector(toggleSWitchUpdate), for: .valueChanged)
        hintsSwitch.addTarget(self, action: #selector(toggleSwitchHints), for: .touchUpInside)
        
        //hintsSwitch.setOn(true, animated: true)
        
        view.addSubview(customBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(pushTitle)
        scrollView.addSubview(pushSwitch)
        scrollView.addSubview(noticeView)
        scrollView.addSubview(updateTitle)
        scrollView.addSubview(updateView)
        scrollView.addSubview(updateSwitch)
        scrollView.addSubview(updateSwitch)
        scrollView.addSubview(hintsTitle)
        scrollView.addSubview(hintsSwitch)
       // scrollView.addSubview(hintsView)
        scrollView.addSubview(designView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if pushSwitch.isOn {
//            let center = PushNotification().notificationCenter
//            center.delegate = self
//
//            let content = UNMutableNotificationContent()
//            content.title = "Название уведомления"
//            content.body = "Текст уведомления"
//            content.sound = UNNotificationSound.default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//
//
//            let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
//
//
//            center.add(request) { (error) in
//                if let error = error {
//                    print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
//                } else {
//                    print("Уведомление успешно добавлено")
//                }
//            }
            
           // presenter.signalsPresenter.localPush()
            
        } else {
//            let center = PushNotification().notificationCenter
//            center.removeAllPendingNotificationRequests()
            //center.removeAllDeliveredNotifications()
           presenter.signalsPresenter.turnOffLocalPush()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("screen \(UIScreen.main.bounds.height)")
        customBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIScreen.main.bounds.height / 6.5)
        scrollView.frame = CGRect(x: 0, y: customBar.frame.maxY, width: view.frame.width, height: view.frame.height)
        
        
        if UIScreen.main.bounds.height <= 667.0 {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 150)
        } else {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 50)
        }
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            pushTitle.frame = CGRect(x: view.frame.width - view.frame.width / 1.3 - 15, y: 25, width: view.frame.width / 1.3, height: 60)
            pushSwitch.frame = CGRect(x: 15, y: 37, width: 50, height: 30)
            noticeView.frame = CGRect(x: 15, y: pushTitle.frame.maxY + 30, width: view.frame.width - 30, height: 270)
            updateTitle.frame = CGRect(x: view.frame.width - view.frame.width - 15, y: noticeView.frame.maxY + 30, width: view.frame.width, height: 30)
            updateSwitch.frame = CGRect(x: 15, y: noticeView.frame.maxY + 30, width: 50, height: 30)
            updateView.frame = CGRect(x: 15, y: updateTitle.frame.maxY + 15, width: view.frame.width, height: 50)
            hintsTitle.frame = CGRect(x: view.frame.width - view.frame.width / 1.5 - 15, y: updateView.frame.maxY + 20, width: view.frame.width / 1.5, height: 30)
            
            hintsSwitch.frame = CGRect(x: 15, y: updateView.frame.maxY + 17, width: 50, height: 30)
            designView.frame = CGRect(x: 15, y: hintsTitle.frame.maxY + 30, width: view.frame.width, height: 100)
            
        } else {
            pushTitle.frame = CGRect(x: 15, y: 25, width: view.frame.width / 1.3, height: 60)
            pushSwitch.frame = CGRect(x: view.frame.width - 65, y: 37, width: 50, height: 30)
            noticeView.frame = CGRect(x: 15, y: pushTitle.frame.maxY + 30, width: view.frame.width - 30, height: 270)
            updateTitle.frame = CGRect(x: 15, y: noticeView.frame.maxY + 30, width: view.frame.width, height: 30)
            updateSwitch.frame = CGRect(x: updateTitle.frame.width - 65, y: noticeView.frame.maxY + 30, width: 50, height: 30)
            updateView.frame = CGRect(x: 15, y: updateTitle.frame.maxY + 15, width: view.frame.width, height: 50)
            hintsTitle.frame = CGRect(x: 15, y: updateView.frame.maxY + 20, width: view.frame.width / 1.5, height: 30)
            hintsSwitch.frame = CGRect(x: view.frame.width - 65, y: updateView.frame.maxY + 17, width: 50, height: 30)
            
            designView.frame = CGRect(x: 15, y: hintsTitle.frame.maxY + 30, width: view.frame.width, height: 100)
        }
        
        
       
    }
    
    @objc func toggleSWitchPush(_ sender: CustomSwitch) {
        presenter.toogleBlock(block: noticeView, switcher: sender, arr: noticeView.arrButton)
        presenter.toggleActiveButtons(view: noticeView, arr: noticeView.arrButton)
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: UserSettings.pushSwitcher)
            
            if UserDefaults.standard.array(forKey: UserSettings.settingsRecommend)!.isEmpty {
                noticeView.arrButton.first?.WhiteTrue()
                UserDefaults.standard.set([noticeView.arrButton.first!.titleLabel!.text], forKey: UserSettings.settingsRecommend)
            }
            
            //UIApplication.shared.registerForRemoteNotifications()
            presenter.runPushNotice { answer in
                if answer {
                    self.presenter.signalsPresenter.localPush()
                } else {
                    let alertController = UIAlertController(title: "Push-уведомления".localized(), message: "Получайте своевременные сигналы от избранных торговых инструментов".localized(), preferredStyle: .alert)
                    let settignsAction = UIAlertAction(title: "Включить уведомления".localized(), style: .default) { _ -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl) { success in
                                self.presenter.signalsPresenter.localPush()
                            }
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: "Отмена".localized(), style: .cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settignsAction)
                    
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                }
            }
           
           // presenter.signalsPresenter.localPush()
            
        } else {
            UserDefaults.standard.set(false, forKey: UserSettings.pushSwitcher)
            presenter.signalsPresenter.turnOffLocalPush()
            //UIApplication.shared.unregisterForRemoteNotifications()
           // let center = PushNotification().notificationCenter
//            center.delegate = self
//            center.removeAllDeliveredNotifications()
            //center.removeAllPendingNotificationRequests()
        }
    }
    
    @objc func toggleSWitchUpdate(_ sender: CustomSwitch) {
        
        presenter.toogleBlock(block: updateView, switcher: sender, arr: updateView.arrButton)
        presenter.toggleActiveButtons(view: updateView, arr: updateView.arrButton)
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: UserSettings.updateSwitcher)
        } else {
            UserDefaults.standard.set(false, forKey: UserSettings.updateSwitcher)
        }
    }
    
    @objc func toggleSwitchHints() {
        presenter.toggleHintsView(switcher: hintsSwitch)
    }
}

extension SettingsViewController: SettingsProtocol {
    func setChildView(notice: NoticeView, update: UpdateView, hints: HintsView, design: DesignView) {
        self.noticeView = notice
        self.updateView = update
        //self.hintsView = hints
        self.designView = design
        
//        if UserDefaults.standard.bool(forKey: UserSettings.pushSwitcher) {
//            self.pushSwitch.setOn(true, animated: false)
//            self.pushSwitch.statusOff()
//            self.noticeView.alpha = 1.0
//            for i in 0..<self.noticeView.arrButton.count {
//                self.noticeView.arrButton[i].isEnabled = true
//            }
//        } else {
//            self.pushSwitch.setOn(false, animated: false)
//            self.pushSwitch.statusOn()
//        }
        
        if UserDefaults.standard.bool(forKey: UserSettings.updateSwitcher) {
            self.updateSwitch.setOn(true, animated: false)
            self.updateSwitch.statusOff()
            self.updateView.alpha = 1.0
            for i in 0..<self.updateView.arrButton.count {
                self.updateView.arrButton[i].isEnabled = true
            }
        } else {
            self.updateSwitch.setOn(false, animated: false)
            self.updateSwitch.statusOn()
        }
        
        if UserDefaults.standard.bool(forKey: UserSettings.hintsSwitcher) {
            self.hintsSwitch.setOn(false, animated: false)
            self.hintsSwitch.statusOn()
        } else {
            self.hintsSwitch.setOn(true, animated: false)
            self.hintsTitle.alpha = 1.0
            self.hintsSwitch.statusOff()
        }
    }
    
    
    func success(customBar: CustomBar) {
        self.customBar = customBar
    }
   
}

//extension SettingsViewController: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert])
//    }
//
//}
