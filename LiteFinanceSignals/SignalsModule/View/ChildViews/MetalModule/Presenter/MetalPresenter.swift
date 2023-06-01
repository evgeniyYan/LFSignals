//
//  MetalPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol MetalPresenterProtocol: AnyObject {
    var iconName: String! {get set}
    var iconImage: UIImage! {get set}
    var customBar: CustomBarProtocol! {get set}
}


class MetalPresenter: MetalPresenterProtocol {
    var network = NetworkService()
    var iconName: String!
    var iconImage: UIImage!
    var customBar: CustomBarProtocol!
    
    init(customBar: CustomBarProtocol!) {
        self.customBar = customBar
    }
    
}

