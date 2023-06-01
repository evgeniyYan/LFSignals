//
//  FilterPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol FilterProtocol: AnyObject {
    func success(time: TimeView, tools: ToolsView, recommend: RecommendView, childVC: UIViewController)
    func setEmptyView(count: Int, text: String)
}

protocol FilterPresenterProtocol: AnyObject {
    init(view: FilterProtocol, router: RouterProtocol)
    func createChildViews()
    func doubleClickButtonTime(sender: ButtonActive, arr: [ButtonActive])
    func doubleClickButtonType(sender: ButtonActive, arr: [ButtonActive])
    func closeVC()
    func setButtons(arr: [ButtonActive]) -> [ButtonActive]
    func changeList(arr: [ButtonActive])
    func changeTypeToolsList(sender: ButtonActive)
    func doubleClickRecoomend(sender: ButtonActive)
    func checkToolinCollection(tool: String, title: String, color: UIColor)
    var titleCollection: String! {get set}
    func setToolCollection(tool: String) -> UIColor
    func getTitleCollectio(text: String)
    func searchTool(text: String, typeTool: String)
    var presenterSignals: SignalsPresenterProtocol! {get set}
    var collectionView: UICollectionView! {get set}
    func cancelSearch()
    func getNamesForCollection(tool: String) -> [String]
    var copyAllCurrency: [AllDataModel]! {get set}
    var copyAllCrypto: [AllDataModel]! {get set}
    var copyAllMetal: [AllDataModel]! {get set}
    var copyAllStock: [AllDataModel]! {get set}
    var copyAllIndex: [AllDataModel]! {get set}
    func dropFilter()
    var indexCollection: Int! {get set}
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: FilterProtocol?
    var router: RouterProtocol!
    var timeView: TimeView!
    var toolsView: ToolsView!
    var recommendView: RecommendView!
    var customBar = CustomBar()
    var childVC: UIViewController!
    var titleCollection: String! = "Валюты"
    var presenterSignals: SignalsPresenterProtocol!
    var collectionView: UICollectionView!
    var copyAllCurrency: [AllDataModel]! = [AllDataModel]()
    var copyAllCrypto: [AllDataModel]! = [AllDataModel]()
    var copyAllMetal: [AllDataModel]! = [AllDataModel]()
    var copyAllStock: [AllDataModel]! = [AllDataModel]()
    var copyAllIndex: [AllDataModel]! = [AllDataModel]()
    var indexCollection: Int! = 0
    
    required init(view: FilterProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        createChildViews()
        self.view?.success(time: timeView, tools: toolsView, recommend: recommendView, childVC: childVC!)
        
    }
    
