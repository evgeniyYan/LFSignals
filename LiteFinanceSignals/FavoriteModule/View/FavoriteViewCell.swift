//
//  FavoriteViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class FavoriteViewCell: UITableViewCell {

    static let identifier = "favoriteCell"
    
    var presenter = GetCurrencyName()
    var presenterFavorite: FavoritePresenterProtocol!
    
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
        label.text = "(5 минут назад)".localized()
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
    
    var baseFlagImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "flag_rub")
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: 34, height: 34)
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()

    var quoteFlagImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "flag_usd")
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: 34, height: 34)
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()
    
    
    
    //var imageFlagView: ImageView! = ImageView()
    
    
    
    
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
        return btn
    }()
    
    var titleButn = UILabel(frame: CGRect.zero)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(timeLabel)
        addSubview(lastUpdateTime)
        addSubview(newStatusLabel)
        addSubview(viewCurrecny)
        addSubview(sellButton)
        
        titleButn.sizeToFit()
        
        
       
        
        viewCurrecny.addSubview(baseFlagImage)
        viewCurrecny.addSubview(quoteFlagImage)
//        viewCurrecny.addSubview(imageFlagView)
        viewCurrecny.addSubview(titleCurrency)
        viewCurrecny.addSubview(viewWithCurcles)
        
       
    }
    
    func configure(title: String, time: String, color: [UIColor]) {
        DispatchQueue.main.async {
            let firstCur = self.presenter.getCurrencyName(title: title)[0]
            let secondCur = self.presenter.getCurrencyName(title: title)[1]
            
            let urlFirst = "https://api.litemarkets.com/images/signals/day/\(firstCur).svg"
            let urlSecond = "https://api.litemarkets.com/images/signals/day/\(secondCur).svg"
            
            self.baseFlagImage.sd_setImage(with: URL(string: urlFirst))
            self.quoteFlagImage.sd_setImage(with: URL(string: urlSecond))
        }
//        let firstCur = presenter.getCurrencyName(title: title)[0]
//        let secondCur = presenter.getCurrencyName(title: title)[1]
//
//        self.baseFlagImage.image = UIImage(named: "flag_\(firstCur.lowercased())")
//        self.quoteFlagImage.image = UIImage(named: "flag_\(secondCur.lowercased())")
        self.titleCurrency.text = title
        self.timeLabel.text = time
        
        let ratingCirlces = [viewWithCurcles.circleFirst, viewWithCurcles.circleSecond, viewWithCurcles.circleThird]
        
        for i in 0..<ratingCirlces.count {
            ratingCirlces[i].backgroundColor = color[i]
        }
        
        titleButn.text = presenter.setTitleSellButton(color: color).uppercased()
        self.sellButton.setTitle(titleButn.text, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.frame = CGRect(x: 0, y: 0, width: 35, height: 17)
        lastUpdateTime.frame = CGRect(x: timeLabel.frame.maxX + 5, y: 0, width: 100, height: 17)
        newStatusLabel.frame = CGRect(x: lastUpdateTime.frame.maxX + 3, y: 0, width: 55, height: 17)
        viewCurrecny.frame = CGRect(x: 0, y: timeLabel.frame.maxY + 7, width: contentView.frame.width, height: 56)
        baseFlagImage.frame = CGRect(x: 10, y: 11, width: 34, height: 34)
        quoteFlagImage.frame = CGRect(x: baseFlagImage.frame.maxX + 7, y: 11, width: 34, height: 34)
//        imageFlagView.frame = CGRect(x: 10, y: 11, width: 85, height: 34)
        titleCurrency.frame = CGRect(x: quoteFlagImage.frame.maxX + 20, y: 15, width: 80, height: 25)
        viewWithCurcles.frame = CGRect(x: contentView.frame.width - 70, y: 22, width: 56, height: 12)
        
        sellButton.frame = CGRect(x: contentView.frame.width - titleButn.frame.width / 1.5 - 10 , y: viewCurrecny.frame.maxY + 9, width: titleButn.frame.width / 1.5, height: 14)
    }

}
