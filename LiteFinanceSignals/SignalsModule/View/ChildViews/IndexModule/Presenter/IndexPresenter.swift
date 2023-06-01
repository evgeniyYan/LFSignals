//
//  IndexPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation

protocol IndexPresenterProtocol: AnyObject {
    func deleteSymbol(text: String) -> String
    var customBar: CustomBarProtocol! {get set}
}


class IndexPresenter: IndexPresenterProtocol {
    var customBar: CustomBarProtocol!
    
    init(customBar: CustomBarProtocol!) {
        self.customBar = customBar
    }
    
    
    func deleteSymbol(text: String) -> String {
//        let char = text.split(separator: "")
        let char = text.components(separatedBy: "")
//        var firstCurArr = [String.SubSequence]()
        var firstCurArr = [String]()
        
        for i in 0..<char.count {
            if i != 0 {
                firstCurArr.append(char[i])
            }
        }
        
        let firstCur = firstCurArr.joined(separator: "")
        return firstCur
    }
    
    
}

