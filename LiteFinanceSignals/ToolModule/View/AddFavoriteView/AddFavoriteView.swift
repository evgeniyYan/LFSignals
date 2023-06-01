//
//  AddFavoriteView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class AddFavoriteView: UIView {

    let textLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.text = "".localized()
        return label
    }()
    
    let toolLabel: UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    let addTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "добавлено в избранное".localized()
        label.textColor = .white
        return label
    }()
    
    let deleteTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "Удалено из избранного".localized()
        label.textColor = .white
        return label
    }()
    
    
    init(tool: String) {
        super.init(frame: CGRect.zero)
        self.toolLabel.text = tool
        addSubview(textLabel)
        
        self.backgroundColor = UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.alpha = 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.frame = CGRect(x: 15, y: self.parent.view.frame.maxY - 100, width: self.parent.view.frame.width, height: 50)
        textLabel.frame = CGRect(x: 15, y:  14, width: self.frame.width - 30, height: 20)
    }
    
    func setText(text: String) {
        textLabel.text = "\(text) \(addTextLabel.text ?? "")"
    }
    func deleteText(text: String) {
        textLabel.text = deleteTextLabel.text
    }
}
