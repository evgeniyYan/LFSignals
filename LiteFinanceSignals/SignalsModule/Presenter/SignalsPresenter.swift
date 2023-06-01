//
//  SignalsPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import UserNotifications

protocol SignalsProtocol: AnyObject {
    func successs(customBar: CustomBar)
    func failure(error: Error, tableView: Bool, errorView: Bool)
    func setChildVC(child: UIViewController)
    func showErrorView(tableView: Bool, errorView: Bool)
    func showSearchEmptyView(count: Int, text: String)
}


protocol SignalsPresenterProtocol: AnyObject {
    init(view: SignalsProtocol, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol, builder: BuilderProtocol)
    var allTools: [AllDataModel]? {get set}
    var view: SignalsProtocol? {get set}
    func getComment()
    func taponDetailVC(tool: String?)
    func getAllNames(tools: [AllDataModel]?) -> [String]
    var allNamesTools: [String]? {get set}
    var allDataCurrency: [AllDataModel]? {get set}
    var CopyAllDataCurrency: [AllDataModel]? {get set}
    var allDataCrypto: [AllDataModel]? {get set}
    var CopyAllDataCrypto: [AllDataModel]? {get set}
    var allDataMetal: [AllDataModel]? {get set}
    var CopyAllDataMetal: [AllDataModel]? {get set}
    var allDataStock: [AllDataModel]? {get set}
    var CopyAllDataStock: [AllDataModel]? {get set}
    var allDataIndex: [AllDataModel]? {get set}
    var CopyAllDataIndex: [AllDataModel]? {get set}
    var allCurrecnyCount: [String]! {get set}
    var allCryptoCount: [String]! {get set}
    var allMetalCount: [String]! {get set}
    var allStockCount: [String]! {get set}
    var allIndexCount: [String]! {get set}
    func processingDate(arr: [AllDataModel]?, name: String, range: String) -> String
    func tapPopOVerButton(text: String)
    func tapCollectionButton(sender: UIButton)
    func distributionAllData(all: [AllDataModel]?)
    func processingColorRating(arr: [AllDataModel]?, name: String, range: String) -> [UIColor]
    var builder: BuilderProtocol! {get set}
    var router: RouterProtocol! {get set}
    func getNamesForCollection(tool: String) -> [String]
    func getTypeTool(text: String) -> Int
    func getToolCount(arr: [AllDataModel]) -> [AllDataModel]
    var textCustomBarRangeButton: String! {get set}
    func searchTool(text: String, typeTool: String)
    func cancelSearch()
    var tabBar: TabBarViewController! {get set}
    func newStatus(dateAPI: String) -> Bool
    func returnTime(dateAPI: String) -> String
    func updateChildAfterSetting()
    func timerUpdate(time: TimeInterval)
    func getStatusRecommend(number: Int64) -> String
    func localPush()
    func turnOffLocalPush()
}


class SignalsPresenter: SignalsPresenterProtocol {
    
    weak var view: SignalsProtocol?
    var network: NetworkProtocol!
    var allTools: [AllDataModel]?
    var allNamesTools: [String]?
    var router: RouterProtocol!
    var customBar: CustomBarProtocol!
    var allDataCurrency: [AllDataModel]?
    var CopyAllDataCurrency: [AllDataModel]?
    var allDataCrypto: [AllDataModel]?
    var CopyAllDataCrypto: [AllDataModel]?
    var allDataMetal: [AllDataModel]?
    var CopyAllDataMetal: [AllDataModel]?
    var allDataStock: [AllDataModel]?
    var CopyAllDataStock: [AllDataModel]?
    var allDataIndex: [AllDataModel]?
    var CopyAllDataIndex: [AllDataModel]?
    var allCurrecnyCount: [String]!
    var allCryptoCount: [String]!
    var allMetalCount: [String]!
    var allStockCount: [String]!
    var allIndexCount: [String]!
    var builder: BuilderProtocol!
    var textCustomBarRangeButton: String!
    var searchTools: [AllDataModel]!
    var tabBar: TabBarViewController!
    var identifierPush: String = ""
    
    
    required init(view: SignalsProtocol, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol, builder: BuilderProtocol) {
        self.view = view
        self.network = network
        self.router = router
        self.customBar = customBar
        self.builder = builder
        self.textCustomBarRangeButton = customBar.titleRangeButton.text!
        getComment()
        router.delegatePresenterToFavorite()
    }
    
    
    func getComment() {
        network.parseAllNameTools { result in
            switch result {
            case .success(let tools):
                if tools == nil {
                    self.view?.showErrorView(tableView: true, errorView: false)
                }
                else {
                    self.allTools = tools!
                    self.router.allTools = tools!
                    self.view?.successs(customBar: self.customBar as! CustomBar)
                    self.distributionAllData(all: tools)
                }
            case .failure(let error):
                self.view?.failure(error: error, tableView: true, errorView: false)
                
            }
        }
    }
    
