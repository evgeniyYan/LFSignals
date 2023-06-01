//
//  ErrorView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class ErrorView: UIView {

    var presenter: SignalsPresenterProtocol!
    
    let errorLabel: UILabel = {
      let label = UILabel()
        label.text = "Ошибка загрузки. Проверьте подключение к сети.".localized()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let errorButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Обновить".localized(), for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        btn.clipsToBounds = false
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    init(presenter: SignalsPresenterProtocol) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        addSubview(errorLabel)
        addSubview(errorButton)
        
        errorButton.addTarget(self, action: #selector(updateParse), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        errorLabel.frame = CGRect(x: self.center.x - (errorLabel.frame.width / 2), y: self.frame.height / 3, width: self.frame.width / 1.5, height: 80)
        errorButton.frame = CGRect(x: self.center.x - ((errorButton.titleLabel?.frame.width)! + 80) / 2, y: errorLabel.frame.maxY + 30, width: (errorButton.titleLabel?.frame.width)! + 80, height: 50)
    }
    
    @objc func updateParse() {
        presenter.getComment()
    }

}
