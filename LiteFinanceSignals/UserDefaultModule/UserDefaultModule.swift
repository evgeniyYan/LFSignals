//
//  UserDefaultModule.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation

class UserDefault {
    var alert = UserDefaults.standard.set(true, forKey: "alertPush")
    //закодировать (сохранить)
    static func encodableData(data: [AllDataModel], key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print(error)
        }
    }
    // раскодировать (получить)
    static func decodableData(key: String) -> [AllDataModel] {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        var ready = [AllDataModel]()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        do {
            if let decodedData = defaults.data(forKey: key) {
                let decodedArray = try decoder.decode([AllDataModelSave].self, from: decodedData)
                
                for i in 0..<decodedArray.count {
                    let decodItem = decodedArray[i]
                    ready.append(AllDataModel(title: decodItem.title, signalType: decodItem.signalType, timeFrame: decodItem.timeFrame, rating: decodItem.rating, updateTime: decodItem.updateTime))
                }
            }
        } catch {
            print(error)
        }
        return ready
    }
    
}

struct UserSettings {
    static let timeZoneRange = "timeZoneRange"
    static let typeTools = "typeTools"
    static let recommend = "recommend"
    static let allTools = "allTools"
    static let checkInCurrency = "checkInCurrency"
    static let checkOutCurrency = "checkOutCurrency"
    static let checkInCrypto = "checkInCrypto"
    static let checkOutCrypto = "checkOutCrypto"
    static let checkInMetal = "checkInMetal"
    static let checkOutMetal = "checkOutMetal"
    static let checkInStock = "checkInStock"
    static let checkOutStock = "checkOutStock"
    static let checkInIndex = "checkInIndex"
    static let checkOutIndex = "checkOutIndex"
    static let pushSwitcher = "pushSwitcher"
    static let updateSwitcher = "updateSwitcher"
    static let hintsSwitcher = "hintsSwitcher"
    static let settingsRecommend = "settingsRecommend"
    static let settingsUpdate = "settingsUpdate"
    static let settingsMode = "settingsMode"
    static let favoriteTool = "favoriteTool"
    static let timeZoneSignals = "timeZoneSignals"
    static let timeZoneFavorite = "timeZoneFavorite"
    static let boolSkeleton = "boolSkeleton"
    static let updateNumber = "updateNumber"
}

