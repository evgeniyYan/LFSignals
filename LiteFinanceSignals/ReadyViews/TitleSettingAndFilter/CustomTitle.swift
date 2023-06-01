//
//  CustomTitle.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class CustomTitle: UILabel {

    init(text: String) {
        super.init(frame: CGRect.zero)
        self.text = text
        self.font = .systemFont(ofSize: 24, weight: .semibold)
        self.textColor = .customFilterNabButtons()
        self.numberOfLines = 0
        
        if LocaleLayout.getLocale() == "my" {
            self.font = .systemFont(ofSize: 17, weight: .semibold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
