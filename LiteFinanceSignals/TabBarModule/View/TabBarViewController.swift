//
//  TabBarViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import UserNotifications

class TabBarViewController: UITabBarController {
    
    var presenter: TabBarPresenterProtocol!
    var views = [UIViewController]()
    let overlay: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.4)
        view.isHidden = true
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 30)
        return view
    }()
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGray6.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 30)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = CGRect.zero
       return gradientLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .customBGTab()
        self.tabBar.backgroundColor = .customBGTab()
        tabBar.clipsToBounds = true
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customBGTab()
        tabBar.standardAppearance = appearance
            //tabBar.scrollEdgeAppearance = appearance
        let standartAppearance = UINavigationBarAppearance()
        standartAppearance.configureWithTransparentBackground()
        //standartAppearance.backgroundColor = .customBGTab()
        UINavigationBar.appearance().standardAppearance = standartAppearance
        
        gradientLayer.frame = lineView.frame
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customTabBarItem()], for:.selected)
        UITabBar.appearance().backgroundColor = .customTabBarItem()
        UITabBar.appearance().tintColor = .customTabBarItem()
        lineView.layer.addSublayer(gradientLayer)
        self.view.addSubview(lineView)
        
        
        view.addSubview(overlay)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlay.frame = CGRect(x: self.tabBar.frame.minX, y: self.tabBar.frame.maxY - self.tabBar.frame.height, width: view.frame.width, height: self.tabBar.frame.height)
        lineView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height - self.tabBar.frame.height - lineView.frame.height)
    }
}

extension TabBarViewController: TabBarProtocol {
    func success(views: [UIViewController]) {
        self.views = views
        self.setViewControllers(self.views, animated: true)
        
        if !UserDefaults.standard.bool(forKey: "alertPush") {
            
            PushNotification.notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    return
                case .denied:
                    print("Denied, request permission from settings")
                   // self.presentCameraSettings()
                    return
                case .notDetermined:
                    PushNotification.notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in

                        if didAllow == true {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
//                                let defaultCheckButton = UIButton()
//                                defaultCheckButton.setTitle("Криптовалюты".localized(), for: .normal)
//                                print(ModuleButton.checkButton.titleLabel!.text!)
//                                ModuleButton.checkButton = defaultCheckButton
                                UserDefaults.standard.set(true, forKey: UserSettings.pushSwitcher)
                                let arr = ["Активно покупать".localized()]
                                UserDefaults.standard.set(arr, forKey: UserSettings.settingsRecommend)
                                
                                SettingModel.checkRecommend.append("Активно покупать".localized())
                                self.presenter.router?.initialVCController()
                                self.selectedIndex = 2
                            }
                        } else {
                            DispatchQueue.main.async {
                                UIApplication.shared.unregisterForRemoteNotifications()
//                                let defaultCheckButton = UIButton()
//                                defaultCheckButton.setTitle("Валюты".localized(), for: .normal)
//                                ModuleButton.checkButton = defaultCheckButton
                                self.selectedIndex = 1
                            }
                        }
                    }
                default:
                    return
                }
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                let alertVC = UIAlertController(title: "Push-уведомления", message: "Получайте своевременные сигналы от избранных торговых инструментов", preferredStyle: .alert)
//                let turnOn = UIAlertAction(title: "Включить уведомления", style: .default) { _ in
//                    UIApplication.shared.registerForRemoteNotifications()
//                    let defaultCheckButton = UIButton()
//                    defaultCheckButton.setTitle("M1", for: .normal)
//                    ModuleButton.checkButton = defaultCheckButton
//                    UserDefaults.standard.set(true, forKey: UserSettings.pushSwitcher)
//                    self.presenter.router?.initialVCController()
//
//                    self.selectedIndex = 2
//                }
//                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
//                    UIApplication.shared.unregisterForRemoteNotifications()
//                    let defaultCheckButton = UIButton()
//                    defaultCheckButton.setTitle("M1", for: .normal)
//                    ModuleButton.checkButton = defaultCheckButton
//                    //self.presenter.router?.initialVCController()
//                    self.selectedIndex = 1
//                }
//                alertVC.addAction(turnOn)
//                alertVC.addAction(cancel)
//                self.present(alertVC, animated: true)
//            })
            UserDefaults.standard.set(true, forKey: "alertPush")
        }
        
    }
    
//    func presentCameraSettings() {
//        let alertController = UIAlertController(title: "Error",
//                                      message: "Camera access is denied",
//                                      preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
//        alertController.addAction(UIAlertAction(title: "Настройки", style: .cancel) { _ in
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
//                    // Handle
//                })
//            }
//        })
//
//        present(alertController, animated: true)
//    }
    
    
}