    func taponDetailVC(tool: String?) {
        let all = allTools!
        var toolArr = [AllDataModel]()
        
        for i in 0..<all.count {
            let mass = all[i]
            let str = mass.title
            
            if str == tool! {
                toolArr.append(all[i])
            }
        }
        
        router?.showTool(customBar: self.customBar, tool: tool, arr: toolArr)
    }
    
    
    
    
    func getAllNames(tools: [AllDataModel]?) -> [String] {
        var arr = [String]()
        for i in 0..<tools!.count {
            let arrAny = tools![i]
            arr.append(arrAny.title)
        }
        arr = arr.uniqued()
        return arr
    }
    
    func processingDate(arr: [AllDataModel]?, name: String, range: String) -> String {
        var timeString = ""
        for i in 0..<arr!.count {
            let arrInside = arr![i]
            
            if arrInside.title == name && arrInside.timeFrame == range {
                let int32 = arrInside.updateTime
                //let time = Date(timeIntervalSince1970: TimeInterval(int32))
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "HH:MM"
                dateFormat.string(from: int32)
                timeString = dateFormat.string(from: int32)
            }
            
        }
        return timeString
    }
    
    func processingColorRating(arr: [AllDataModel]?, name: String, range: String) -> [UIColor] {
        var timeString = [UIColor]()
        
        for i in 0..<arr!.count {
            let arrInside = arr![i]
            if arrInside.title == name && arrInside.timeFrame == range {
                let ratingInt = arrInside.rating
                switch ratingInt {
                case -3:
                    timeString = [.customRatingRed(), .customRatingRed(), .customRatingRed()]
                case -2:
                    timeString = [.customRatingRed(), .customRatingRed(), .customRatingWait()]
                case -1:
                    timeString = [.customRatingRed(), .customRatingWait(), .customRatingWait()]
                case 0:
                    timeString = [.customRatingWait(), .customRatingWait(), .customRatingWait()]
                case 1:
                    timeString = [.customRatingGreen(), .customRatingWait(), .customRatingWait()]
                case 2:
                    timeString = [.customRatingGreen(), .customRatingGreen(), .customRatingWait()]
                case 3:
                    timeString = [.customRatingGreen(), .customRatingGreen(), .customRatingGreen()]
                default:
                    print("error rating color")
                }
            }
        }
        return timeString
    }
    
    
    
