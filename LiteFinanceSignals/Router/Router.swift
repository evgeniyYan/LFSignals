//
//  Router.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? {get set}
    var assemblyBuilder: BuilderProtocol? {get set}
}

protocol RouterHintsDelegate {
    func setHiddenButton(hidden: Bool)
}

protocol RouterProtocol: RouterMain {
    func initialTabBarController()
    func showFilter()
    func showTool(customBar: CustomBarProtocol, tool: String?, arr: [AllDataModel])
    var views: [UIViewController]! {get set}
    func showRangePopOver(pop: UIViewController, bar: CustomBar, view: UIViewController)
    func showChildVC(customBar: CustomBarProtocol, text: String) -> UIViewController?
    func showFirstChildVC(customBar: CustomBarProtocol) -> UIViewController?
    func delegateHintsBool(hidden: Bool)
    func setHintsBool()
    var presenterSignals: SignalsPresenter! {get set}
    var presenterFavorite: FavoritePresenter! {get set}
    var hintsBool: Bool! {get set}
    var customBar: CustomBarProtocol! {get set}
    func changeCheckTool(tool: String, title: String, color: UIColor)
    func delegateFavoriteTool(tools: [AllDataModel], timeZone: String)
    var tabBarController: UITabBarController! {get set}
    var timerRepear: TimeInterval! {get set}
    func initialVCController()
    func updateFavoriteVC(tools: [AllDataModel], timeZone: String)
    func startTimer()
    var favoriteTimeZone: String! {get set}
    func delegatePresenterToFavorite()
    var allTools: [AllDataModel] {get set}
}

class Router: RouterProtocol {
   
    var navigationController: UINavigationController?
    var views: [UIViewController]!
    var assemblyBuilder: BuilderProtocol?
    var hintsBool: Bool! = false
    var curVC = UIViewController()
    var presenterSignals: SignalsPresenter!
    var presenterFavorite: FavoritePresenter!
    var customBar: CustomBarProtocol!
    var tabBarController: UITabBarController!
    var favoriteViewController: UIViewController!
    var signalsViewController: UIViewController!
    var settingsViewController: UIViewController!
    var timerRepear: TimeInterval! = 1
    var favoriteTimeZone: String! = ""
    var allTools: [AllDataModel] = [AllDataModel]()
    
