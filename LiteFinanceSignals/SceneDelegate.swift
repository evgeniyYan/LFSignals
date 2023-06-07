//
//  SceneDelegate.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var router: RouterProtocol!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UNUserNotificationCenter.current().delegate = self
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let nav = UINavigationController()
        
        
        if !UserDefaults.standard.bool(forKey: "alertPush") {
            UserDefaults.standard.set(true, forKey: UserSettings.boolSkeleton )
            UserDefaults.standard.set(TimeZoneRange.arr, forKey: UserSettings.timeZoneRange)
            UserDefaults.standard.set(TypeTools.checkInType, forKey: UserSettings.typeTools)
            UserDefaults.standard.set(Recommend.checkRecommend, forKey: UserSettings.recommend)
            UserDefaults.standard.set(CheckTools.checkInCurrency, forKey: UserSettings.checkInCurrency)
            UserDefaults.standard.set(CheckTools.checkOutCurrency, forKey: UserSettings.checkOutCurrency)
            UserDefaults.standard.set(CheckTools.checkInCrypto, forKey: UserSettings.checkInCrypto)
            UserDefaults.standard.set(CheckTools.checkOutCrypto, forKey: UserSettings.checkOutCrypto)
            UserDefaults.standard.set(CheckTools.checkInMetal, forKey: UserSettings.checkInMetal)
            UserDefaults.standard.set(CheckTools.checkOutMetal, forKey: UserSettings.checkOutMetal)
            UserDefaults.standard.set(CheckTools.checkInStock, forKey: UserSettings.checkInStock)
            UserDefaults.standard.set(CheckTools.checkOutStock, forKey: UserSettings.checkOutStock)
            UserDefaults.standard.set(CheckTools.checkInIndex, forKey: UserSettings.checkInIndex)
            UserDefaults.standard.set(CheckTools.checkOutIndex, forKey: UserSettings.checkOutIndex)
            UserDefaults.standard.set(SettingModel.checkRecommend, forKey: UserSettings.settingsRecommend)
            UserDefaults.standard.set("1 минута".localized(), forKey: UserSettings.settingsUpdate)
            UserDefaults.standard.set(1, forKey: UserSettings.updateNumber)
            UserDefaults.standard.set("Системное".localized(), forKey: UserSettings.settingsMode)
            //UserDefaults.standard.set(FavotiteTools.favoriteArr, forKey: UserSettings.favoriteTool)
            UserDefault.encodableData(data: FavotiteTools.favoriteArr, key: UserSettings.favoriteTool)
            UserDefaults.standard.set("M1", forKey: UserSettings.timeZoneSignals)
            UserDefaults.standard.set("M1", forKey: UserSettings.timeZoneFavorite)
            let defaultButtons = UIButton()
            defaultButtons.setTitle("Валюты".localized(), for: .normal)
            ModuleButton.checkButton = defaultButtons
        }
        else {
            FavotiteTools.favoriteArr = UserDefault.decodableData(key: UserSettings.favoriteTool)
//            FavotiteTools.favoriteArr = UserDefaults.standard.array(forKey: UserSettings.favoriteTool)! as! [AllDataModel]
            switch UserDefaults.standard.string(forKey: UserSettings.settingsMode)!.localized() {
            case "Тёмное".localized():
                window?.overrideUserInterfaceStyle = .dark
            case "Светлое".localized():
                window?.overrideUserInterfaceStyle = .light
            default:
                window?.overrideUserInterfaceStyle = .unspecified
            }
        }
        
        let assembly = BuilderModule()
        let router = Router(navigationController: nav, assemblyBuilder: assembly)
        self.router = router
        router.initialTabBarController()
        //router.initialViewController()
        
        let number = TimeInterval(UserDefaults.standard.integer(forKey: UserSettings.updateNumber))
        Timer.scheduledTimer(withTimeInterval: number * 60, repeats: true) { _ in
            router.startTimer()
        }
        
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let tool = response.notification.request.content.body.components(separatedBy: ":")[0]
        FavotiteTools.pushTapTool = tool
        
        //self.router.presenterSignals.taponDetailVC(tool: FavotiteTools.pushTapTool)
        self.router.presenterFavorite.openToolVCFromPush(tool: FavotiteTools.pushTapTool)
    }
    

}

