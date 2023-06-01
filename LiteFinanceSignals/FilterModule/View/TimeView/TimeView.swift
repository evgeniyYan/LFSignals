//
//  TimeView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class TimeView: UIView {
    //["M1", "M5", "M15", "M30", "H1", "H4", "D1"]
    let title = CustomTitle(text: "Таймфрейм".localized())
    
    let m1Btn = ButtonActive(text: "M1")
    let m5Btn = ButtonActive(text: "M5")
    let m15Btn = ButtonActive(text: "M15")
    let m30Btn = ButtonActive(text: "M30")
    let h1Btn = ButtonActive(text: "H1")
    let h4Btn = ButtonActive(text: "H4")
    let d1Btn = ButtonActive(text: "D1")
    
    var presenter: FilterPresenterProtocol!
    
    var arrButtons = [ButtonActive]()
    
    init(presenter: FilterPresenterProtocol) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        
        arrButtons = [m1Btn, m5Btn, m15Btn, m30Btn, h1Btn, h4Btn, d1Btn]

        for i in 0..<arrButtons.count {
            arrButtons[i].addTarget(self, action: #selector(didTapTimeBtn), for: .touchUpInside)
            addSubview(arrButtons[i])
        }
        
        
        addSubview(title)
    }
    
    
    @objc func didTapTimeBtn(_ sender: ButtonActive) {
        presenter.doubleClickButtonTime(sender: sender, arr: [m1Btn, m5Btn, m15Btn, m30Btn, h1Btn, h4Btn, d1Btn])
        presenter.changeList(arr: [m1Btn, m5Btn, m15Btn, m30Btn, h1Btn, h4Btn, d1Btn])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        m1Btn.frame.origin = CGPoint(x: 0, y: title.frame.maxY + 20)
        m5Btn.frame.origin = CGPoint(x: m1Btn.frame.maxX + 10, y: title.frame.maxY + 20)
        m15Btn.frame.origin = CGPoint(x: m5Btn.frame.maxX + 10, y: title.frame.maxY + 20)
        m30Btn.frame.origin = CGPoint(x: m15Btn.frame.maxX + 10, y: title.frame.maxY + 20)
        h1Btn.frame.origin = CGPoint(x: m30Btn.frame.maxX + 10, y: title.frame.maxY + 20)
        h4Btn.frame.origin = CGPoint(x: 0, y: m1Btn.frame.maxY + 15)
        d1Btn.frame.origin = CGPoint(x: h4Btn.frame.maxX + 10, y: m5Btn.frame.maxY + 15)
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            m1Btn.frame.origin = CGPoint(x: self.frame.width - m1Btn.frame.width, y: title.frame.maxY + 20)
            m5Btn.frame.origin = CGPoint(x: m1Btn.frame.minX - m5Btn.frame.width - 10, y: title.frame.maxY + 20)
            m15Btn.frame.origin = CGPoint(x: m5Btn.frame.minX - m15Btn.frame.width - 10, y: title.frame.maxY + 20)
            m30Btn.frame.origin = CGPoint(x: m15Btn.frame.minX - m30Btn.frame.width - 10, y: title.frame.maxY + 20)
            h1Btn.frame.origin = CGPoint(x: m30Btn.frame.minX - h1Btn.frame.width - 10, y: title.frame.maxY + 20)
            h4Btn.frame.origin = CGPoint(x: self.frame.width - h4Btn.frame.width, y: m1Btn.frame.maxY + 15)
            d1Btn.frame.origin = CGPoint(x: h4Btn.frame.minX - d1Btn.frame.width - 10, y: m5Btn.frame.maxY + 15)
        }
    }
}
