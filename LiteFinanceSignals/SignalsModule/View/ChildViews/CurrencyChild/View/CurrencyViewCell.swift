//
//  CurrencyViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SkeletonView

class CurrencyViewCell: UITableViewCell {
    
    static let identifier = "currencyCell"
    
    var presenter = GetCurrencyName()
    
   
    
    let timeLabel: UILabel = {
      let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .customColorText()
        label.text = "10:08"
        label.isSkeletonable = true
        label.skeletonCornerRadius = 7
        label.lastLineFillPercent = 100
        label.skeletonTextLineHeight = .fixed(15)
        return label
    }()
    
    let lastUpdateTime: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.lastLineFillPercent = 100
        label.skeletonTextLineHeight = .fixed(15)
        label.sizeToFit()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 4
        
        
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
        label.isSkeletonable = true
        label.skeletonCornerRadius = 4
        
        label.textAlignment = .center
        label.text = "Новый".localized().uppercased()
        return label
    }()
    
    let viewCurrecny: UIView = {
       let view = UIView()
        view.backgroundColor = .customBGCell()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let baseFlagImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "flag_rub")
        image.backgroundColor = .systemGray6
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: 34, height: 34)
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        image.isSkeletonable = true
        image.skeletonCornerRadius = Float(image.layer.bounds.width / 2)
        return image
    }()
    
    let quoteFlagImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "flag_usd")
        image.backgroundColor = .systemGray6
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: 34, height: 34)
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        image.isSkeletonable = true
        image.skeletonCornerRadius = Float(image.layer.bounds.width / 2)
        return image
    }()
    
    let titleCurrency: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 17)
        lable.textColor = .customColorText()
        lable.text = "EURUSD"
        lable.isSkeletonable = true
        lable.skeletonCornerRadius = 4
        lable.lastLineFillPercent = 100
        lable.skeletonTextLineHeight = .fixed(15)
        return lable
    }()
    
    let viewWithCurcles = CirclesView()
    
    let sellButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("".uppercased(), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.setTitleColor(.customColorText(), for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.isSkeletonable = true
        btn.skeletonCornerRadius = 4
        return btn
    }()
    
    var timeText = UILabel()
    
    var titleButn = UILabel(frame: CGRect.zero)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(lastUpdateTime)
        self.contentView.addSubview(newStatusLabel)
        self.contentView.addSubview(viewCurrecny)
        self.contentView.addSubview(sellButton)
        
        titleButn.sizeToFit()
        timeText.sizeToFit()
        
        viewWithCurcles.isSkeletonable = true
        viewWithCurcles.skeletonCornerRadius = 4
//        viewCurrecny.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        viewCurrecny.layer.shouldRasterize = true
//        viewCurrecny.layer.rasterizationScale = UIScreen.main.scale
//        viewCurrecny.layer.shadowColor = UIColor.black.cgColor
//        viewCurrecny.layer.shadowOffset = .zero
//        viewCurrecny.layer.shadowOpacity = 1
//        viewCurrecny.layer.shadowRadius = 10
//        viewCurrecny.layer.shadowPath = UIBezierPath(rect: viewCurrecny.bounds).cgPath
//        viewCurrecny.layer.shouldRasterize = true
//        viewCurrecny.layer.rasterizationScale = UIScreen.main.scale
//
        viewCurrecny.addSubview(baseFlagImage)
        viewCurrecny.addSubview(quoteFlagImage)
        viewCurrecny.addSubview(titleCurrency)
        viewCurrecny.addSubview(viewWithCurcles)
        isSkeletonable = true
        //self.dropShadow(scale: true)
       
    }
    
    func configure(title: String, time: String, color: [UIColor], new: Bool, difTime: String) {
        let firstCur = presenter.getCurrencyName(title: title)[0]
        let secondCur = presenter.getCurrencyName(title: title)[1]
        
        let urlFlagFirst = API.createIconURL(icon: firstCur)
        let urlFlagSecond = API.createIconURL(icon: secondCur)
        
        DispatchQueue.main.async {
            self.baseFlagImage.sd_setImage(with: URL(string: urlFlagFirst))
            self.quoteFlagImage.sd_setImage(with: URL(string: urlFlagSecond))
        }
        
        
        self.titleCurrency.text = title
        self.timeLabel.text = time
        
        let ratingCirlces = [viewWithCurcles.circleFirst, viewWithCurcles.circleSecond, viewWithCurcles.circleThird]
        
        for i in 0..<ratingCirlces.count {
            ratingCirlces[i].backgroundColor = color[i]
        }
        
        titleButn.text = presenter.setTitleSellButton(color: color).uppercased()
        self.sellButton.setTitle(titleButn.text, for: .normal)
        self.sellButton.titleLabel?.textAlignment = .right
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
            baseFlagImage.frame = CGRect(x: self.frame.width - 44, y: 11, width: 34, height: 34)
            quoteFlagImage.frame = CGRect(x: baseFlagImage.frame.minX - quoteFlagImage.frame.width - 7, y: 11, width: 34, height: 34)
            titleCurrency.frame = CGRect(x: quoteFlagImage.frame.minX - 100, y: 15, width: 80, height: 25)
            viewWithCurcles.frame = CGRect(x: 15, y: 22, width: 56, height: 12)
            sellButton.frame = CGRect(x: 15, y: viewCurrecny.frame.maxY + 9, width: 150, height: 14)
            sellButton.contentHorizontalAlignment = .left
        } else {
            timeLabel.frame = CGRect(x: 0, y: 0, width: 35, height: 17)
            lastUpdateTime.frame = CGRect(x: timeLabel.frame.maxX + 5, y: 0, width: self.timeText.frame.width - 15, height: 17)
            newStatusLabel.frame = CGRect(x: lastUpdateTime.frame.maxX, y: 0, width: 55, height: 17)
            viewCurrecny.frame = CGRect(x: 0, y: timeLabel.frame.maxY + 7, width: contentView.frame.width, height: 56)
            baseFlagImage.frame = CGRect(x: 10, y: 11, width: 34, height: 34)
            quoteFlagImage.frame = CGRect(x: baseFlagImage.frame.maxX + 7, y: 11, width: 34, height: 34)
            titleCurrency.frame = CGRect(x: quoteFlagImage.frame.maxX + 20, y: 15, width: 80, height: 25)
            viewWithCurcles.frame = CGRect(x: contentView.frame.width - 70, y: 22, width: 56, height: 12)
            
    //        sellButton.frame = CGRect(x: contentView.frame.width - titleButn.frame.width / 1.5 - 10 , y: viewCurrecny.frame.maxY + 9, width: titleButn.frame.width / 1.5, height: 14)
            sellButton.frame = CGRect(x: 15, y: viewCurrecny.frame.maxY + 9, width: contentView.frame.width - 30, height: 14)
        }
        
    }
}

