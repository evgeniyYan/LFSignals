//
//  UpdateView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class UpdateView: UIView {
    var oneMinuteButton = ButtonActive(text: "1 минута".localized())
    var fiveMinuteButton = ButtonActive(text: "5 минут".localized())
    var fifteenMinuteButton = ButtonActive(text: "15 минут".localized())
    
    var presenter: SettingsPresenter!
    
    var arrButton = [ButtonActive]()
    
    init(presenter: SettingsPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        self.backgroundColor = .clear
        self.alpha = 0.5
        
        
        arrButton = [oneMinuteButton, fiveMinuteButton, fifteenMinuteButton]
        
        for i in 0..<arrButton.count {
            if arrButton[i].titleLabel!.text == UserDefaults.standard.string(forKey: UserSettings.settingsUpdate) {
                arrButton[i].startWhiteFalse()
            } else {
                arrButton[i].startGrayFalse()
            }
            
            arrButton[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
            addSubview(arrButton[i])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            oneMinuteButton.frame.origin = CGPoint(x: self.frame.width - oneMinuteButton.frame.width - 30, y: 0)
            fiveMinuteButton.frame.origin = CGPoint(x: oneMinuteButton.frame.minX - fiveMinuteButton.frame.width - 15, y: 0)
            fifteenMinuteButton.frame.origin = CGPoint(x: fiveMinuteButton.frame.minX - fifteenMinuteButton.frame.width - 15, y: 0)
        } else {
            oneMinuteButton.frame.origin = CGPoint(x: 0, y: 0)
            fiveMinuteButton.frame.origin = CGPoint(x: oneMinuteButton.frame.maxX + 15, y: 0)
            fifteenMinuteButton.frame.origin = CGPoint(x: fiveMinuteButton.frame.maxX + 15, y: 0)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap(_ sender: ButtonActive) {
        presenter.toggleOtherUpdateView(sender: sender, arr: self.arrButton)
        presenter.delegateTimerRepeat(text: sender.titleLabel!.text!)
    }
    
}