    func localPush() {
        
        let saveFavorite = UserDefault.decodableData(key: UserSettings.favoriteTool)
        let saveRecommend = UserDefaults.standard.array(forKey: UserSettings.settingsRecommend)
        var updateSaveFavorite = [AllDataModel]()
        
        if !saveFavorite.isEmpty {
            for i in 0..<saveFavorite.count {
                var arr = saveFavorite[i]
                let saveToolName = arr.title
                let saveToolRecommend = arr.signalType
                
                switch saveToolRecommend {
                case 1:
                    for n in 0..<self.CopyAllDataCurrency!.count {
                        let itemCurrency = self.CopyAllDataCurrency![n]
                        if saveToolName == itemCurrency.title && arr.timeFrame == itemCurrency.timeFrame {
                            
                            arr = itemCurrency
                            updateSaveFavorite.append(arr)
                           
                        }
                    }
                case 2:
                    for n in 0..<self.CopyAllDataCrypto!.count {
                        let itemCurrency = self.CopyAllDataCrypto![n]
                        if saveToolName == itemCurrency.title  {
                            
                            arr = itemCurrency
                            updateSaveFavorite.append(arr)
                        }
                    }
                case 3:
                    for n in 0..<self.CopyAllDataMetal!.count {
                        let itemCurrency = self.CopyAllDataMetal![n]
                        if saveToolName == itemCurrency.title {
                            
                            arr = itemCurrency
                            updateSaveFavorite.append(arr)
                        }
                    }
                case 4:
                    for n in 0..<self.CopyAllDataStock!.count {
                        let itemCurrency = self.CopyAllDataStock![n]
                        if saveToolName == itemCurrency.title  {
                            arr = itemCurrency
                            updateSaveFavorite.append(arr)
                            
                        }
                    }
                default:
                    for n in 0..<self.CopyAllDataIndex!.count {
                        let itemCurrency = self.CopyAllDataIndex![n]
                        if saveToolName == itemCurrency.title  {
                            arr = itemCurrency
                            updateSaveFavorite.append(arr)
                        }
                    }
                }
            }
        }
        UserDefault.encodableData(data: updateSaveFavorite, key: UserSettings.favoriteTool)
        //UserDefaults.standard.set(updateSaveFavorite, forKey: UserSettings.favoriteTool)
        //self.router.updateFavoriteVC()
        
        self.router.delegateFavoriteTool(tools: UserDefault.decodableData(key: UserSettings.favoriteTool), timeZone: self.router.favoriteTimeZone)
        
        //let _ = self.router.assemblyBuilder?.createFavoriteViewController(tools: UserDefault.decodableData(key: UserSettings.favoriteTool), router: self.router, timeZone: self.router.favoriteTimeZone)
        
       
        for i in 0..<updateSaveFavorite.count {
            let arr = updateSaveFavorite[i]
            let recommend = self.getStatusRecommend(number: Int64(arr.rating))
            
            for n in 0..<saveRecommend!.count {
                let saveArr = saveRecommend![n] as! String
                if recommend == saveArr && arr.timeFrame == self.router.favoriteTimeZone{
                    PushNotification.dispatchNotification(nameTool: arr.title, recommend: saveArr, timeZone: arr.timeFrame, timeInterval: 10, identifier: arr.title)
                    self.identifierPush = arr.title
                }
            }
        }
    }
    
    
    func turnOffLocalPush() {
        PushNotification.turnOffNotifications(identifier: self.identifierPush)
    }
    
    func timerUpdate(time: TimeInterval) {
        //let saveNumber = UserDefaults.standard.string(forKey: UserSettings.settingsUpdate)!
        let saveNumber = TimeInterval(UserDefaults.standard.integer(forKey: UserSettings.updateNumber))
//        var number: TimeInterval = 0.0
//        let locale = LocaleLayout.getLocale()
//        if locale == "SW" {
//            number = TimeInterval(saveNumber.components(separatedBy: " ")[1])!
//        } else {
//            number = TimeInterval(saveNumber.components(separatedBy: " ")[0])!
//        }
        
        Timer.scheduledTimer(withTimeInterval: saveNumber * 60, repeats: true) { timer in
            timer.invalidate()
            self.getComment()
            self.updateChildAfterSetting()
            
            //PushNotification.dispatchNotification()
            
            
            print("timer repeat \(time) minutes")
           
        }
    }
    
    func getStatusRecommend(number: Int64) -> String {
        var timeString = ""
        switch number {
        case -3:
            timeString = "Активно продавать".localized()
        case -2:
            timeString = "Продавать".localized()
        case -1:
            timeString = "Осторожно продавать".localized()
        case 0:
            timeString = "Подождать".localized()
        case 1:
            timeString = "Осторожно покупать".localized()
        case 2:
            timeString = "Покупать".localized()
        case 3:
            timeString = "Активно покупать".localized()
        default:
            print("error rating color")
        }
        
        return timeString
    }
    
    
    
