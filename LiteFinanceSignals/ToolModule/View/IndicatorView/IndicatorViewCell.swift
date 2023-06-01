//
//  IndicatorViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class IndicatorViewCell: UITableViewCell {

    static let identifier = "indicatorCell"
    
    let leftCirclesView = CirclesView()
    
    let nameIndicator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .customNameIndicator()
        label.text = "".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    let rightCirclesView = CirclesView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .customBGNav()
        addSubview(nameIndicator)
        addSubview(leftCirclesView)
        addSubview(rightCirclesView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftCirclesView.frame = CGRect(x: 15, y: contentView.center.y, width: 100, height: 20)
        nameIndicator.frame = CGRect(x: 0, y: contentView.center.y, width: self.contentView.frame.width, height: 10)
        rightCirclesView.frame = CGRect(x: self.frame.maxX - 75, y: contentView.center.y, width: 60, height: 20)
    }

}
