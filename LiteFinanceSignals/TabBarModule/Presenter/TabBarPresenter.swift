//
//  TabBarPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol TabBarProtocol: AnyObject {
    func success(views: [UIViewController])
    var views: [UIViewController] {get set}
}

protocol TabBarPresenterProtocol: AnyObject {
    init(view: TabBarProtocol, viewsTab: [UIViewController], router: RouterProtocol, selectedTab: Int)
    func getViews()
    var views: TabBarProtocol? {get set}
    var selectedTab: Int {get set}
    var router: RouterProtocol? {get set}
}


class TabBarPresenter: TabBarPresenterProtocol {
    
    weak var view: TabBarProtocol?
    var viewsTab: [UIViewController]!
    var router: RouterProtocol?
    var views: TabBarProtocol?
    var selectedTab: Int
    
    required init(view: TabBarProtocol, viewsTab: [UIViewController], router: RouterProtocol, selectedTab: Int) {
        self.viewsTab = viewsTab
        self.router = router
        self.view = view
        self.selectedTab = selectedTab
        getViews()
    }
    
    func getViews() {
        self.view?.success(views: self.viewsTab)
    }
}