    init(navigationController: UINavigationController, assemblyBuilder: BuilderProtocol) {
        
        self.assemblyBuilder = assemblyBuilder
        self.navigationController = navigationController
        
        if !UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)!.isEmpty {
            self.favoriteTimeZone = "M1"
        } else {
            self.favoriteTimeZone = UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)
        }
    }
    
    func initialTabBarController() {
        self.views = [UIViewController]()
        if let navigationController = navigationController {
            let favoriteTool = UserDefault.decodableData(key: UserSettings.favoriteTool)
            guard let favoriteViewController = assemblyBuilder?.createFavoriteViewController(tools: favoriteTool, router: self, timeZone: self.favoriteTimeZone) else {return}
            favoriteViewController.tabBarItem = UITabBarItem(title: "Избранное".localized(), image: UIImage(systemName: "star"), tag: 0)
            self.views.append(favoriteViewController)
            self.favoriteViewController = favoriteViewController
            
            guard let signalsViewController = assemblyBuilder?.createSignalsViewController(alert: UserDefaults.standard.bool(forKey: "alertPush"), router: self) else { return }
            signalsViewController.tabBarItem = UITabBarItem(title: "Сигналы".localized(), image: UIImage(systemName: "list.bullet"), tag: 1)
            self.views.append(signalsViewController)
            self.signalsViewController = signalsViewController
            
            guard let settingsViewController = assemblyBuilder?.createSettingsViewController(router: self) else { return }
            settingsViewController.tabBarItem = UITabBarItem(title: "Настройки".localized(), image: UIImage(systemName: "gearshape"), tag: 2)
            self.views.append(settingsViewController)
            self.settingsViewController = settingsViewController
            
            guard let tabBarController = assemblyBuilder?.createTabBarController(views: self.views, router: self) else { return }
            self.tabBarController = tabBarController
            tabBarController.selectedIndex = 1
            navigationController.viewControllers = [tabBarController]
            self.navigationController = navigationController
        }
    }
    
    func delegatePresenterToFavorite() {
        assemblyBuilder?.signalsToFavorite()
    }
    
    
    func delegateFavoriteTool(tools: [AllDataModel], timeZone: String) {
        updateFavoriteVC(tools: tools, timeZone: timeZone)
//        print("self.tabBarController.viewControllers \(self.tabBarController.viewControllers)")
//       // self.views = [UIViewController]()
//        if let navigationController = navigationController {
//            guard let favoriteVC = assemblyBuilder?.createFavoriteViewController(tools: tools, router: self, timeZone: timeZone) else {return }
//            favoriteVC.tabBarItem = UITabBarItem(title: "Избранное".localized(), image: UIImage(systemName: "star"), tag: 0)
//            self.favoriteViewController = favoriteVC
//           // self.tabBarController.viewControllers = [favoriteVC, self.signalsViewController, self.settingsViewController]
//            //navigationController.viewControllers = [self.tabBarController]
//            for i in 0..<self.views.count {
//                if self.views[i] == FavoriteViewController() {
//                    self.views[i] = favoriteVC
//                }
//            }
//            //self.views[0] = favoriteVC
//            print("self.views \(self.views)")
//            self.tabBarController.viewControllers = self.views
//
//            navigationController.viewControllers = [tabBarController]
//        }
    }
    
    func initialVCController() {
        self.views = [UIViewController]()
        if let navigationController = navigationController {
            guard let favoriteViewController = assemblyBuilder?.createFavoriteViewController(tools: UserDefault.decodableData(key: UserSettings.favoriteTool), router: self, timeZone: self.favoriteTimeZone) else {return}
            favoriteViewController.tabBarItem = UITabBarItem(title: "Избранное".localized(), image: UIImage(systemName: "star"), tag: 0)
            self.views.append(favoriteViewController)
            self.favoriteViewController = favoriteViewController
            
            guard let signalsViewController = assemblyBuilder?.createSignalsViewController(alert: UserDefaults.standard.bool(forKey: "alertPush"), router: self) else { return }
            signalsViewController.tabBarItem = UITabBarItem(title: "Сигналы".localized(), image: UIImage(systemName: "list.bullet"), tag: 1)
            self.views.append(signalsViewController)
            self.signalsViewController = signalsViewController
            
            guard let settingsViewController = assemblyBuilder?.createSettingsViewController(router: self) else { return }
            settingsViewController.tabBarItem = UITabBarItem(title: "Настройки".localized(), image: UIImage(systemName: "gearshape"), tag: 2)
            self.views.append(settingsViewController)
            self.settingsViewController = settingsViewController
            self.tabBarController.viewControllers = [favoriteViewController, signalsViewController, settingsViewController]
            navigationController.viewControllers = [self.tabBarController]
        }
    }
    
    func startTimer() {
        self.presenterSignals.timerUpdate(time: self.timerRepear)
    }
    
    func showFirstChildVC(customBar: CustomBarProtocol) -> UIViewController? {
        let view = assemblyBuilder?.createCurrencyChildVC(customBar: customBar, router: self)
        return view
    }
    
    func showFilter() {
        if let navigationController = navigationController {
            guard let filterViewController = assemblyBuilder?.createFilterViewController(router: self) else { return }
            filterViewController.modalPresentationStyle = .fullScreen
            navigationController.present(filterViewController, animated: true)
            
            
        }
    }
    
    
    
    func showTool(customBar: CustomBarProtocol, tool: String?, arr: [AllDataModel]) {
        if let navigationController = navigationController {
            guard let toolViewController = assemblyBuilder?.createToolViewController(customBar: customBar, tool: tool!, router: self, arr: arr) else { return }
            navigationController.pushViewController(toolViewController, animated: true)
        }
    }
    
    
    
    func showRangePopOver(pop: UIViewController, bar: CustomBar, view: UIViewController) {
        pop.modalPresentationStyle = .popover
        guard let popOverVC = pop.popoverPresentationController else { return }
        popOverVC.delegate = bar.self
        popOverVC.sourceView = bar
        popOverVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        var count = 0
       
        if UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)!.isEmpty {
        //if TimeZoneRange.arrCheckIn.isEmpty {
            pop.preferredContentSize = CGSize(width: 75, height: TimeZoneRange.arr.count * 44)
            count = TimeZoneRange.arr.count
        } else {
            let saveArr = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String]
            pop.preferredContentSize = CGSize(width: 75, height: saveArr.count * 44)
            count = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)!.count
        }
        
        
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            print("LocaleLayout.getLocale() \(LocaleLayout.getLocale())")
            popOverVC.sourceRect = CGRect(x: 0, y: Int(bar.frame.height + CGFloat(count * 22)), width: 0, height: 0)
            
        } else {
            print("LocaleLayout.getLocale() \(LocaleLayout.getLocale())")
            print("UIScreen.main.bounds.width \(UIScreen.main.bounds.width)")
            popOverVC.sourceRect = CGRect(x: Int(UIScreen.main.bounds.width), y: Int(bar.frame.height + CGFloat(count * 22)), width: 0, height: 0)
        }
        
        bar.view!.present(pop, animated: true)
    }
    
    
    
    
    func showChildVC(customBar: CustomBarProtocol, text: String) -> UIViewController? {
        var view = UIViewController()
        switch text.localized() {
        case "Валюты".localized():
            guard let curVC = assemblyBuilder?.createCurrencyChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = curVC
            self.curVC = curVC
        case "Криптовалюты".localized():
            guard let cryptoVC = assemblyBuilder?.createCryptoChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = cryptoVC
        case "Металлы и нефть".localized():
            guard let metalVC = assemblyBuilder?.createMetalChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = metalVC
        case "Акции".localized():
            guard let stockVC = assemblyBuilder?.createStockChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = stockVC
        case "Биржевые индексы".localized():
            guard let indexVC = assemblyBuilder?.createIndexChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = indexVC
        default:
            guard let curVC = assemblyBuilder?.createCurrencyChildVC(customBar: customBar, router: self) else { return UIViewController() }
            view = curVC
        }
        
        return view
    }
    
    func delegateHintsBool(hidden: Bool) {
        self.hintsBool = hidden
    }
    
    func setHintsBool() {
        self.presenterSignals.updateChildAfterSetting()
       
    }
    
    func updateFavoriteVC(tools: [AllDataModel], timeZone: String) {
        assemblyBuilder?.updateFavoriteVC(tools: tools, timeZone: timeZone)
    }
    
    func changeCheckTool(tool: String, title: String, color: UIColor) {
        var allTool = [AllDataModel]()
        var newAllTool = [AllDataModel]()
        var finder = [AllDataModel]()
        
        if color == .white {
            switch title.localized() {
            case "Валюты".localized():
                allTool = presenterSignals.allDataCurrency!
                let copyAllTool = presenterSignals.CopyAllDataCurrency!
//                var check = [Any]()
//
//                if UserDefaults.standard.array(forKey: UserSettings.checkOutCurrency)!.isEmpty {
//                    check = CheckTools.checkOutCurrency
//                } else {
//                    check = UserDefaults.standard.array(forKey: UserSettings.checkOutCurrency)!
//                }
                
                // add tool
                for i in 0..<copyAllTool.count {
                    let toolArr = copyAllTool[i]
                    if toolArr.title == tool { allTool.append(toolArr) }
                }
                
                // remove tool from arr checkout
                for i in 0..<CheckTools.checkOutCurrency.count {
                    let out = CheckTools.checkOutCurrency[i]
                    if out.title != tool { finder.append(out) }
                }
                
                CheckTools.checkOutCurrency = finder
                //UserDefaults.standard.set(finder, forKey: UserSettings.checkOutCurrency)
                UserDefault.encodableData(data: allTool, key: UserSettings.checkOutCurrency)
                presenterSignals.allDataCurrency = allTool
                CheckTools.checkInCurrency = allTool
                //UserDefaults.standard.set(allTool, forKey: UserSettings.checkInCurrency)
                UserDefault.encodableData(data: allTool, key: UserSettings.checkInCurrency)
                
            case "Криптовалюты".localized():
                allTool = presenterSignals.allDataCrypto!
                let copyAllTool = presenterSignals.CopyAllDataCrypto!
               
                // add tool
                for i in 0..<copyAllTool.count {
                    let toolArr = copyAllTool[i]
                    if toolArr.title == tool { allTool.append(toolArr) }
                }
                
                // remove tool from arr checkout
                for i in 0..<CheckTools.checkOutCrypto.count {
                    let out = CheckTools.checkOutCrypto[i]
                    if out.title != tool { finder.append(out) }
                }
                
                CheckTools.checkOutCrypto = finder
                UserDefaults.standard.set(finder, forKey: UserSettings.checkOutCrypto)
                presenterSignals.allDataCrypto = allTool
                CheckTools.checkInCrypto = allTool
                UserDefaults.standard.set(allTool, forKey: UserSettings.checkInCrypto)
            case "Металлы и нефть".localized():
                allTool = presenterSignals.allDataMetal!
                let copyAllTool = presenterSignals.CopyAllDataMetal!
            
                // add tool
                for i in 0..<copyAllTool.count {
                    let toolArr = copyAllTool[i]
                    if toolArr.title == tool { allTool.append(toolArr) }
                }
                
                // remove tool from arr checkout
                for i in 0..<CheckTools.checkOutMetal.count {
                    let out = CheckTools.checkOutMetal[i]
                    if out.title != tool { finder.append(out) }
                }
                
                CheckTools.checkOutMetal = finder
                //UserDefaults.standard.set(finder, forKey: UserSettings.checkOutMetal)
                UserDefault.encodableData(data: finder, key: UserSettings.checkOutMetal)
                presenterSignals.allDataMetal = allTool
                CheckTools.checkInMetal = allTool
                //UserDefaults.standard.set(allTool, forKey: UserSettings.checkInMetal)
                UserDefault.encodableData(data: allTool, key: UserSettings.checkInMetal)
            case "Акции".localized():
                allTool = presenterSignals.allDataStock!
                let copyAllTool = presenterSignals.CopyAllDataStock!
                
                // add tool
                for i in 0..<copyAllTool.count {
                    let toolArr = copyAllTool[i]
                    if toolArr.title == tool { allTool.append(toolArr) }
                }
                
                // remove tool from arr checkout
                for i in 0..<CheckTools.checkOutStock.count {
                    let out = CheckTools.checkOutStock[i]
                    if out.title != tool { finder.append(out) }
                }
                
                CheckTools.checkOutStock = finder
                //UserDefaults.standard.set(finder, forKey: UserSettings.checkOutStock)
                UserDefault.encodableData(data: finder, key: UserSettings.checkOutStock)
                presenterSignals.allDataStock = allTool
                CheckTools.checkInStock = allTool
                //UserDefaults.standard.set(allTool, forKey: UserSettings.checkInStock)
                UserDefault.encodableData(data: allTool, key: UserSettings.checkInStock)
            default:
                allTool = presenterSignals.allDataIndex!
                let copyAllTool = presenterSignals.CopyAllDataIndex!
                
                // add tool
                for i in 0..<copyAllTool.count {
                    let toolArr = copyAllTool[i]
                    if toolArr.title == tool { allTool.append(toolArr) }
                }
                
                // remove tool from arr checkout
                for i in 0..<CheckTools.checkOutIndex.count {
                    let out = CheckTools.checkOutIndex[i]
                    if out.title != tool { finder.append(out) }
                }
                
                CheckTools.checkOutIndex = finder
                //UserDefaults.standard.set(finder, forKey: UserSettings.checkOutIndex)
                UserDefault.encodableData(data: finder, key: UserSettings.checkOutIndex)
                presenterSignals.allDataIndex = allTool
                CheckTools.checkInIndex = allTool
                //UserDefaults.standard.set(allTool, forKey: UserSettings.checkInIndex)
                UserDefault.encodableData(data: allTool, key: UserSettings.checkInIndex)
            }
        } else {
            switch title {
            case "Валюты".localized():
                if UserDefault.decodableData(key: UserSettings.checkInCurrency).isEmpty {
                //if CheckTools.checkInCurrency.isEmpty {
                    allTool = presenterSignals.allDataCurrency!
                    
                } else {
                    allTool = UserDefault.decodableData(key: UserSettings.checkInCurrency)
                    
                }
                
                for i in 0..<allTool.count {
                    let toolArr = allTool[i]
                    if toolArr.title != tool {
                        newAllTool.append(toolArr)
                    } else {
                        CheckTools.checkOutCurrency.append(toolArr)
                    }
                }
                //UserDefaults.standard.set(newAllTool, forKey: UserSettings.checkInCurrency)
                UserDefault.encodableData(data: newAllTool, key: UserSettings.checkInCurrency)
                //UserDefaults.standard.set(CheckTools.checkOutCurrency, forKey: UserSettings.checkOutCurrency)
                UserDefault.encodableData(data: CheckTools.checkOutCurrency, key: UserSettings.checkOutCurrency)
                CheckTools.checkInCurrency = newAllTool
                presenterSignals.allDataCurrency = allTool
                
              
            case "Криптовалюты".localized():
                if UserDefault.decodableData(key: UserSettings.checkInCrypto).isEmpty {
                //if CheckTools.checkInCrypto.isEmpty {
                    allTool = presenterSignals.allDataCrypto!
                    
                } else {
                    allTool = UserDefault.decodableData(key: UserSettings.checkInCrypto)
                    
                }
                
                for i in 0..<allTool.count {
                    let toolArr = allTool[i]
                    if toolArr.title != tool { newAllTool.append(toolArr) } else { CheckTools.checkOutCrypto.append(toolArr) }
                }
                //UserDefaults.standard.set(newAllTool, forKey: UserSettings.checkInCrypto)
                UserDefault.encodableData(data: newAllTool, key: UserSettings.checkInCrypto)
                //UserDefaults.standard.set(CheckTools.checkOutCrypto, forKey: UserSettings.checkOutCrypto)
                UserDefault.encodableData(data: CheckTools.checkOutCrypto, key: UserSettings.checkOutCrypto)
                CheckTools.checkInCrypto = newAllTool
                presenterSignals.allDataCrypto = allTool
            case "Металлы и нефть".localized():
                if UserDefault.decodableData(key: UserSettings.checkInMetal).isEmpty {
                //if CheckTools.checkInMetal.isEmpty {
                    allTool = presenterSignals.allDataMetal!
                } else {
                    allTool = UserDefault.decodableData(key: UserSettings.checkInMetal)
                }
                
                for i in 0..<allTool.count {
                    let toolArr = allTool[i]
                    if toolArr.title != tool { newAllTool.append(toolArr) } else {  CheckTools.checkOutMetal.append(toolArr) }
                }
                //UserDefaults.standard.set(newAllTool, forKey: UserSettings.checkInMetal)
                UserDefault.encodableData(data: newAllTool, key: UserSettings.checkInMetal)
                //UserDefaults.standard.set(CheckTools.checkOutMetal, forKey: UserSettings.checkOutMetal)
                UserDefault.encodableData(data: CheckTools.checkOutMetal, key: UserSettings.checkOutMetal)
                CheckTools.checkInMetal = newAllTool
                presenterSignals.allDataMetal = allTool
            case "Акции".localized():
                if UserDefault.decodableData(key: UserSettings.checkInStock).isEmpty {
                //if CheckTools.checkInStock.isEmpty {
                    allTool = presenterSignals.allDataStock!
                } else {
                    allTool = UserDefault.decodableData(key: UserSettings.checkInStock)
                }
                
                for i in 0..<allTool.count {
                    let toolArr = allTool[i]
                    if toolArr.title != tool { newAllTool.append(toolArr) } else { CheckTools.checkOutStock.append(toolArr) }
                }
                CheckTools.checkInStock = newAllTool
                //UserDefaults.standard.set(newAllTool, forKey: UserSettings.checkInStock)
                UserDefault.encodableData(data: newAllTool, key: UserSettings.checkInStock)
                //UserDefaults.standard.set(CheckTools.checkOutStock, forKey: UserSettings.checkOutStock)
                UserDefault.encodableData(data: CheckTools.checkOutStock, key: UserSettings.checkOutStock)
                presenterSignals.allDataStock = allTool
            default:
                if UserDefault.decodableData(key: UserSettings.checkInIndex).isEmpty {
                //if CheckTools.checkInIndex.isEmpty {
                    allTool = presenterSignals.allDataIndex!
                } else {
                    allTool = UserDefault.decodableData(key: UserSettings.checkInIndex)
                }
                
                for i in 0..<allTool.count {
                    let toolArr = allTool[i]
                    if toolArr.title != tool { newAllTool.append(toolArr) } else { CheckTools.checkOutIndex.append(toolArr) }
                }
                CheckTools.checkInIndex = newAllTool
                //UserDefaults.standard.set(newAllTool, forKey: UserSettings.checkInIndex)
                UserDefault.encodableData(data: newAllTool, key: UserSettings.checkInIndex)
                //UserDefaults.standard.set(UserSettings.checkOutIndex, forKey: UserSettings.checkOutIndex)
                UserDefault.encodableData(data: CheckTools.checkOutIndex, key: UserSettings.checkOutIndex)
                presenterSignals.allDataIndex = allTool
            }
        }
    }
}



