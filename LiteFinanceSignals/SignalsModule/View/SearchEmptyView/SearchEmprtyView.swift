//
//  SearchEmprtyView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

//MARK: - заглушка когда ничего не найдено по поиску
class SearchEmprtyView: UIView {

    let labelEmpty: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        //label.frame.size = CGSize(width: 100, height: 80)
                return label
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addSubview(labelEmpty)
        self.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func installEmpty(hidden: Bool, text: String) {
        self.labelEmpty.isHidden = hidden
        //self.labelEmpty.text = "По запросу ".localized() + " \"\(text)\" " + " ничего не найдено".localized()
        self.labelEmpty.text = "По запросу ничего не найдено".localized()
    }
    
    func addOverlayView(overlayView: UIView, text: String, hidden: Bool, view: UIViewController, search: UISearchBar) {
        //self.labelEmpty.text = "По запросу ".localized() + " \"\(text)\" " + " ничего не найдено".localized()
        self.labelEmpty.text = "По запросу ничего не найдено".localized()
        
        overlayView.frame = view.view.bounds
        let targetMaskLayer = CAShapeLayer()
        let sizeCancelBtn = search.layer.frame.width - search.searchTextField.frame.width
        let squareSideWidth = search.frame.width - sizeCancelBtn
        
        let squareSideHeight = search.frame.height - 17
        let squareSize = CGSize(width: squareSideWidth, height: squareSideHeight)
        let path = UIBezierPath(rect: view.view.bounds)
        let squareOrigin = CGPoint(x: 8,
                                   y: CGFloat(search.frame.minY + 2))
        let square = UIBezierPath(roundedRect: CGRect(origin: squareOrigin, size: squareSize), cornerRadius: 8)
        path.append(square)
        
        
        targetMaskLayer.path = path.cgPath
        // Exclude intersected paths
        targetMaskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = targetMaskLayer
        overlayView.clipsToBounds = true
        //overlayView.alpha = 0.6
        //overlayView.backgroundColor = UIColor.red
        overlayView.isUserInteractionEnabled = false
        overlayView.isHidden = hidden
        
        
        if hidden {
            whiteoutScreen(view: overlayView)
            
        } else {
            blackoutScreen(view: overlayView)
            labelEmpty.frame = CGRect(x: 15, y: search.frame.midY + 8, width: view.view.frame.width - 30, height: 60)
            
        }
        
    }
    func addOverlayViewFilter(overlayView: UIView, text: String, hidden: Bool, view: UICollectionView, search: UISearchBar) {
        self.labelEmpty.text = "По запросу ".localized() + " \"\(text)\" " + " ничего не найдено".localized()
        
       // overlayView.frame = view.bounds
        let targetMaskLayer = CAShapeLayer()
        let sizeCancelBtn = search.layer.frame.width - search.searchTextField.frame.width
        let squareSideWidth = search.frame.width - sizeCancelBtn
        
        let squareSideHeight = search.frame.height - 17
        let squareSize = CGSize(width: squareSideWidth, height: squareSideHeight)
        let path = UIBezierPath(rect: view.bounds)
        let squareOrigin = CGPoint(x: 16,
                                   y: CGFloat(search.frame.minY + 7))
        let square = UIBezierPath(roundedRect: CGRect(origin: squareOrigin, size: squareSize), cornerRadius: 8)
        path.append(square)
        
        
        targetMaskLayer.path = path.cgPath
        // Exclude intersected paths
        targetMaskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = targetMaskLayer
        overlayView.clipsToBounds = true
        //overlayView.alpha = 0.6
        //overlayView.backgroundColor = UIColor.red
        overlayView.isUserInteractionEnabled = false
        overlayView.isHidden = hidden
        
        
        
        if hidden {
            whiteoutScreen(view: overlayView)
            
        } else {
            blackoutScreen(view: overlayView)
            labelEmpty.frame = CGRect(x: view.frame.minX + 15, y: view.frame.minY - 20, width: view.frame.width - 30, height: 60)
    
        }
        
    }
    
    func blackoutScreen(view: UIView) {
        //UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            view.backgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.4)
        //}
    }
    
    func whiteoutScreen(view: UIView) {
        self.labelEmpty.isHidden = false
        //UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            view.backgroundColor = .systemBackground
        //}
    }
    
    @objc func hiddenView() {
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.labelEmpty.numberOfLines = 0
        
        //self.labelEmpty.frame.size = CGSize(width: self.frame.width - 30, height: 60)
        //labelEmpty.frame = CGRect(x: 15, y: 120, width: self.frame.size.width, height: 30)
    }
    
}
