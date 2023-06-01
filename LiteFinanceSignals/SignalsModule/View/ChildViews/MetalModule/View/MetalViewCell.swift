//
//  MetalViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SDWebImageSVGCoder

class MetalViewCell: UITableViewCell {

    static let identifier = "metalCell"
    
    var presenter = GetCurrencyName()
    var presenterCrypto: MetalPresenterProtocol!
    
    let timeLabel: UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .customColorText()
        label.text = "10:08"
        return label
    }()
    
    let lastUpdateTime: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
        //label.text = "(5 минут назад)"
        return label
    }()
    
    let newStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        label.textColor = .white
        label.frame.size = CGSize(width: 60, height: 20)
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "Новый".localized().uppercased()
        return label
    }()
    
    let viewCurrecny: UIView = {
       let view = UIView()
        view.backgroundColor = .customBGCell()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    
    var flagImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "flag_usd")
        image.backgroundColor = .systemGray
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: 34, height: 34)
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()
    
    
    let titleCurrency: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 17)
        lable.textColor = .customColorText()
        lable.text = "EURUSD"
        return lable
    }()
    
    let viewWithCurcles = CirclesView()
    
    let sellButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("продавать".uppercased().localized(), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.setTitleColor(.customColorText(), for: .normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    var titleButn = UILabel(frame: CGRect.zero)
    
    var timeText = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(timeLabel)
        addSubview(lastUpdateTime)
        addSubview(newStatusLabel)
        addSubview(viewCurrecny)
        addSubview(sellButton)
        
        titleButn.sizeToFit()
        timeText.sizeToFit()
        
        viewCurrecny.addSubview(flagImage)
        viewCurrecny.addSubview(titleCurrency)
        viewCurrecny.addSubview(viewWithCurcles)
        
    }
    
    func configure(title: String, time: String, color: [UIColor], new: Bool, difTime: String) {
       // let urlFlag = "https://api.litemarkets.com/images/signals/day/\(title).svg"
        let urlFlag = API.createIconURL(icon: title)
        
        DispatchQueue.main.async {
            self.flagImage.sd_setImage(with: URL(string: urlFlag))
        }

        self.titleCurrency.text = title
        self.timeLabel.text = time
        
        let ratingCirlces = [viewWithCurcles.circleFirst, viewWithCurcles.circleSecond, viewWithCurcles.circleThird]
        
        for i in 0..<ratingCirlces.count {
            ratingCirlces[i].backgroundColor = color[i]
        }
        
        titleButn.text = presenter.setTitleSellButton(color: color).uppercased()
        self.sellButton.setTitle(titleButn.text, for: .normal)
        self.newStatusLabel.isHidden = new
        //lastUpdateTime.text = "(\((Int(difTime)?.minutes())!) назад)".localized()
        lastUpdateTime.text = "dop time ".localized() + "(".localized() + "\(Int(difTime)!.minutes())" + " ".localized() + "назад)".localized()
        self.timeText.text = lastUpdateTime.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            timeLabel.frame = CGRect(x: self.frame.width - timeLabel.frame.width - 40, y: 0, width: 35, height: 17)
            lastUpdateTime.frame = CGRect(x: timeLabel.frame.minX - self.timeText.frame.width - 5, y: 0, width: self.timeText.frame.width - 15, height: 17)
            newStatusLabel.frame = CGRect(x: lastUpdateTime.frame.minX - 55, y: 0, width: 55, height: 17)
            viewCurrecny.frame = CGRect(x: 0, y: timeLabel.frame.maxY + 7, width: contentView.frame.width, height: 56)
            flagImage.frame = CGRect(x: self.frame.width - 44, y: 11, width: 34, height: 34)
            titleCurrency.frame = CGRect(x: flagImage.frame.minX - 100, y: 15, width: 80, height: 25)
            viewWithCurcles.frame = CGRect(x: 15, y: 22, width: 56, height: 12)
            sellButton.frame = CGRect(x: 15, y: viewCurrecny.frame.maxY + 9, width: 150, height: 14)
            sellButton.contentHorizontalAlignment = .left
        } else {
            timeLabel.frame = CGRect(x: 0, y: 0, width: 35, height: 17)
            lastUpdateTime.frame = CGRect(x: timeLabel.frame.maxX + 5, y: 0, width: self.timeText.frame.width - 15, height: 17)
            newStatusLabel.frame = CGRect(x: lastUpdateTime.frame.maxX + 3, y: 0, width: 55, height: 17)
            viewCurrecny.frame = CGRect(x: 0, y: timeLabel.frame.maxY + 7, width: contentView.frame.width, height: 56)
            flagImage.frame = CGRect(x: 10, y: 11, width: 34, height: 34)
            
            titleCurrency.frame = CGRect(x: flagImage.frame.maxX + 10, y: 15, width: 80, height: 25)
            viewWithCurcles.frame = CGRect(x: contentView.frame.width - 70, y: 22, width: 56, height: 12)
            sellButton.frame = CGRect(x: 15, y: viewCurrecny.frame.maxY + 9, width: contentView.frame.width - 30, height: 14)
        }
    }

}
