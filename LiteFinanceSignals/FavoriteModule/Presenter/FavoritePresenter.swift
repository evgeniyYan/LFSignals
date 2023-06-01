//
//  FavoritePresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit


protocol FavoriteProtocol: AnyObject {
    func success(customBar: CustomBar)
    func updateTableView(tools: [AllDataModel], timeZone: String)
}

protocol FavoritePresenterProtocol: AnyObject {
    init(view: FavoriteProtocol, tools: [AllDataModel]?, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol)
    var tools: [AllDataModel]? {get set}
    var updateTools: [AllDataModel]? {get set}
    var customBar: CustomBarProtocol! {get set}
    func getToolCount(arr: [AllDataModel])
    var view: FavoriteProtocol? {get set}
    func taponDetailVC(tool: String?)
    var imageFlagView: ImageView! {get set}
    func getTool(type: Int, title: String) -> [UIImageView]
    func getTypeTool(arr: String) -> Int
    var router: RouterProtocol! {get set}
    func processingColorRating(arr: [AllDataModel]?, name: String, range: String) -> [UIColor]
    func processingDate(arr: [AllDataModel]?, name: String, range: String) -> String
    func newStatus(dateAPI: String) -> Bool
    func returnTime(dateAPI: String) -> String
    func openToolVCFromPush(tool: String)
    func getToolsFromParse(tools: [String]) -> [AllDataModel]
}

class FavoritePresenter: FavoritePresenterProtocol {
   
    weak var view: FavoriteProtocol?
    var router: RouterProtocol!
    var network: NetworkProtocol!
    var customBar: CustomBarProtocol!
    var presenterSignals: SignalsPresenterProtocol!
    var tools: [AllDataModel]?
    var updateTools: [AllDataModel]?
    var imageFlagView: ImageView! = ImageView()
    
    required init(view: FavoriteProtocol, tools: [AllDataModel]?, network: NetworkProtocol, router: RouterProtocol, customBar: CustomBarProtocol) {
        self.view = view
        self.tools = tools
        self.router = router
        self.network = network
        self.customBar = customBar
        getToolCount(arr: self.tools!)
        self.router.presenterFavorite = self
        self.view?.success(customBar: customBar as! CustomBar)
    }
    
    
    func getToolCount(arr: [AllDataModel]) {
        
        var new = [AllDataModel]()
        for i in 0..<arr.count {
            let name = arr[i].timeFrame
           
//            if name == self.customBar.titleRangeButton.text! {
//                new.append(arr[i])
//            }
            
            if name == self.router.favoriteTimeZone {
                new.append(arr[i])
            }
        }
        self.updateTools = new
    }
    
    func getToolsFromParse(tools: [String]) -> [AllDataModel] {
        
        var getData = [AllDataModel]()
        let allTools = router.allTools
        
        for i in 0..<allTools.count {
            let item = allTools[i]
            
            for n in 0..<tools.count {
                if item.title == tools[n] && item.timeFrame == self.router.favoriteTimeZone {
                    getData.append(item)
                }
            }
        }
        
        return getData
    }
    