    func createChildViews() {
        let timeView = TimeView(presenter: self)
        timeView.arrButtons = setButtons(arr: timeView.arrButtons)
        let toolsView = ToolsView(presenter: self)
        toolsView.arrButtons = setButtonsTools(arr: toolsView.arrButtons)
        let recommendView = RecommendView(presenter: self)
        recommendView.arrButton = setRecomendButton(arr: recommendView.arrButton)
        self.recommendView = recommendView
        self.timeView = timeView
        self.toolsView = toolsView
        let viewVC = router?.showChildVC(customBar: self.customBar, text: ModuleButton.checkButton.titleLabel!.text!)
        self.childVC = viewVC
        
//        copyAllCurrency = self.presenterSignals.allDataCurrency ?? [Any]()
//        copyAllCrypto = self.presenterSignals.allDataCrypto ?? [Any]()
//        copyAllMetal = self.presenterSignals.allDataMetal ?? [Any]()
//        copyAllStock = self.presenterSignals.allDataStock ?? [Any]()
//        copyAllIndex = self.presenterSignals.allDataIndex ?? [Any]()
    }
    
    
    func doubleClickButtonTime(sender: ButtonActive, arr: [ButtonActive]) {
        
        var arrType = [String]()

        if TimeZoneRange.arrCheckIn.isEmpty {
            arrType = TimeZoneRange.arr
        } else {
            arrType = TimeZoneRange.arrCheckIn
        }

        if sender.backgroundColor == .white {
            sender.GrayTrue()
        } else {
            sender.WhiteTrue()
        }

        if sender.backgroundColor == .white {
            
            arrType.append(sender.titleLabel!.text!)

            if arrType.count > 1 {
                for i in 0..<arr.count {
                    if arr[i].isEnabled == false {
                        arr[i].isEnabled = true
                    }
                }
            }
        } else {
            print("arrType \(arrType)")
            if arrType.count == 1 {
                sender.startWhiteFalse()
            }
            if arrType.count > 1 {
                arrType = arrType.filter({$0 != sender.titleLabel!.text})
                
            }
        }

        TimeZoneRange.arrCheckIn = arrType
        
//        var arrType = [String]()
//
//        if TypeTools.checkInType.isEmpty {
//            arrType = TypeTools.typeToolsList
//        } else {
//            arrType = TypeTools.checkInType
//        }
//
//        if sender.backgroundColor == .white {
//            sender.GrayTrue()
//            let check = arrType.filter({$0 != sender.titleLabel!.text})
//            arrType = check
//            TypeTools.checkInType = check
//           // print("старые активные \(TypeTools.checkInType)")
//
//        } else {
//            sender.WhiteTrue()
//            TypeTools.checkInType.append(sender.titleLabel!.text!)
//            //print("новые активные \(TypeTools.checkInType)")
//        }
//
//        if sender.backgroundColor != .white {
//            TypeTools.checkOutType.append(sender.titleLabel!.text!)
//
//        } else {
//            TypeTools.checkOutType = TypeTools.checkOutType.filter({$0 != sender.titleLabel!.text})
//        }
        //print("out \(TypeTools.checkOutType)")

        
    }
    
    
    
    func doubleClickButtonType(sender: ButtonActive, arr: [ButtonActive]) {
        var arrType = [String]()

        if TypeTools.checkInType.isEmpty {
            arrType = TypeTools.typeToolsList
        } else {
            arrType = TypeTools.checkInType
        }

        if sender.backgroundColor == .white {
            sender.GrayTrue()
        } else {
            sender.WhiteTrue()
        }

        if sender.backgroundColor == .white {
            
            arrType.append(sender.titleLabel!.text!)

            if arrType.count > 1 {
                for i in 0..<arr.count {
                    if arr[i].isEnabled == false {
                        arr[i].isEnabled = true
                    }
                }
            }
        } else {
            if arrType.count == 1 {
                sender.startWhiteFalse()
            }
            if arrType.count > 1 {
                arrType = arrType.filter({$0 != sender.titleLabel!.text})
                
            }
        }

        TypeTools.checkInType = arrType
        
//        var arrType = [String]()
//
//        if TypeTools.checkInType.isEmpty {
//            arrType = TypeTools.typeToolsList
//        } else {
//            arrType = TypeTools.checkInType
//        }
//
//        if sender.backgroundColor == .white {
//            sender.GrayTrue()
//            let check = arrType.filter({$0 != sender.titleLabel!.text})
//            arrType = check
//            TypeTools.checkInType = check
//           // print("старые активные \(TypeTools.checkInType)")
//
//        } else {
//            sender.WhiteTrue()
//            TypeTools.checkInType.append(sender.titleLabel!.text!)
//            //print("новые активные \(TypeTools.checkInType)")
//        }
//
//        if sender.backgroundColor != .white {
//            TypeTools.checkOutType.append(sender.titleLabel!.text!)
//
//        } else {
//            TypeTools.checkOutType = TypeTools.checkOutType.filter({$0 != sender.titleLabel!.text})
//        }
        //print("out \(TypeTools.checkOutType)")
        print("TypeTools.checkInType \(TypeTools.checkInType)")
        TypeTools.checkInType = updateTypeTools()
        print("TypeTools.checkInType \(TypeTools.checkInType)")
        
    }
    
