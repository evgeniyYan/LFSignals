//
//  PresenterBar.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol CustomBarProtocol: AnyObject {
    var popOver: UIViewController! {get set}
    var titleRangeButton: UILabel! {get set}
    var titleNav: UILabel! {get set}
    init(view: UIViewController, title: String, filterButton: Bool, searchButton: Bool, rangeButton: Bool, router: RouterProtocol)
    func updateTitleRange(text: String)
    func onlyUpdateTitleRange(text: String)
    func allFade()
}


