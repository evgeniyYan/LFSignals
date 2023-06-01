//
//  CurrencyPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//
import UIKit


protocol CurrencyPresenterProtocol: AnyObject {
    var range: SetRangeProtocol! {get set}
    var customBar: CustomBarProtocol! {get set}
}


class CurrencyPresenter: CurrencyPresenterProtocol {
    var range: SetRangeProtocol!
    var customBar: CustomBarProtocol!
    var router: RouterProtocol!
    
    init(customBar: CustomBarProtocol!, router: RouterProtocol) {
        self.customBar = customBar
        self.router = router
    }
    
}


class GetCurrencyName {
    func getCurrencyName(title: String) -> [String] {
//        let char = title.split(separator: "")
        //let char = title.components(separatedBy: "")
        let char = Array(title)
//        var firstCurArr = [String.SubSequence]()
        var firstCurArr = [String.Element]()
//        var secirstCurArr = [String.SubSequence]()
        var secondCurArr = [String.Element]()
        
        for i in 0..<char.count {
            if i == 0 || i == 1 || i == 2 {
                firstCurArr.append(char[i])
            } else {
                secondCurArr.append(char[i])
            }
        }
        
//        let firstCur = firstCurArr.joined(separator: "")
//        let secondCur = secondCurArr.joined(separator: "")
        let firstCur = String(firstCurArr)
        let secondCur = String(secondCurArr)
        return [firstCur, secondCur]
    }
    
    func deleteSymbol(text: String) -> String {
//        let char = text.split(separator: "")
        //let char = text.components(separatedBy: "")
        let char = Array(text)
//        var firstCurArr = [String.SubSequence]()
        var firstCurArr = [String.Element]()
        
        for i in 0..<char.count {
            if i != 0 {
                firstCurArr.append(char[i])
            }
        }
        
        //let firstCur = firstCurArr.joined(separator: "")
        let firstCur = String(firstCurArr)
        return firstCur
    }
    
    func replacementSymbol(text: String) -> String {
//        let char = text.split(separator: "")
        let char = text.components(separatedBy: "")
//        var firstCurArr = [String.SubSequence]()
        var firstCurArr = [String]()
//        let symbol = "%23" as String.SubSequence
        let symbol = "%23"
        for i in 0..<char.count {
            if i == 0 {
                firstCurArr.append(symbol)
            }
            if i != 0 {
                firstCurArr.append(char[i])
            }
        }
        
        let firstCur = firstCurArr.joined(separator: "")
        return firstCur
    }
    
    func setTitleSellButton(color: [UIColor]) -> String {
        var title = ""
       
        switch color {
        case [.customRatingRed(), .customRatingRed(), .customRatingRed()]:
            title = "Активно продавать".localized()
        case [.customRatingRed(), .customRatingRed(), .customRatingWait()]:
            title = "Продавать".localized()
        case [.customRatingRed(), .customRatingWait(), .customRatingWait()]:
            title = "Осторожно продавать".localized()
        case [.customRatingWait(), .customRatingWait(), .customRatingWait()]:
            title = "Подождать".localized()
        case [.customRatingGreen(), .customRatingWait(), .customRatingWait()]:
            title = "Осторожно покупать".localized()
        case [.customRatingGreen(), .customRatingGreen(), .customRatingWait()]:
            title = "Покупать".localized()
        case [.customRatingGreen(), .customRatingGreen(), .customRatingGreen()]:
            title = "Активно покупать".localized()
        default:
            title = ""
        }
        
        return title
    }
    
    
}

