//
//  DesignView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class DesignView: UIView {
    
    let title = CustomTitle(text: "Оформление".localized())
    var systemButton = ButtonActive(text: "Системное".localized())
    var lightButton = ButtonActive(text: "Светлое".localized())
    var darkButton = ButtonActive(text: "Тёмное".localized())
    
    var presenter: SettingsPresenter!
    var arrButtons = [ButtonActive]()
    
    init(presenter: SettingsPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        arrButtons = [systemButton, lightButton, darkButton]
        
        for i in 0..<arrButtons.count {
            arrButtons[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
            arrButtons[i].GrayTrue()
            addSubview(arrButtons[i])
        }
        let saveMode = UserDefaults.standard.string(forKey: UserSettings.settingsMode)!
        
        for i in 0..<arrButtons.count {
            if saveMode == arrButtons[i].titleLabel!.text {
                arrButtons[i].startWhiteFalse()
            }
        }
        
        
        addSubview(title)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            title.frame = CGRect(x: self.frame.width - self.frame.width - 30, y: 0, width: self.frame.width, height: 30)
            systemButton.frame.origin = CGPoint(x: self.frame.width - self.systemButton.frame.width - 30, y: title.frame.maxY + 20)
            lightButton.frame.origin = CGPoint(x: systemButton.frame.minX - lightButton.frame.width - 30, y: title.frame.maxY + 20)
            darkButton.frame.origin = CGPoint(x: lightButton.frame.minX - darkButton.frame.width - 30, y: title.frame.maxY + 20)
        } else {
            title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
            systemButton.frame.origin = CGPoint(x: 0, y: title.frame.maxY + 20)
            lightButton.frame.origin = CGPoint(x: systemButton.frame.maxX + 15, y: title.frame.maxY + 20)
            darkButton.frame.origin = CGPoint(x: lightButton.frame.maxX + 15, y: title.frame.maxY + 20)
        }
        
    }
    
    @objc func didTap(_ sender: ButtonActive) {
        presenter.toggleOtherModeView(sender: sender, arr: self.arrButtons)
        presenter.toggleModeApp(sender: sender)
    }
}
