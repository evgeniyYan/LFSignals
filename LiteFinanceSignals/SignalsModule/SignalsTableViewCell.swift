//
//  SignalsTableViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class SignalsTableViewCell: UITableViewCell {
    
    static let identifier = "signalsCell"
    
    //var mainView: UIView = CurrencyView()
    
    var label: UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var label2: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(label)
        addSubview(label2)
        //addSubview(mainView)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        //mainView.frame = contentView.bounds
        label.frame = CGRect(x: 15, y: contentView.center.y - 10, width: contentView.frame.width / 2, height: 20)
        label2.frame = CGRect(x: label.frame.maxX, y: contentView.center.y - 10, width: contentView.frame.width / 2 - 30, height: 20)
    }
}
