//
//  BuilderModule.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol SetRangeProtocol: AnyObject {
    var range: String! {get set}
    init(range: String)
}

class SetRangeTimeZone: SetRangeProtocol {
    var range: String!
    
    required init(range: String) {
        self.range = range
    }
}

protocol BuilderProtocol {
    //var tabBarVC: TabBarPresenterProtocol! {get set}
    func createSignalsViewController(alert: Bool, router: RouterProtocol) -> UIViewController
    func createSettingsViewController(router: RouterProtocol) -> UIViewController
    func createFavoriteViewController(tools: [AllDataModel]?, router: RouterProtocol, timeZone: String) -> UIViewController
    func createTabBarController(views: [UIViewController], router: RouterProtocol) -> UITabBarController
    func createFilterViewController(router: RouterProtocol) -> UIViewController
    func createToolViewController(customBar: CustomBarProtocol, tool: String?, router: RouterProtocol, arr: [AllDataModel]) -> UIViewController
    var presenterSignals: SignalsPresenter! {get set}
    var presenterFavorite: FavoritePresenter! {get set}
    func createCurrencyChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController
    func createCryptoChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController
    func createMetalChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController
    func createStockChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController
    func createIndexChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController
    var range: String! {get set}
    func updateFavoriteVC(tools: [AllDataModel], timeZone: String)
    func signalsToFavorite()
}


class BuilderModule: BuilderProtocol {
    //var tabBarVC: TabBarPresenterProtocol!
    var presenterSignals: SignalsPresenter!
    var customBar: CustomBarProtocol!
    var range: String!
    var tabBar: TabBarViewController!
    var favoriteVC: FavoriteViewController!
    var presenterFavorite: FavoritePresenter!
    
    func createTabBarController(views: [UIViewController], router: RouterProtocol) -> UITabBarController {
        let tabBar = TabBarViewController()
        let presenter = TabBarPresenter(view: tabBar, viewsTab: views, router: router, selectedTab: 1)
        tabBar.presenter = presenter
        //self.tabBarVC = tabBar.presenter
        self.tabBar = tabBar
        self.presenterSignals.tabBar = tabBar
        
        return tabBar
    }
    
    func createSignalsViewController(alert: Bool, router: RouterProtocol) -> UIViewController {
        let signalsVC = SignalsViewController()
        let network = NetworkService()
        let popOver = PopOverViewController()
        let customBar = CustomBar(view: signalsVC, title: "Сигналы".localized(), filterButton: false, searchButton: false, rangeButton: false, router: router)
//        if !UserDefaults.standard.string(forKey: UserSettings.timeZoneSignals)!.isEmpty {
//            print(UserDefaults.standard.string(forKey: UserSettings.timeZoneSignals))
//            customBar.titleRangeButton.text = UserDefaults.standard.string(forKey: UserSettings.timeZoneSignals)
//        }
        self.customBar = customBar
        signalsVC.successs(customBar: customBar)
        customBar.searchVC.searchBar.delegate = signalsVC
        let presenter = SignalsPresenter(view: signalsVC, network: network, router: router, customBar: customBar, builder: self)
        signalsVC.presenter = presenter
        self.presenterSignals = presenter
        customBar.presenterSignal = presenter
        let pop = createPopOverViewController(popOver: popOver, bar: customBar, router: router)
        customBar.popOver = pop
        var rout = router
        rout.presenterSignals = presenter
        
        return signalsVC
    }
    
    func createCurrencyChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        //self.presenterSignals.timerUpdate(time: router.timerRepear)
        
        var typesTool = [String]()
        
        if UserDefaults.standard.array(forKey: UserSettings.typeTools)!.isEmpty {
           
            typesTool = [ModuleButton.checkButton.titleLabel!.text!]
        } else {
            typesTool = UserDefaults.standard.array(forKey: UserSettings.typeTools)! as! [String]
        }
        
        var returnView = UIViewController()
        switch typesTool[0].localized() {
        case "Валюты".localized():
            let view = CurrencyView()
            let presenter = CurrencyPresenter(customBar: customBar, router: router)
            view.presenter = self.presenterSignals
            view.presenterCur = presenter
            returnView = view
        case "Криптовалюты".localized():
            let view = CryptoView()
            let presenter = CryptoPresenter(customBar: customBar)
            view.presenter = self.presenterSignals
            view.presenterCrypto = presenter
            returnView = view
        case "Металлы и нефть".localized():
            let view = MetalView()
            let presenter = MetalPresenter(customBar: customBar)
            view.presenter = self.presenterSignals
            view.presenterMetal = presenter
            returnView = view
        case "Акции".localized():
            let view = StocksView()
            let presenter = StockPresenter(customBar: customBar)
            view.presenter = self.presenterSignals
            view.presenterStock = presenter
            returnView = view
        default:
            let view = IndexView()
            let presenter = IndexPresenter(customBar: customBar)
            view.presenter = self.presenterSignals
            view.presenterIndex = presenter
            returnView = view
        }
        
