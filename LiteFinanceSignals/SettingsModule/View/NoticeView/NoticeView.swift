//
//  NoticeView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class NoticeView: UIView {

    let title = CustomTitle(text: "Получать уведомления с рекомендациями".localized())
    
    var activeBuyButton = ButtonActive(text: "Активно покупать".localized())
    var buyButton = ButtonActive(text: "Покупать".localized())
    var carefullyBuyButton = ButtonActive(text: "Осторожно покупать".localized())
    var waitButton = ButtonActive(text: "Подождать".localized())
    var carefullySellButton = ButtonActive(text: "Осторожно продавать".localized())
    var sellButton = ButtonActive(text: "Продавать".localized())
    var activeSellButton = ButtonActive(text: "Активно продавать".localized())
    
    var presenter: SettingsPresenter!
    
    var arrButton = [ButtonActive]()
    
    init(presenter: SettingsPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        self.backgroundColor = .clear
        arrButton = [activeBuyButton, buyButton, carefullyBuyButton, waitButton, carefullySellButton, sellButton, activeSellButton]
        
        print("save pushswitcher \(UserDefaults.standard.bool(forKey: UserSettings.pushSwitcher))")
        if UserDefaults.standard.bool(forKey: UserSettings.pushSwitcher) {
            self.alpha = 1.0
            for i in 0..<arrButton.count {
                arrButton[i].GrayTrue()
                arrButton[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
                addSubview(arrButton[i])
            }
        } else {
            self.alpha = 0.5
            for i in 0..<arrButton.count {
                arrButton[i].startGrayFalse()
                arrButton[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
                addSubview(arrButton[i])
            }
        }
        
        let saveArr = UserDefaults.standard.array(forKey: UserSettings.settingsRecommend)! as! [String]
        print("saveArr \(saveArr)")
        
        addSubview(title)
        
        for i in 0..<arrButton.count {
            let button = arrButton[i]
            
            for n in 0..<saveArr.count {
                if saveArr[n] == button.titleLabel!.text {
                    button.WhiteTrue()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            title.frame = CGRect(x: self.frame.width - self.frame.width, y: 0, width: self.frame.width, height: 60)
            activeBuyButton.frame.origin = CGPoint(x: self.frame.width - activeBuyButton.frame.width, y: title.frame.maxY + 25)
            buyButton.frame.origin = CGPoint(x: activeBuyButton.frame.minX - buyButton.frame.width - 15, y: title.frame.maxY + 25)
            carefullyBuyButton.frame.origin = CGPoint(x: self.frame.width - carefullyBuyButton.frame.width, y: activeBuyButton.frame.maxY + 20)
            waitButton.frame.origin = CGPoint(x: carefullyBuyButton.frame.minX - waitButton.frame.width, y: activeBuyButton.frame.maxY + 20)
            carefullySellButton.frame.origin = CGPoint(x: self.frame.width - carefullySellButton.frame.width, y: carefullyBuyButton.frame.maxY + 20)
            sellButton.frame.origin = CGPoint(x: carefullySellButton.frame.minX - sellButton.frame.width - 15, y: waitButton.frame.maxY + 20)
            activeSellButton.frame.origin = CGPoint(x: self.frame.width - activeSellButton.frame.width, y: sellButton.frame.maxY + 20)
        } else {
            title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
            activeBuyButton.frame.origin = CGPoint(x: 0, y: title.frame.maxY + 25)
            buyButton.frame.origin = CGPoint(x: activeBuyButton.frame.maxX + 15, y: title.frame.maxY + 25)
            carefullyBuyButton.frame.origin = CGPoint(x: 0, y: activeBuyButton.frame.maxY + 20)
            waitButton.frame.origin = CGPoint(x: carefullyBuyButton.frame.maxX + 15, y: activeBuyButton.frame.maxY + 20)
            carefullySellButton.frame.origin = CGPoint(x: 0, y: carefullyBuyButton.frame.maxY + 20)
            sellButton.frame.origin = CGPoint(x: carefullySellButton.frame.maxX + 15, y: waitButton.frame.maxY + 20)
            activeSellButton.frame.origin = CGPoint(x: 0, y: sellButton.frame.maxY + 20)
        }
    }
    
    @objc func didTap(_ sender: ButtonActive) {
        presenter.toggleNoticeView(sender: sender)
    }
    
    
    
}
