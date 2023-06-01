//
//  CirclesView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class CirclesView: UIView {
    
    var circleFirst: UIView = {
        let view = UIView()
        view.backgroundColor = .customRatingWait()
        view.frame.size = CGSize(width: 12, height: 12)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.layer.bounds.width / 2
        return view
    }()
    
    var circleSecond: UIView = {
        let view = UIView()
        view.backgroundColor = .customRatingWait()
        view.frame.size = CGSize(width: 12, height: 12)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.layer.bounds.width / 2
        return view
    }()
    
    var circleThird: UIView = {
        let view = UIView()
        view.backgroundColor = .customRatingWait()
        view.frame.size = CGSize(width: 12, height: 12)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.layer.bounds.width / 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if traitCollection.userInterfaceStyle == .dark {
            circleFirst.backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
            circleSecond.backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
            circleThird.backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
        }
        addSubview(circleFirst)
        addSubview(circleSecond)
        addSubview(circleThird)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleFirst.frame.origin = CGPoint(x: 0, y: 0)
        circleSecond.frame.origin = CGPoint(x: circleFirst.frame.maxX + 10, y: 0)
        circleThird.frame.origin = CGPoint(x: circleSecond.frame.maxX + 10, y: 0)
    }
}
