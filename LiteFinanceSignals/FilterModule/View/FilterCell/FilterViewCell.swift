//
//  FilterViewCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SDWebImageSVGCoder

class FilterViewCell: UITableViewCell {
    
    static let identifier = "filterCell"
    
    let cellView: UIView = {
        let view = UIView()
        //view.clipsToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .customFilterSearchBar()
        view.layer.masksToBounds = false
        view.dropShadow()
        return view
    }()
    
    let leftFlagImage: UIImageView = {
      let image = UIImageView()
        image.clipsToBounds = true
        image.frame.size = CGSize(width: 36, height: 36)
        image.layer.cornerRadius = image.frame.width / 2
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let rightFlagImage: UIImageView = {
      let image = UIImageView()
        image.clipsToBounds = true
        image.frame.size = CGSize(width: 36, height: 36)
        image.layer.cornerRadius = image.frame.width / 2
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let alongFlagImage: UIImageView = {
      let image = UIImageView()
        image.clipsToBounds = true
        image.frame.size = CGSize(width: 56, height: 56)
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        return image
    }()
    
    let title: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .customFilterNabButtons()
        label.text = "".uppercased()
        label.frame.size = CGSize(width: 100, height: 22)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(cellView)
        cellView.addSubview(leftFlagImage)
        cellView.addSubview(rightFlagImage)
        cellView.addSubview(alongFlagImage)
        cellView.addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 56)
        alongFlagImage.frame = CGRect(x: 8, y: cellView.center.y - 20, width: 40, height: 40)
        leftFlagImage.frame = CGRect(x: 8, y: cellView.center.y - 17, width: 34, height: 34)
        rightFlagImage.frame = CGRect(x: leftFlagImage.frame.maxY + 5, y: cellView.center.y - 17, width: 34, height: 34)
        
        if alongFlagImage.isHidden {
            title.frame = CGRect(x: rightFlagImage.frame.maxX + 15, y: cellView.center.y - 11, width: self.frame.width, height: 22)
        } else {
            title.frame = CGRect(x: alongFlagImage.frame.maxX + 15, y: cellView.center.y - 11, width: self.frame.width, height: 22)
        }
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            cellView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 56)
            alongFlagImage.frame = CGRect(x: self.frame.width - alongFlagImage.frame.width - 8, y: cellView.center.y - 20, width: 40, height: 40)
            leftFlagImage.frame = CGRect(x: self.frame.width - leftFlagImage.frame.width - 8, y: cellView.center.y - 17, width: 34, height: 34)
            rightFlagImage.frame = CGRect(x: leftFlagImage.frame.minX - rightFlagImage.frame.width - 5, y: cellView.center.y - 17, width: 34, height: 34)
            
            if alongFlagImage.isHidden {
                title.frame = CGRect(x: rightFlagImage.frame.minX - title.frame.width - 15, y: cellView.center.y - 11, width: self.frame.width, height: 22)
            } else {
                title.frame = CGRect(x: alongFlagImage.frame.minX - title.frame.width - 15, y: cellView.center.y - 11, width: self.frame.width, height: 22)
            }
        }
    }
    
    func configurate(text: String, type: Int) {
      
        switch type {
            // валюты
       // case "Валюты":
        case 0:
            alongFlagImage.isHidden = true
            leftFlagImage.isHidden = false
            rightFlagImage.isHidden = false
            let left = GetCurrencyName().getCurrencyName(title: text)[0]
            let urlLeft = "https://api.litemarkets.com/images/signals/day/\(left).svg"
            let right = GetCurrencyName().getCurrencyName(title: text)[1]
            let urlRight = "https://api.litemarkets.com/images/signals/day/\(right).svg"
            self.leftFlagImage.sd_setImage(with: URL(string: urlLeft))
            self.rightFlagImage.sd_setImage(with: URL(string: urlRight))
            // криптовалюты
        //case "Криптовалюты":
        case 1:
            alongFlagImage.isHidden = true
            leftFlagImage.isHidden = false
            rightFlagImage.isHidden = false
            let left = GetCurrencyName().getCurrencyName(title: text)[0]
            let urlLeft = "https://api.litemarkets.com/images/signals/day/\(left).svg"
            let right = GetCurrencyName().getCurrencyName(title: text)[1]
            let urlRight = "https://api.litemarkets.com/images/signals/day/\(right).svg"
            self.leftFlagImage.sd_setImage(with: URL(string: urlLeft))
            self.rightFlagImage.sd_setImage(with: URL(string: urlRight))
            // металлы
        //case "Металлы и нефть":
        case 2:
            alongFlagImage.isHidden = false
            leftFlagImage.isHidden = true
            rightFlagImage.isHidden = true
            let urlIcon = "https://api.litemarkets.com/images/signals/day/\(text).svg"
            self.alongFlagImage.sd_setImage(with: URL(string: urlIcon))
            // акции
        //case "Акции":
        case 3:
            alongFlagImage.isHidden = false
            leftFlagImage.isHidden = true
            rightFlagImage.isHidden = true
            let icon = GetCurrencyName().deleteSymbol(text: text)
            let urlIcon = "https://api.litemarkets.com/images/signals/day/\(icon).svg"
            self.alongFlagImage.sd_setImage(with: URL(string: urlIcon))
            // индексы
        //case "Биржевые индексы":
        case 4:
            alongFlagImage.isHidden = false
            leftFlagImage.isHidden = true
            rightFlagImage.isHidden = true
            let urlIcon = "https://api.litemarkets.com/images/signals/day/\(text).svg"
            self.alongFlagImage.sd_setImage(with: URL(string: urlIcon))
            //валюты
        default:
//            let left = GetCurrencyName().getCurrencyName(title: text)[0]
//            let urlLeft = "https://api.litemarkets.com/images/signals/day/\(left).svg"
//            let right = GetCurrencyName().getCurrencyName(title: text)[1]
//            let urlRight = "https://api.litemarkets.com/images/signals/day/\(right).svg"
//            self.leftFlagImage.sd_setImage(with: URL(string: urlLeft))
//            self.rightFlagImage.sd_setImage(with: URL(string: urlRight))
            print("erorr icon in filter collection")
        }
        
        self.title.text = text
    }

    func clickCell() {
        cellView.backgroundColor = .clear
        cellView.layer.borderColor = UIColor(red: 0.906, green: 0.91, blue: 0.925, alpha: 1).cgColor
        cellView.layer.borderWidth = 1
        cellView.layer.opacity = 0.8
        title.textColor = .customFilterNabButtons()
    }
    
    func unClickCell() {
        cellView.backgroundColor = .customFilterSearchBar()
        cellView.layer.borderWidth = 0
        cellView.layer.opacity = 1.0
        title.textColor = .black
    }
}


extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: -1, height: 10)
        layer.shadowRadius = 3

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}
