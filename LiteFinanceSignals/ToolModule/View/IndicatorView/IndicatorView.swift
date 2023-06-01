//
//  IndicatorView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class IndicatorView: UIView {

    var leftCirclesView = CirclesView()
    
    let nameIndicator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "Индикаторы".localized()
        label.textAlignment = .center
        
        label.textColor = .black
        return label
    }()
    
    var rightCirclesView = CirclesView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftCirclesView)
        addSubview(rightCirclesView)
        addSubview(nameIndicator)
        
        self.backgroundColor = .customIndicatorView()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftCirclesView.frame = CGRect(x: 17, y: 18, width: 60, height: 12)
        nameIndicator.frame = CGRect(x: 0, y: 13, width: self.frame.width, height: 20)
        rightCirclesView.frame = CGRect(x: self.frame.width - self.rightCirclesView.frame.width - 17, y: 18, width: 60, height: 12)
    }
}