        return returnView
    }
    
    func createCryptoChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        let view = CryptoView()
        let presenter = CryptoPresenter(customBar: customBar)
        view.presenter = self.presenterSignals
        view.presenterCrypto = presenter
        return view
    }
    
    func createMetalChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        let view = MetalView()
        let presenter = MetalPresenter(customBar: customBar)
        view.presenter = self.presenterSignals
        view.presenterMetal = presenter
        return view
    }
    
    func createStockChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        let view = StocksView()
        let presenter = StockPresenter(customBar: customBar)
        view.presenter = self.presenterSignals
        view.presenterStock = presenter
        return view
    }
    
    func createIndexChildVC(customBar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        let view = IndexView()
        let presenter = IndexPresenter(customBar: customBar)
        view.presenter = self.presenterSignals
        view.presenterIndex = presenter
        return view
    }
    
    
    func createSettingsViewController(router: RouterProtocol) -> UIViewController {
        let settingsVC = SettingsViewController()
        let network = NetworkService()
        let customBar = CustomBar(view: settingsVC, title: "Настройки".localized(), filterButton: true, searchButton: true, rangeButton: true, router: router)
        settingsVC.success(customBar: customBar)
        let presenter = SettingsPresenter(view: settingsVC, network: network, router: router, customBar: customBar)
        settingsVC.presenter = presenter
        settingsVC.signalsPresenter = self.presenterSignals
        presenter.signalsPresenter = self.presenterSignals
        return settingsVC
    }
    
    func createFavoriteViewController(tools: [AllDataModel]?, router: RouterProtocol, timeZone: String) -> UIViewController {
        let view = FavoriteViewController()
        let network = NetworkService()
        let popOver = PopOverViewController()
        let customBar = CustomBar(view: view, title: "Избранное".localized(), filterButton: true, searchButton: true, rangeButton: false, router: router)
//        if !UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)!.isEmpty {
//            customBar.titleRangeButton.text = UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)
//        }
        
        
        let presenter = FavoritePresenter(view: view, tools: tools, network: network, router: router, customBar: customBar)
        presenter.presenterSignals = presenterSignals
        view.presenter = presenter
        view.presenterSignals = presenterSignals
        self.presenterFavorite = presenter
        let pop = createPopOverViewController(popOver: popOver, bar: customBar, router: router)
        customBar.popOver = pop
        customBar.presenterFavorite = presenter
        customBar.presenterSignal = presenterSignals
        router.showRangePopOver(pop: pop, bar: customBar, view: view)
        self.favoriteVC = view
        //view.success(customBar: customBar)
        return view
    }
    
    func createFilterViewController(router: RouterProtocol) -> UIViewController {
        let filterVC = FilterViewController()
        let presenter = FilterPresenter(view: filterVC, router: router)
        filterVC.presenter = presenter
        filterVC.presenterSignals = self.presenterSignals
        presenter.presenterSignals = self.presenterSignals
        presenter.copyAllCurrency = self.presenterSignals.CopyAllDataCurrency
        presenter.copyAllCrypto = self.presenterSignals.CopyAllDataCrypto
        presenter.copyAllMetal = self.presenterSignals.CopyAllDataMetal
        presenter.copyAllStock = self.presenterSignals.CopyAllDataStock
        presenter.copyAllIndex = self.presenterSignals.CopyAllDataIndex
        return filterVC
    }
    
    func createToolViewController(customBar: CustomBarProtocol, tool: String?, router: RouterProtocol, arr: [AllDataModel]) -> UIViewController {
        let view = ToolViewController()
        let network = NetworkService()
        let presenter = ToolPresenter(customBar: customBar, network: network, view: view, tool: tool, router: router, arr: arr, signals: self.presenterSignals)
        view.presenter = presenter
        return view
    }
    
    func createPopOverViewController(popOver: PopOverViewController, bar: CustomBarProtocol, router: RouterProtocol) -> UIViewController {
        let presenter = PopOverPresenter(bar: bar, router: router)
        popOver.presenter = presenter
        bar.popOver = popOver
        return popOver
    }
    
    func updateFavoriteVC(tools: [AllDataModel], timeZone: String) {
        self.favoriteVC.presenter.view?.updateTableView(tools: tools, timeZone: timeZone)
    }
    
    func signalsToFavorite() {
        //self.presenterFavorite.presenterSignals = self.presenterSignals
       
    }
}