    func getNamesForCollection(tool: String) -> [String] {
        switch tool.localized() {
        case "Криптовалюты".localized():
            return self.presenterSignals.getAllNames(tools: self.copyAllCrypto)
        case "Металлы и нефть".localized():
            return self.presenterSignals.getAllNames(tools: self.copyAllMetal)
        case "Акции".localized():
            return self.presenterSignals.getAllNames(tools: self.copyAllStock)
        case "Биржевые индексы".localized():
            return self.presenterSignals.getAllNames(tools: self.copyAllIndex)
        default:
            return self.presenterSignals.getAllNames(tools: self.copyAllCurrency)
        }
    }
    
    func searchTool(text: String, typeTool: String) {
        var finder = [AllDataModel]()
        var new = [AllDataModel]()
        var textChar = Array(text)
        switch typeTool.localized() {
        case "Валюты".localized():
            let copy = self.presenterSignals.CopyAllDataCurrency
            
            for i in 0..<copy!.count {
                let tool = copy![i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]

                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy![i])
                } else {
                    self.view?.setEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.copyAllCurrency = finder
            } else {
                self.copyAllCurrency = self.presenterSignals.CopyAllDataCurrency
                for i in 0..<self.copyAllCurrency.count {
                    let tool = self.copyAllCurrency[i]
                    for n in 0..<CheckTools.checkInCurrency.count {
                        let check = CheckTools.checkInCurrency[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.copyAllCurrency = self.presenterSignals.CopyAllDataCurrency
            }
        case "Криптовалюты".localized():
            let copy = self.presenterSignals.CopyAllDataCrypto
            
            for i in 0..<copy!.count {
                let tool = copy![i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]

                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy![i])
                } else {
                    self.view?.setEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.copyAllCrypto = finder
            } else {
                self.copyAllCrypto = self.presenterSignals.CopyAllDataCrypto
                for i in 0..<self.copyAllCrypto.count {
                    let tool = self.copyAllCrypto[i]
                    for n in 0..<CheckTools.checkInCrypto.count {
                        let check = CheckTools.checkInCrypto[n]
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.copyAllCrypto = self.presenterSignals.CopyAllDataCrypto
            }
        case "Металлы и нефть".localized():
            let copy = self.presenterSignals.CopyAllDataMetal
            
            for i in 0..<copy!.count {
                let tool = copy![i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]

                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy![i])
                } else {
                    self.view?.setEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.copyAllMetal = finder
            } else {
                self.copyAllMetal = self.presenterSignals.CopyAllDataMetal
                for i in 0..<self.copyAllMetal.count {
                    let tool = self.copyAllMetal[i]
                    for n in 0..<CheckTools.checkInMetal.count {
                        let check = CheckTools.checkInMetal[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.copyAllMetal = self.presenterSignals.CopyAllDataMetal
            }
        case "Акции".localized():
            let copy = self.presenterSignals.CopyAllDataStock
            
            for i in 0..<copy!.count {
                let tool = copy![i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]

                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy![i])
                } else {
                    self.view?.setEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.copyAllStock = finder
            } else {
                self.copyAllStock = self.presenterSignals.CopyAllDataStock
                for i in 0..<self.copyAllStock.count {
                    let tool = self.copyAllStock[i]
                    for n in 0..<CheckTools.checkInStock.count {
                        let check = CheckTools.checkInStock[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.copyAllStock = self.presenterSignals.CopyAllDataStock
            }
        default:
            let copy = self.presenterSignals.CopyAllDataIndex
            
            for i in 0..<copy!.count {
                let tool = copy![i]
                let str = tool.title
                let first = GetCurrencyName().getCurrencyName(title: tool.title)[0]
                let second = GetCurrencyName().getCurrencyName(title: tool.title)[1]

                if first.contains(text) || second.contains(text) || str.contains(text) {
                    finder.append(copy![i])
                } else {
                    self.view?.setEmptyView(count: finder.count, text: text)
                }
            }
            
            if !finder.isEmpty {
                self.copyAllIndex = finder
            } else {
                self.copyAllIndex = self.presenterSignals.CopyAllDataIndex
                for i in 0..<self.copyAllIndex.count {
                    let tool = self.copyAllIndex[i]
                    for n in 0..<CheckTools.checkInIndex.count {
                        let check = CheckTools.checkInIndex[n]
                        
                        if tool.title == check.title {
                            new.append(tool)
                        }
                    }
                }
            }
            if text == "" {
                self.copyAllIndex = self.presenterSignals.CopyAllDataIndex
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func cancelSearch() {
        switch self.titleCollection.localized() {
        case "Валюты".localized():
            self.copyAllCurrency = self.presenterSignals.CopyAllDataCurrency
        case "Криптовалюты".localized():
            self.copyAllCrypto = self.presenterSignals.CopyAllDataCrypto
        case "Металлы и нефть".localized():
            self.copyAllMetal = self.presenterSignals.CopyAllDataMetal
        case "Акции".localized():
            self.copyAllStock = self.presenterSignals.CopyAllDataStock
        default:
            self.copyAllIndex = self.presenterSignals.CopyAllDataIndex
        }
        
        createChildViews()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateTypeTools() -> [String] {
        let checkIn = TypeTools.checkInType
        var cur = "", crypto = "", metal = "", stock = "", index = ""
        var mass = [String]()
       
        for i in 0..<checkIn.count {
            switch checkIn[i].localized() {
            case "Валюты".localized():
                cur = checkIn[i]
            case "Криптовалюты".localized():
                crypto = checkIn[i]
            case "Металлы и нефть".localized():
                metal = checkIn[i]
            case "Акции".localized():
                stock = checkIn[i]
            default:
                index = checkIn[i]
            }
        }
        
        mass.append(cur)
        mass.append(crypto)
        mass.append(metal)
        mass.append(stock)
        mass.append(index)
        
        if !mass.isEmpty {
            mass = mass.filter({$0 != ""})
        }
        
        return mass
    }
    
    func doubleClickRecoomend(sender: ButtonActive) {
        if sender.backgroundColor == .white {
            sender.GrayTrue()
        } else {
            sender.WhiteTrue()
        }
        
        if sender.backgroundColor == .white {
            Recommend.checkRecommend.append(sender.titleLabel!.text!)
        } else {
            Recommend.checkRecommend = Recommend.checkRecommend.filter({$0 != sender.titleLabel!.text})
        }
        Recommend.translatetoNumber(arr: Recommend.checkRecommend)
    }
    
    func setRecomendButton(arr: [ButtonActive]) -> [ButtonActive] {
        let new = arr
        
        if UserDefault.decodableData(key: UserSettings.recommend).isEmpty {
        //if Recommend.checkRecommend.isEmpty {
            for i in 0..<new.count {
                new[i].WhiteTrue()
            }
        } else {
            for i in 0..<new.count {
                new[i].GrayTrue()
            }
            let check = UserDefaults.standard.array(forKey: UserSettings.recommend)! as! [String]
            print("recommend check \(check)")
            new.forEach { str in
                
               let checkFilter = check.filter({$0 == str.titleLabel!.text})
                if !checkFilter.isEmpty && checkFilter[0] == str.titleLabel!.text {
                    str.WhiteTrue()
                }
            }
        }
        
        return new
    }
    
    func closeVC() {
        UserDefaults.standard.set(TimeZoneRange.arrCheckIn, forKey: UserSettings.timeZoneRange)
        UserDefaults.standard.set(TypeTools.checkInType, forKey: UserSettings.typeTools)
        UserDefaults.standard.set(Recommend.checkRecommend, forKey: UserSettings.recommend)
//        UserDefaults.standard.set(CheckTools.checkInCurrency, forKey: UserSettings.checkInCurrency)
//        UserDefaults.standard.set(CheckTools.checkOutCurrency, forKey: UserSettings.checkOutCurrency)
//        UserDefaults.standard.set(CheckTools.checkInCrypto, forKey: UserSettings.checkInCrypto)
//        UserDefaults.standard.set(CheckTools.checkOutCrypto, forKey: UserSettings.checkOutCrypto)
//        UserDefaults.standard.set(CheckTools.checkInMetal, forKey: UserSettings.checkInMetal)
//        UserDefaults.standard.set(CheckTools.checkOutMetal, forKey: UserSettings.checkOutMetal)
//        UserDefaults.standard.set(CheckTools.checkInStock, forKey: UserSettings.checkInStock)
//        UserDefaults.standard.set(CheckTools.checkOutStock, forKey: UserSettings.checkOutStock)
//        UserDefaults.standard.set(CheckTools.checkInIndex, forKey: UserSettings.checkInIndex)
//        UserDefaults.standard.set(CheckTools.checkOutIndex, forKey: UserSettings.checkOutIndex)
        router?.initialTabBarController()
        UserDefaults.standard.set(true, forKey: UserSettings.boolSkeleton)
    }
    
    func setButtons(arr: [ButtonActive]) -> [ButtonActive] {
        var btnWhite = [ButtonActive]()
        var btnGray = [ButtonActive]()
        if UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)!.isEmpty {
            
            for i in 0..<TimeZoneRange.arr.count {
                btnWhite = arr.filter({$0.titleLabel!.text == TimeZoneRange.arr[i]})
                for n in 0..<btnWhite.count {
                    btnWhite[n].WhiteTrue()
                }
            }
            
            for i in 0..<TimeZoneRange.arrChectOut.count {
                btnGray = arr.filter({$0.titleLabel!.text == TimeZoneRange.arrChectOut[i]})
                for n in 0..<btnWhite.count {
                    btnGray[n].GrayTrue()
                }
            }
            
            if TimeZoneRange.arr.isEmpty || TimeZoneRange.arrChectOut.isEmpty {
                for i in 0..<arr.count {
                    arr[i].WhiteTrue()
                }
            }
        } else {
            TimeZoneRange.arrCheckIn = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String]
            for i in 0..<TimeZoneRange.arr.count {
                btnWhite = arr.filter({$0.titleLabel!.text == TimeZoneRange.arr[i]})
                for n in 0..<btnWhite.count {
                    btnWhite[n].GrayTrue()
                }
            }
            
            for i in 0..<TimeZoneRange.arrCheckIn.count {
                btnGray = arr.filter({$0.titleLabel!.text == TimeZoneRange.arrCheckIn[i]})
                for n in 0..<btnWhite.count {
                    btnGray[n].WhiteTrue()
                }
            }
        }
       
        return btnWhite
    }
    
    func setButtonsTools(arr: [ButtonActive]) -> [ButtonActive] {
        let btnWhite = arr
//        UserDefaults.standard.set(TypeTools.checkInType, forKey: UserSettings.typeTools)
        if UserDefault.decodableData(key: UserSettings.typeTools).isEmpty {
            if TypeTools.checkInType.isEmpty {
                for i in 0..<arr.count {
                    btnWhite[i].WhiteTrue()
                }
            } else {
                for i in 0..<arr.count {
                    btnWhite[i].GrayTrue()
                }
                var check = [String]()
                btnWhite.forEach { str in
                    
                    check = TypeTools.checkInType.filter({$0 == str.titleLabel!.text})
                    if !check.isEmpty && check[0] == str.titleLabel!.text {
                        str.WhiteTrue()
                    }
                }
            }
        } else {
            for i in 0..<arr.count {
                btnWhite[i].GrayTrue()
            }
            let check = UserDefaults.standard.array(forKey: UserSettings.typeTools)! as! [String]
            
            btnWhite.forEach { str in
               let new = check.filter({$0 == str.titleLabel!.text})
                if !new.isEmpty && new[0] == str.titleLabel!.text {
                    str.WhiteTrue()
                }
            }
        }
        return btnWhite
    }
    
    func getTitleCollectio(text: String) {
       
        self.titleCollection = text
    }
    
    func setToolCollection(tool: String) -> UIColor {
        var color = UIColor()
        var outAll = [AllDataModel]()
        var finder = [AllDataModel]()
        
        switch titleCollection.localized() {
        case "Валюты".localized():
            if UserDefault.decodableData(key: UserSettings.checkInCurrency).isEmpty {
                outAll = CheckTools.checkInCurrency
            } else {
                outAll = UserDefault.decodableData(key: UserSettings.checkInCurrency)
            }
        case "Криптовалюты".localized():
            if UserDefault.decodableData(key: UserSettings.checkInCrypto).isEmpty {
                outAll = CheckTools.checkInCrypto
            } else {
                outAll = UserDefault.decodableData(key: UserSettings.checkInCrypto)
            }
        case "Металлы и нефть".localized():
            if UserDefault.decodableData(key: UserSettings.checkInMetal).isEmpty {
                outAll = CheckTools.checkInMetal
            } else {
                outAll = UserDefault.decodableData(key: UserSettings.checkInMetal)
            }
        case "Акции".localized():
            if UserDefault.decodableData(key: UserSettings.checkInStock).isEmpty {
                outAll = CheckTools.checkInStock
            } else {
                outAll = UserDefault.decodableData(key: UserSettings.checkInStock)
            }
        default:
            if UserDefault.decodableData(key: UserSettings.checkInIndex).isEmpty {
                outAll = CheckTools.checkInIndex
            } else {
                outAll = UserDefault.decodableData(key: UserSettings.checkInIndex)
            }
        }
        //print("outAll \(outAll.count)")
        if outAll.isEmpty {
            color = .white
            //color = .red
        } else {
            for i in 0..<outAll.count {
                let out = outAll[i]
                if out.title == tool {
                    finder.append(out)
                }
            }
            if !finder.isEmpty {
                color = .white
            } else {
                color = .clear
            }
        }
        
        
        return color
    }
    
    func changeList(arr: [ButtonActive]) {
        TimeZoneRange.arrCheckIn = [String]()
        for i in 0...arr.count - 1 {
            if arr[i].backgroundColor == .white {
                TimeZoneRange.arrCheckIn.append(arr[i].titleLabel!.text!)
            }
        }
    }
    
    func changeTypeToolsList(sender: ButtonActive) {
        for i in 0..<TypeTools.typeToolsList.count {
            if sender.titleLabel!.text == TypeTools.typeToolsList[i] {
                TypeTools.checkInType = TypeTools.typeToolsList.filter({$0 != TypeTools.typeToolsList[i]})
            }
        }
    }
    
    func checkToolinCollection(tool: String, title: String, color: UIColor) {
        self.titleCollection = title
        print(title)
        router?.changeCheckTool(tool: tool, title: title, color: color)
    }
    
    func dropFilter() {
        TimeZoneRange.arrCheckIn = [String]()
        TimeZoneRange.arrChectOut = [String]()
        let arr = [self.timeView.m1Btn, self.timeView.m5Btn, self.timeView.m15Btn, self.timeView.m30Btn, self.timeView.h1Btn, self.timeView.h4Btn, self.timeView.d1Btn]
        for i in 0..<arr.count {
            arr[i].WhiteTrue()
        }
        TypeTools.checkInType = TypeTools.typeToolsList
        for i in 0..<toolsView.arrButtons.count {
            toolsView.arrButtons[i].WhiteTrue()
        }
        
        Recommend.checkRecommend = Recommend.allRecommend
        for i in 0..<recommendView.arrButton.count {
            recommendView.arrButton[i].WhiteTrue()
        }
        
        CheckTools.checkInCurrency = [AllDataModel]()
        CheckTools.checkOutCurrency = [AllDataModel]()
        CheckTools.checkInCrypto = [AllDataModel]()
        CheckTools.checkOutCrypto = [AllDataModel]()
        CheckTools.checkInMetal = [AllDataModel]()
        CheckTools.checkOutMetal = [AllDataModel]()
        CheckTools.checkInStock = [AllDataModel]()
        CheckTools.checkOutStock = [AllDataModel]()
        CheckTools.checkInIndex = [AllDataModel]()
        CheckTools.checkOutIndex = [AllDataModel]()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