    func distributionAllData(all: [AllDataModel]?) {
        var arrCurrency = [AllDataModel]()
        var arrCrypto = [AllDataModel]()
        var arrMetal = [AllDataModel]()
        var arrStocks = [AllDataModel]()
        var arrIndex = [AllDataModel]()
        
        for i in 0..<all!.count {
            switch all![i].signalType {
            case 1:
                arrCurrency.append(all![i])
            case 2:
                arrCrypto.append(all![i])
            case 3:
                arrMetal.append(all![i])
            case 4:
                arrStocks.append(all![i])
            case 5:
                arrIndex.append(all![i])
            default:
                print("error distibution")
            }
        }
        
        self.CopyAllDataCurrency = arrCurrency
        self.CopyAllDataCrypto = arrCrypto
        self.CopyAllDataMetal = arrMetal
        self.CopyAllDataStock = arrStocks
        self.CopyAllDataIndex = arrIndex
        
        if UserDefault.decodableData(key: UserSettings.checkInCurrency).isEmpty {
        //if CheckTools.checkInCurrency.isEmpty {
            self.allDataCurrency = self.CopyAllDataCurrency
            
        } else {
            self.allDataCurrency = UserDefault.decodableData(key: UserSettings.checkInCurrency)
            
        }
        
        if UserDefault.decodableData(key: UserSettings.checkInCrypto).isEmpty {
        //if CheckTools.checkInCrypto.isEmpty {
            self.allDataCrypto = self.CopyAllDataCrypto
        } else {
            self.allDataCrypto = UserDefault.decodableData(key: UserSettings.checkInCrypto)
        }
        
        if UserDefault.decodableData(key: UserSettings.checkInMetal).isEmpty {
        //if CheckTools.checkInMetal.isEmpty {
            self.allDataMetal = self.CopyAllDataMetal
        } else {
            self.allDataMetal = UserDefault.decodableData(key: UserSettings.checkInMetal)
        }
        
        if UserDefault.decodableData(key: UserSettings.checkInStock).isEmpty {
        //if CheckTools.checkInStock.isEmpty {
            self.allDataStock = self.CopyAllDataStock
        } else {
            self.allDataStock = UserDefault.decodableData(key: UserSettings.checkInStock)
        }
        
        if UserDefault.decodableData(key: UserSettings.checkInIndex).isEmpty {
        //if CheckTools.checkInIndex.isEmpty {
            self.allDataIndex = self.CopyAllDataIndex
        } else {
            self.allDataIndex = UserDefault.decodableData(key: UserSettings.checkInIndex)
        }
        
        
        
        //        self.allDataCrypto = arrCrypto
        //        self.allDataMetal = arrMetal
        //        self.allDataStock = arrStocks
        //        self.allDataIndex = arrIndex
        
        self.allDataCurrency = filterRecomend(arr: self.allDataCurrency)
        self.allDataCrypto = filterRecomend(arr: self.allDataCrypto)
        self.allDataMetal = filterRecomend(arr: self.allDataMetal)
        self.allDataStock = filterRecomend(arr: self.allDataStock)
        self.allDataIndex = filterRecomend(arr: self.allDataIndex)
        
        DispatchQueue.main.async {
            let view = self.router?.showFirstChildVC(customBar: self.customBar)
            self.view?.setChildVC(child: view!)
        }
    }
    
    func filterRecomend(arr: [AllDataModel]?) -> [AllDataModel] {
        let copy = arr
        var recom = [String]()
        var numberArr = [Int]()
        var new = [AllDataModel]()
        
        if UserDefaults.standard.array(forKey: UserSettings.recommend)!.isEmpty {
        //if Recommend.checkRecommend.isEmpty {
            recom = Recommend.allRecommend
            Recommend.translatetoNumber(arr: recom)
        } else {
            recom = UserDefaults.standard.array(forKey: UserSettings.recommend)! as! [String]
            Recommend.translatetoNumber(arr: recom)
        }
        
        numberArr = Recommend.numberRecomed
        
        for i in 0..<copy!.count {
            let item = copy![i]
            
            for n in 0..<numberArr.count {
                if item.rating == numberArr[n] {
                    new.append(item)
                }
            }
            
        }
        
        return new
    }
    
    func getToolCount(arr: [AllDataModel]) -> [AllDataModel] {
        
        var new = [AllDataModel]()
        for i in 0..<arr.count {
            let name = arr[i]
            if name.timeFrame == self.textCustomBarRangeButton {
                new.append(name)
            }
            
        }
        return new
    }
    
