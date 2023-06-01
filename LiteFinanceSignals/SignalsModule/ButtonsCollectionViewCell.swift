//
//  ButtonsCollectionViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class ButtonsCollectionViewCell: UICollectionViewCell {
    static let identifier = "buttonsCell"
    
    var arrayBtn = [UIButton]()
    
    var button: UIButton = {
       let btn = UIButton()
        btn.setTitle("Валюты".localized(), for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13
        btn.backgroundColor = .customButtonInCollection()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.customTextButtonInCollection(), for: .normal)
        return btn
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 15, height: 15)
        view.backgroundColor = .clear
        return view
    }()
    
    let rightEmptyView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 15, height: 5)
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        contentView.addSubview(emptyView)
        contentView.addSubview(rightEmptyView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: emptyView.frame.width, y: contentView.center.y / 2, width: contentView.frame.width, height: 27)
        emptyView.frame.origin = CGPoint(x: 0, y: 0)
        rightEmptyView.frame.origin = CGPoint(x: self.frame.width - rightEmptyView.frame.width, y: 0)
        
        if button.titleLabel!.text == "Биржевые индексы".localized() {
            button.frame = CGRect(x: emptyView.frame.width, y: contentView.center.y / 2, width: contentView.frame.width - rightEmptyView.frame.width, height: 27)
        }
    }
    
    func configurate(btn: String) {
        self.button.setTitle(btn, for: .normal)
        
        
    }
}