    func openToolVCFromPush(tool: String) {
        let favoriteTools = UserDefault.decodableData(key: UserSettings.favoriteTool)
        var toolArr = [AllDataModel]()
        
        for i in 0..<favoriteTools.count {
            let favoriteTool = favoriteTools[i]
            let str = favoriteTool.title
            
            if str == tool {
                toolArr.append(favoriteTool)
            }
        }
        
        router.showTool(customBar: self.customBar, tool: tool, arr: toolArr)
    }
   
    
    func taponDetailVC(tool: String?) {
        let all = self.tools!
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
    
    
    func getTypeTool(arr: String) -> Int {
        var number = 0
        let saveFavorites = UserDefault.decodableData(key: UserSettings.favoriteTool)
        for i in 0..<saveFavorites.count {
            let tool = saveFavorites[i]
            
            if arr == tool.title {
                number = tool.signalType
            }
            
        }
        return number
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
    
    func processingDate(arr: [AllDataModel]?, name: String, range: String) -> String {
        var timeString = ""
        for i in 0..<arr!.count {
            let arrInside = arr![i]
            if arrInside.title == name && arrInside.timeFrame == range {
                let int32 = arrInside.updateTime
               // let time = Date(timeIntervalSince1970: TimeInterval(int32))
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "HH:MM"
                dateFormat.string(from: int32)
                timeString = dateFormat.string(from: int32)
            }
        }
        return timeString
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
        
        let hoursAPI = Int(dateAPI.components(separatedBy: ":")[0])
        let minuteAPI = Int(dateAPI.components(separatedBy: ":")[1])
        var dif = minutes - minuteAPI!
        if hour > hoursAPI! {
            dif = dif + 60
        }
        if dif < 0 {
            dif = dif * (-1)
        }
        
        return String(dif)
    }
    
    func getTool(type: Int, title: String) -> [UIImageView] {
        var images = [UIImageView]()
        let imageFirst = UIImageView()
        let imageSecond = UIImageView()
        
        switch type {
        case 1:
            let firstCur = GetCurrencyName().getCurrencyName(title: title)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: title)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur).svg"
            let urlQuote = "https://api.litemarkets.com/images/signals/day/\(secondCur).svg"
            
            imageFirst.sd_setImage(with: URL(string: urlBase))
            imageSecond.sd_setImage(with: URL(string: urlQuote))
            images.append(imageFirst)
            images.append(imageSecond)
//            DispatchQueue.main.async {
//                self.imageFlagView.imageFirstTool.sd_setImage(with: URL(string: urlBase))
//                self.imageFlagView.imageSecondTool.sd_setImage(with: URL(string: urlQuote))
//                self.imageFlagView.alongTool.isHidden = true
//            }
            
        case 2:
            let firstCur = GetCurrencyName().getCurrencyName(title: title)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: title)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur).svg"
            let urlQuote = "https://api.litemarkets.com/images/signals/day/\(secondCur).svg"
            imageFirst.sd_setImage(with: URL(string: urlBase))
            imageSecond.sd_setImage(with: URL(string: urlQuote))
            images.append(imageFirst)
            images.append(imageSecond)
//            DispatchQueue.main.async {
//                self.imageFlagView.imageFirstTool.sd_setImage(with: URL(string: urlBase))
//                self.imageFlagView.imageSecondTool.sd_setImage(with: URL(string: urlQuote))
//                    self.imageFlagView.alongTool.isHidden = true
//            }
            
        case 3:
            let firstCur = GetCurrencyName().getCurrencyName(title: title)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: title)[1]
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur)\(secondCur).svg"
            imageFirst.sd_setImage(with: URL(string: urlBase))
            images.append(imageFirst)
            
//            DispatchQueue.main.async {
//                  self.imageFlagView.alongTool.isHidden = false
//                self.imageFlagView.alongTool.sd_setImage(with: URL(string: urlBase))
//                   self.imageFlagView.imageFirstTool.isHidden = true
//                    self.imageFlagView.imageSecondTool.isHidden = true
//            }
            
        case 4:
            let icon = GetCurrencyName().deleteSymbol(text: title)
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(icon).svg"
            imageFirst.sd_setImage(with: URL(string: urlBase))
            
            images.append(imageFirst)
            
//            DispatchQueue.main.async {
//                    self.imageFlagView.alongTool.isHidden = false
//                self.imageFlagView.alongTool.sd_setImage(with: URL(string: urlBase))
//                    self.imageFlagView.imageFirstTool.isHidden = true
//                    self.imageFlagView.imageSecondTool.isHidden = true
//            }
            
        default:
            let firstCur = GetCurrencyName().getCurrencyName(title: title)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: title)[1]
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur)\(secondCur).svg"
            imageFirst.sd_setImage(with: URL(string: urlBase))
            
            images.append(imageFirst)
           
//            DispatchQueue.main.async {
                //self.imageFlagView.alongTool.isHidden = false
//                self.imageFlagView.alongTool.sd_setImage(with: URL(string: urlBase))
//                    self.imageFlagView.imageFirstTool.isHidden = true
//                    self.imageFlagView.imageSecondTool.isHidden = true
//            }
        }
        return images
    }
}

