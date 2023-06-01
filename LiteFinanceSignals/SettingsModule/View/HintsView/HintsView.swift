//
//  HintsView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol HintsViewDelegate: AnyObject {
    func setHiddenForButton(hidden: Bool)
}

class HintsView: UIView {

    let title = CustomTitle(text: "Подсказки".localized())
    var turnOnButton = ButtonActive(text: "Включить".localized())
    var turnOffButton = ButtonActive(text: "Выключить".localized())
    var presenter: SettingsPresenter!
    var arrButtons = [ButtonActive]()
    
    var delegate: HintsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(presenter: SettingsPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        arrButtons = [turnOnButton, turnOffButton]
       
        for i in 0..<arrButtons.count {
            
            //arrButtons[i].addTarget(self, action: #selector(didTap), for: .touchUpInside)
            addSubview(arrButtons[i])
        }
        
        addSubview(title)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
