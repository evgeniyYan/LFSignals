//
//  Model.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class TimeZoneRange {
    static var arr = ["M1", "M5", "M15", "M30", "H1", "H4", "D1"]
    static var arrChectOut = [String]()
    static var arrCheckIn = [String]()
}

class TypeTools {
    static var typeToolsList = ["Валюты".localized(), "Криптовалюты".localized(), "Металлы и нефть".localized(), "Акции".localized(), "Биржевые индексы".localized()]
    
    static var checkOutType = [String]()
    static var checkInType = [String]()
}

class Recommend {
    static var allRecommend = ["Активно покупать".localized(), "Покупать".localized(), "Осторожно покупать".localized(), "Подождать".localized(), "Осторожно продавать".localized(), "Продавать".localized(), "Активно продавать".localized()]
    static var checkRecommend = ["Активно покупать".localized(), "Покупать".localized(), "Осторожно покупать".localized(), "Подождать".localized(), "Осторожно продавать".localized(), "Продавать".localized(), "Активно продавать".localized()]
    static var numberRecomed = [Int]()
    
    static func translatetoNumber(arr: [String]) {
        Recommend.numberRecomed = [Int]()
        for i in 0..<arr.count {
            switch arr[i].localized() {
            case "Активно покупать".localized():
                Recommend.numberRecomed.append(3)
            case "Покупать".localized():
                Recommend.numberRecomed.append(2)
            case "Осторожно покупать".localized():
                Recommend.numberRecomed.append(1)
            case "Подождать".localized():
                Recommend.numberRecomed.append(0)
            case "Осторожно продавать".localized():
                Recommend.numberRecomed.append(-1)
            case "Продавать".localized():
                Recommend.numberRecomed.append(-2)
            default:
                Recommend.numberRecomed.append(-3)
            }
        }
    }
}

class SettingModel {
    static var checkRecommend = [String]()
    static var checkUpdate = ""
}

class CheckTools {
    static var allTools = [AllDataModel]()
    static var checkInCurrency = [AllDataModel]()
    static var checkOutCurrency = [AllDataModel]()
    static var checkInCrypto = [AllDataModel]()
    static var checkOutCrypto = [AllDataModel]()
    static var checkInMetal = [AllDataModel]()
    static var checkOutMetal = [AllDataModel]()
    static var checkInStock = [AllDataModel]()
    static var checkOutStock = [AllDataModel]()
    static var checkInIndex = [AllDataModel]()
    static var checkOutIndex = [AllDataModel]()
}

class FavotiteTools {
    static var favoriteArr = [AllDataModel]()
    static var pushTapTool = ""
}


class ModuleButton {
    static var buttonArr = [UIButton]()
    static var checkButton = UIButton()
}

struct Indicator: Decodable {
    var ma10: Int
    var ma20: Int
    var ma50: Int
    var ma100: Int
    var macd: Int
    var bbands: Int
    var ichimoku: Int
    var stochastic: Int
    var williams: Int
    var zigzag: Int
}

struct ToolIndicator: Decodable {
    var symbol: String
    var type: Int
    var timeframe: String
    var summary: Int
    var date: Int
    var indicators: Indicator
}


struct AllDataModelSave: Decodable, Encodable {
    //let array: [[Any]]
    var title: String
    var signalType: Int
    var timeFrame: String
    var rating: Int
    var  updateTime: Date
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: CodingKeys.title)
//        signalType = try container.decode(Int.self, forKey: CodingKeys.signalType)
//        timeFrame = try container.decode(String.self, forKey: CodingKeys.timeFrame)
//        rating = try container.decode(Int.self, forKey: CodingKeys.rating)
//        updateTime = try container.decode(Date.self, forKey: CodingKeys.updateTime)
//    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case signalType
        case timeFrame
        case rating
        case updateTime
    }
}

struct AllDataModel: Decodable, Encodable {
    var title: String
    var signalType: Int
    var timeFrame: String
    var rating: Int
    var  updateTime: Date
    
    init(title: String, signalType: Int, timeFrame: String, rating: Int, updateTime: Date) {
        self.title = title
        self.signalType = signalType
        self.timeFrame = timeFrame
        self.rating = rating
        self.updateTime = updateTime
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        title = try container.decode(String.self)
        signalType = try container.decode(Int.self)
        timeFrame = try container.decode(String.self)
        rating = try container.decode(Int.self)
        updateTime = try container.decode(Date.self)
    }
}

