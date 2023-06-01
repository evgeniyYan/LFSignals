//
//  ButtonActive.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class ButtonActive: UIButton {

    var text = UILabel(frame: CGRect.zero)
    
    init(text: String) {
        super.init(frame: CGRect.zero)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 17)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.text.text = text
        self.text.sizeToFit()
        self.frame.size = CGSize(width: self.text.frame.width + 15, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startWhiteFalse() {
        self.backgroundColor = .white
        self.layer.opacity = 1.0
        self.layer.borderColor = .none
        self.layer.borderWidth = 0
        self.setTitleColor(.black, for: .normal)
        self.isEnabled = false
    }
    
    func GrayTrue() {
        self.backgroundColor = .clear
        self.layer.opacity = 0.5
        self.layer.borderColor = UIColor(red: 0.906, green: 0.91, blue: 0.925, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(.customColorText(), for: .normal)
        self.isEnabled = true
    }
    
    func WhiteTrue() {
        self.backgroundColor = .white
        self.layer.opacity = 1.0
        self.layer.borderColor = .none
        self.layer.borderWidth = 0
        self.setTitleColor(.black, for: .normal)
        self.isEnabled = true
    }
    
    func startGrayFalse() {
        self.backgroundColor = .clear
        self.layer.opacity = 0.5
        self.layer.borderColor = UIColor(red: 0.906, green: 0.91, blue: 0.925, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(.customColorText(), for: .normal)
        self.isEnabled = false
    }

}
