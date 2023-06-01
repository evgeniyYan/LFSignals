//
//  CryptoChildPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol CryptoPresenterProtocol: AnyObject {
    var customBar: CustomBarProtocol! {get set}
    var iconName: String! {get set}
    var iconImage: UIImage! {get set}
}


class CryptoPresenter: CryptoPresenterProtocol {
    var network = NetworkService()
    var iconName: String!
    var iconImage: UIImage!
    var customBar: CustomBarProtocol!
    
    init(customBar: CustomBarProtocol!) {
        self.customBar = customBar
        //print(self.customBar.titleRangeButton.text!)
    }
    
   
}

