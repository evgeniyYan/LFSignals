//
//  ToolsView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class ToolsView: UIView {

    let title = CustomTitle(text: "Торговые инструменты".localized())
    
    let currencyButton = ButtonActive(text: "Валюты".localized())
    let cryptoButton = ButtonActive(text: "Криптовалюты".localized())
    let metalButton = ButtonActive(text: "Металлы и нефть".localized())
    let stockButton = ButtonActive(text: "Акции".localized())
    let indexButton = ButtonActive(text: "Биржевые индексы".localized())
    
    var presenter: FilterPresenterProtocol!
    
    var arrButtons = [ButtonActive]()
    
    init(presenter: FilterPresenterProtocol) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        arrButtons = [currencyButton, cryptoButton, metalButton, stockButton, indexButton]
        
        for i in 0..<arrButtons.count {
            //arrButtons[i].WhiteTrue()
            arrButtons[i].addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            addSubview(arrButtons[i])
        }
        
        addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton(_ sender: ButtonActive) {
        presenter.doubleClickButtonType(sender: sender, arr: arrButtons)
        //presenter.changeTypeToolsList(sender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        currencyButton.frame.origin = CGPoint(x: 0, y: title.frame.maxY + 5)
        cryptoButton.frame.origin = CGPoint(x: currencyButton.frame.maxX + 15, y: title.frame.maxY + 5)
        metalButton.frame.origin = CGPoint(x: 0, y: currencyButton.frame.maxY + 15)
        stockButton.frame.origin = CGPoint(x: metalButton.frame.maxX + 15, y: currencyButton.frame.maxY + 15)
        indexButton.frame.origin = CGPoint(x: 0, y: metalButton.frame.maxY + 15)
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
            currencyButton.frame.origin = CGPoint(x: self.frame.width - currencyButton.frame.width, y: title.frame.maxY + 5)
            cryptoButton.frame.origin = CGPoint(x: currencyButton.frame.minX - cryptoButton.frame.width - 15, y: title.frame.maxY + 5)
            metalButton.frame.origin = CGPoint(x: self.frame.width - metalButton.frame.width, y: currencyButton.frame.maxY + 15)
            stockButton.frame.origin = CGPoint(x: metalButton.frame.minX - stockButton.frame.width - 15, y: currencyButton.frame.maxY + 15)
            indexButton.frame.origin = CGPoint(x: self.frame.width - indexButton.frame.width, y: metalButton.frame.maxY + 15)
        }
    }
}
