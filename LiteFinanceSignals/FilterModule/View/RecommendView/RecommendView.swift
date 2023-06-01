//
//  RecommendView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class RecommendView: UIView {

    let title = CustomTitle(text: "Рекомендации".localized())
    
    var activeBuyButton = ButtonActive(text: "Активно покупать".localized())
    var buyButton = ButtonActive(text: "Покупать".localized())
    var carefullyBuyButton = ButtonActive(text: "Осторожно покупать".localized())
    var waitButton = ButtonActive(text: "Подождать".localized())
    var carefullySellButton = ButtonActive(text: "Осторожно продавать".localized())
    var sellButton = ButtonActive(text: "Продавать".localized())
    var activeSellButton = ButtonActive(text: "Активно продавать".localized())
    
    var presenter: FilterPresenterProtocol!
    
    var arrButton = [ButtonActive]()
    
    init(presenter: FilterPresenterProtocol) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        arrButton = [activeBuyButton, buyButton, carefullyBuyButton, waitButton, carefullySellButton, sellButton, activeSellButton]
        
        addSubview(title)
        
        for i in 0..<arrButton.count {
            //arrButton[i].WhiteTrue()
            arrButton[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
            addSubview(arrButton[i])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        activeBuyButton.frame.origin = CGPoint(x: 0, y: title.frame.maxY + 20)
        buyButton.frame.origin = CGPoint(x: activeBuyButton.frame.maxX + 15, y: title.frame.maxY + 20)
        carefullyBuyButton.frame.origin = CGPoint(x: 0, y: activeBuyButton.frame.maxY + 20)
        waitButton.frame.origin = CGPoint(x: carefullyBuyButton.frame.maxX + 15, y: activeBuyButton.frame.maxY + 20)
        carefullySellButton.frame.origin = CGPoint(x: 0, y: carefullyBuyButton.frame.maxY + 20)
        sellButton.frame.origin = CGPoint(x: carefullySellButton.frame.maxX + 15, y: waitButton.frame.maxY + 20)
        activeSellButton.frame.origin = CGPoint(x: 0, y: sellButton.frame.maxY + 20)
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
            activeBuyButton.frame.origin = CGPoint(x: self.frame.width - activeBuyButton.frame.width, y: title.frame.maxY + 20)
            buyButton.frame.origin = CGPoint(x: activeBuyButton.frame.minX - buyButton.frame.width - 15, y: title.frame.maxY + 20)
            carefullyBuyButton.frame.origin = CGPoint(x: self.frame.width - carefullyBuyButton.frame.width, y: activeBuyButton.frame.maxY + 20)
            waitButton.frame.origin = CGPoint(x: carefullyBuyButton.frame.minX - waitButton.frame.width - 15, y: activeBuyButton.frame.maxY + 20)
            carefullySellButton.frame.origin = CGPoint(x: self.frame.width - carefullySellButton.frame.width, y: carefullyBuyButton.frame.maxY + 20)
            sellButton.frame.origin = CGPoint(x: carefullySellButton.frame.minX - sellButton.frame.width - 15, y: waitButton.frame.maxY + 20)
            activeSellButton.frame.origin = CGPoint(x: self.frame.width - activeSellButton.frame.width, y: sellButton.frame.maxY + 20)
        }
    }
    
    @objc func didTap(_ sender: ButtonActive) {
        presenter.doubleClickRecoomend(sender: sender)
    }
    
    

}
