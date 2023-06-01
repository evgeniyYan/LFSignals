//
//  PopOverPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation


protocol PopOverPresenterPorotocol: AnyObject {
    var customBar: CustomBarProtocol! {get set}
    init(bar: CustomBarProtocol, router: RouterProtocol)
    func setTitleRangeButton(title: String)
}


class PopOverPresenter: PopOverPresenterPorotocol {
    var customBar: CustomBarProtocol!
    var router: RouterProtocol!
    
    required init(bar: CustomBarProtocol, router: RouterProtocol) {
        self.router = router
        self.customBar = bar
    }
    
    func setTitleRangeButton(title: String) {
        if self.customBar.titleNav.text == "Сигналы".localized() {
            self.customBar.updateTitleRange(text: title)
        } else {
            self.customBar.onlyUpdateTitleRange(text: title)
        }
        
    }
}

