//
//  ImageView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class ImageView: UIView {

    let imageFirstTool: UIImageView = {
        let image = UIImageView()
        image.frame.size = CGSize(width: 34, height: 34)
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()
    
    let imageSecondTool: UIImageView = {
        let image = UIImageView()
        image.frame.size = CGSize(width: 34, height: 34)
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()
    
    let alongTool: UIImageView = {
        let image = UIImageView()
        image.frame.size = CGSize(width: 70, height: 34)
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
       // image.layer.cornerRadius = image.layer.bounds.width / 2
        return image
    }()
    
    var arrImages = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageFirstTool)
        addSubview(imageSecondTool)
        addSubview(alongTool)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageFirstTool.frame = CGRect(x: self.center.x - 39, y: 0, width: 34, height: 34)
        imageSecondTool.frame = CGRect(x: self.center.x + 5, y: 0, width: 34, height: 34)
        alongTool.frame = CGRect(x: self.center.x - 35, y: 0, width: 70, height: 34)
    }
}
