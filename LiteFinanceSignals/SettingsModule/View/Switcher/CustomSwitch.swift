//
//  CustomSwitch.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class CustomSwitch: UISwitch {

    init() {
        super.init(frame: CGRect.zero)
        self.thumbTintColor = .white
        self.isEnabled = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.onTintColor = UIColor(red: 0.471, green: 0.471, blue: 0.502, alpha: 0.7)
        self.alpha = 1.0
       
        let savePushSwitcher = UserDefaults.standard.bool(forKey: UserSettings.pushSwitcher)
        let saveUpdateSwitcher = UserDefaults.standard.bool(forKey: UserSettings.updateSwitcher)
        let saveHintsSwitcher = UserDefaults.standard.bool(forKey: UserSettings.hintsSwitcher)
        
        if savePushSwitcher == true || saveUpdateSwitcher == true || saveHintsSwitcher == true {
            self.setOn(true, animated: false)
            self.statusOff()
        } else {
            self.setOn(false, animated: false)
            self.statusOn()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func statusOff() {
        self.onTintColor = UIColor(red: 0.471, green: 0.471, blue: 0.502, alpha: 0.8)
        
    }
    
    func statusOn() {
        self.onTintColor = UIColor(red: 0.471, green: 0.471, blue: 0.502, alpha: 0.7)
    }
    
    func toggleSwitch() {
        if self.isOn {
            statusOn()
        } else {
            statusOff()
        }
    }

}