    func tapPopOVerButton(text: String) {
        print(ModuleButton.checkButton.titleLabel!.text!)
        let view = router?.showChildVC(customBar: self.customBar, text: ModuleButton.checkButton.titleLabel!.text!)
        self.textCustomBarRangeButton = text
        self.view?.setChildVC(child: view!)
    }
    
    func updateChildAfterSetting() {
        print(ModuleButton.checkButton.titleLabel!.text!)
        let view = router?.showChildVC(customBar: self.customBar, text: ModuleButton.checkButton.titleLabel!.text!)
        self.view?.setChildVC(child: view!)
    }
    
    
    func tapCollectionButton(sender: UIButton) {
        ModuleButton.checkButton = UIButton()
        for i in 0..<ModuleButton.buttonArr.count {
            ModuleButton.buttonArr[i].backgroundColor = .white
            ModuleButton.buttonArr[i].setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        ModuleButton.checkButton = sender
        
        let view = router?.showChildVC(customBar: self.customBar, text: ModuleButton.checkButton.titleLabel!.text!)
        self.view?.setChildVC(child: view!)
        router.setHintsBool()
    }
    
    
    func getNamesForCollection(tool: String) -> [String] {
        switch tool.localized() {
        case "Криптовалюты".localized():
            return getAllNames(tools: CopyAllDataCrypto)
        case "Металлы и нефть".localized():
            return getAllNames(tools: CopyAllDataMetal)
        case "Акции".localized():
            return getAllNames(tools: CopyAllDataStock)
        case "Биржевые индексы".localized():
            return getAllNames(tools: CopyAllDataIndex)
        default:
            return getAllNames(tools: CopyAllDataCurrency)
        }
    }
    
    func getTypeTool(text: String) -> Int {
        switch text.localized() {
        case "Валюты".localized():
            return 0
        case "Криптовалюты".localized():
            return 1
        case "Металлы и нефть".localized():
            return 2
        case "Акции".localized():
            return 3
        case "Биржевые индексы".localized():
            return 4
        default:
            return 0
        }
    }
    
    func searchTool(text: String, typeTool: String) {
        var finder = [AllDataModel]()
        var new = [AllDataModel]()
        var textChar = Array(text)
        switch typeTool.localized() {
            
        case "Валюты".localized():
            var copy = [AllDataModel]()
            
            if CheckTools.checkInCurrency.isEmpty {
                copy = CopyAllDataCurrency!
            } else {
                for i in 0..<CopyAllDataCurrency!.count {
                    let copyAll = CopyAllDataCurrency![i]
                    
                    for n in 0..<CheckTools.checkInCurrency.count {
                        let check = CheckTools.checkInCurrency[n]
                        
                        if copyAll.title == check.title {
                            copy.append(copyAll)
                        }
                    }
                }
            }
            
            for i in 0..<copy.count {
                let tool = copy[i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]
                
                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy[i])
                } else {
                    self.view?.showSearchEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.allDataCurrency = finder
            } else {
                self.allDataCurrency = self.CopyAllDataCurrency
                for i in 0..<self.allDataCurrency!.count {
                    let tool = self.allDataCurrency![i]
                    for n in 0..<CheckTools.checkInCurrency.count {
                        let check = CheckTools.checkInCurrency[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.allDataCurrency = self.CopyAllDataCurrency
            }
            tapCollectionButton(sender: ModuleButton.checkButton)
        case "Криптовалюты".localized():
            var copy = [AllDataModel]()
            
            if CheckTools.checkInCrypto.isEmpty {
                copy = CopyAllDataCrypto!
            } else {
                for i in 0..<CopyAllDataCrypto!.count {
                    let copyAll = CopyAllDataCrypto![i]
                    
                    for n in 0..<CheckTools.checkInCrypto.count {
                        let check = CheckTools.checkInCrypto[n]
                        
                        if copyAll.title == check.title {
                            copy.append(copyAll)
                        }
                    }
                }
            }
            
            for i in 0..<copy.count {
                let tool = copy[i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]
                
                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy[i])
                } else {
                    self.view?.showSearchEmptyView(count: finder.count, text: text)
                }
                
            }
            
            if !finder.isEmpty {
                self.allDataCrypto = finder
            } else {
                self.allDataCrypto = self.CopyAllDataCrypto
                for i in 0..<self.allDataCrypto!.count {
                    let tool = self.allDataCrypto![i]
                    for n in 0..<CheckTools.checkInCrypto.count {
                        let check = CheckTools.checkInCrypto[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            tapCollectionButton(sender: ModuleButton.checkButton)
        case "Металлы и нефть".localized():
            var copy = [AllDataModel]()
            
            if CheckTools.checkInMetal.isEmpty {
                copy = CopyAllDataMetal!
            } else {
                for i in 0..<CopyAllDataMetal!.count {
                    let copyAll = CopyAllDataMetal![i]
                    
                    for n in 0..<CheckTools.checkInMetal.count {
                        let check = CheckTools.checkInMetal[n]
                        
                        if copyAll.title == check.title {
                            copy.append(copyAll)
                        }
                    }
                }
            }
            
            for i in 0..<copy.count {
                let tool = copy[i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]
                
                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy[i])
                } else {
                    self.view?.showSearchEmptyView(count: finder.count, text: text)
                }
                
            }
            
            if !finder.isEmpty {
                self.allDataMetal = finder
            } else {
                self.allDataMetal = self.CopyAllDataMetal
                for i in 0..<self.allDataMetal!.count {
                    let tool = self.allDataMetal![i]
                    for n in 0..<CheckTools.checkInMetal.count {
                        let check = CheckTools.checkInMetal[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            tapCollectionButton(sender: ModuleButton.checkButton)
        case "Акции".localized():
            var copy = [AllDataModel]()
            
            if CheckTools.checkInStock.isEmpty {
                copy = CopyAllDataStock!
            } else {
                for i in 0..<CopyAllDataStock!.count {
                    let copyAll = CopyAllDataStock![i]
                    
                    for n in 0..<CheckTools.checkInStock.count {
                        let check = CheckTools.checkInStock[n]
                        
                        if copyAll.title == check.title {
                            copy.append(copyAll)
                        }
                    }
                }
            }
            
            for i in 0..<copy.count {
                let tool = copy[i]
                let str = tool.title
                let first = GetCurrencyName().deleteSymbol(text: tool.title)
                
                if first.contains(text) {
                    finder.append(copy[i])
                } else {
                    self.view?.showSearchEmptyView(count: finder.count, text: text)
                }
                
            }
            
            if !finder.isEmpty {
                self.allDataStock = finder
            } else {
                self.allDataStock = self.CopyAllDataStock
                for i in 0..<self.allDataStock!.count {
                    let tool = self.allDataStock![i]
                    for n in 0..<CheckTools.checkInStock.count {
                        let check = CheckTools.checkInStock[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            tapCollectionButton(sender: ModuleButton.checkButton)
        default:
            var copy = [AllDataModel]()
            
            if CheckTools.checkInIndex.isEmpty {
                copy = CopyAllDataIndex!
            } else {
                for i in 0..<CopyAllDataIndex!.count {
                    let copyAll = CopyAllDataIndex![i]
                    
                    for n in 0..<CheckTools.checkInIndex.count {
                        let check = CheckTools.checkInIndex[n]
                        
                        if copyAll.title == check.title {
                            copy.append(copyAll)
                        }
                    }
                }
            }
            
            for i in 0..<copy.count {
                let tool = copy[i]
                let str = tool.title
                if tool.title == text {
                    finder.append(tool)
                }
                
                if str.contains(text) {
                    finder.append(copy[i])
                } else {
                    self.view?.showSearchEmptyView(count: finder.count, text: text)
                }
                
            }
            
            if !finder.isEmpty {
                self.allDataIndex = finder
            } else {
                self.allDataIndex = self.CopyAllDataIndex
                for i in 0..<self.allDataIndex!.count {
                    let tool = self.allDataIndex![i]
                    for n in 0..<CheckTools.checkInIndex.count {
                        let check = CheckTools.checkInIndex[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            tapCollectionButton(sender: ModuleButton.checkButton)
        }
        
    }
    
    func cancelSearch() {
        switch ModuleButton.checkButton.titleLabel?.text!.localized() {
        case "Валюты".localized():
            var new = [AllDataModel]()
            if CheckTools.checkInCurrency.isEmpty {
                self.allDataCurrency = self.CopyAllDataCurrency
            } else {
                self.allDataCurrency = self.CopyAllDataCurrency
                for i in 0..<self.allDataCurrency!.count {
                    let tool = self.allDataCurrency![i]
                    for n in 0..<CheckTools.checkInCurrency.count {
                        let check = CheckTools.checkInCurrency[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
                self.allDataCurrency = new
            }
        case "Криптовалюты".localized():
            var new = [AllDataModel]()
            if CheckTools.checkInCrypto.isEmpty {
                self.allDataCrypto = self.CopyAllDataCrypto
            } else {
                self.allDataCrypto = self.CopyAllDataCrypto
                for i in 0..<self.allDataCrypto!.count {
                    let tool = self.allDataCrypto![i]
                    for n in 0..<CheckTools.checkInCrypto.count {
                        let check = CheckTools.checkInCrypto[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
                self.allDataCrypto = new
            }
        case "Металлы и нефть".localized():
            var new = [AllDataModel]()
            if CheckTools.checkInMetal.isEmpty {
                self.allDataMetal = self.CopyAllDataMetal
            } else {
                self.allDataMetal = self.CopyAllDataMetal
                for i in 0..<self.allDataMetal!.count {
                    let tool = self.allDataMetal![i]
                    for n in 0..<CheckTools.checkInMetal.count {
                        let check = CheckTools.checkInMetal[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
                self.allDataMetal = new
            }
        case "Акции".localized():
            var new = [AllDataModel]()
            if CheckTools.checkInStock.isEmpty {
                self.allDataStock = self.CopyAllDataStock
            } else {
                self.allDataStock = self.CopyAllDataStock
                for i in 0..<self.allDataStock!.count {
                    let tool = self.allDataStock![i]
                    for n in 0..<CheckTools.checkInStock.count {
                        let check = CheckTools.checkInStock[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
                self.allDataStock = new
            }
        default:
            var new = [AllDataModel]()
            if CheckTools.checkInIndex.isEmpty {
                self.allDataIndex = self.CopyAllDataIndex
            } else {
                self.allDataIndex = self.CopyAllDataIndex
                for i in 0..<self.allDataIndex!.count {
                    let tool = self.allDataIndex![i]
                    for n in 0..<CheckTools.checkInIndex.count {
                        let check = CheckTools.checkInIndex[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
                self.allDataIndex = new
            }
        }
        tapCollectionButton(sender: ModuleButton.checkButton)
    }
    
    
    func newStatus(dateAPI: String) -> Bool {
        var bool = true
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let hoursAPI = Int(dateAPI.components(separatedBy: ":")[0])
        let minuteAPI = Int(dateAPI.components(separatedBy: ":")[1])
        
        if hour == hoursAPI {
            let dif = minutes - minuteAPI!
            
            if dif < 5 {
                bool = false
            } else {
                bool = true
            }
        } else {
            bool = true
        }
        
        return bool
    }
    
    func returnTime(dateAPI: String) -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var hoursAPI = 0
        var minuteAPI = 0
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            hoursAPI = Int(dateAPI.components(separatedBy: ":")[0].convertedDigitsToLocale(Locale(identifier: "EN")))!
            minuteAPI = Int(dateAPI.components(separatedBy: ":")[1].convertedDigitsToLocale(Locale(identifier: "EN")))!
        } else {
            hoursAPI = Int(dateAPI.components(separatedBy: ":")[0])!
            minuteAPI = Int(dateAPI.components(separatedBy: ":")[1])!
        }
        
        var dif = minutes - minuteAPI
        if hour > hoursAPI {
            dif = dif + 60
        }
        if dif < 0 {
            dif = dif * (-1)
        }
        
        return String(dif)
    }
}



public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        // 1
        var seen = Set<Element>()
        
        
        // 2
        return self.filter { element in
            
            // 3
            let (inserted, _) = seen.insert(element)
            
            return inserted
        }
    }
}


extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale

        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }

        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}

