//
//  FilterViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class FilterViewController: UIViewController, UIScrollViewDelegate {
    var rangeCell = ["Валюты".localized(), "Криптовалюты".localized(), "Металлы и нефть".localized(), "Акции".localized(), "Биржевые индексы".localized()]
    var presenter: FilterPresenterProtocol!
    var presenterSignals: SignalsPresenterProtocol!
    let navBar = UINavigationBar()
    let scrollView = UIScrollView()
    let overlay = UIView()
    let searchEmptyView = SearchEmprtyView()
    var count = 1
    var timeView: TimeView!
    var toolsView: ToolsView!
    var recommendView: RecommendView!
    var indexCollection = 0
    let subTitle = CustomTitle(text: "Вы можете уточнить список".localized())
    
    
    let checkInView = UIView()
    let checkOutView = UIView()
    
    let checkIn: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.frame.size = CGSize(width: 14, height: 14)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    let checkOut: UIView = {
        let view = UIView()
        view.backgroundColor = .customFilterBG()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.906, green: 0.91, blue: 0.925, alpha: 1).cgColor
        view.frame.size = CGSize(width: 14, height: 14)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let checkInLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбран".localized().uppercased()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor(red: 0.698, green: 0.706, blue: 0.741, alpha: 1)
        return label
    }()
    
    let checkOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Скрыт".localized().uppercased()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor(red: 0.698, green: 0.706, blue: 0.741, alpha: 1)
        return label
    }()
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1500 as CGFloat
    
    var arrNamesCurrncy = [String]()
    
    let searchView = UIView()
    let searchBar = UISearchBar()
    
    let searchButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .customFilterSearchBar()
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        return btn
    }()
    
    let collectionTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Валюты".localized()
        label.textColor = .black
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FilterCollectionCell.self, forCellWithReuseIdentifier: FilterCollectionCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .customFilterBG()
        collection.isPagingEnabled = true
        return collection
    }()
    
    let swipeLabel: UILabel = {
       let label = UILabel()
        label.text = "Свайп для смены типа инструмента".localized().uppercased()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0.698, green: 0.706, blue: 0.741, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    let arrowView: UIImageView = {
       let arrow = UIImageView()
        arrow.image = UIImage(systemName: "arrow.right")
        arrow.tintColor = UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
        return arrow
    }()
    
    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customFilterBG()
        scrollView.backgroundColor = .customFilterBG()
        headerView.backgroundColor = .customFilterBG()
        headerView.alpha = 0.0
        scrollView.contentSize = CGSizeMake(view.frame.width, scrollViewContentHeight)
        scrollView.delegate = self
        
        scrollView.bounces = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        presenter.collectionView = self.collectionView
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        checkInView.addSubview(checkIn)
        checkInView.addSubview(checkInLabel)
        
        checkOutView.addSubview(checkOut)
        checkOutView.addSubview(checkOutLabel)
        
        let navItem = UINavigationItem(title: "Фильтр".localized())
        let resetItem = UIBarButtonItem(title: "Сбросить всё".localized(), style: .plain, target: self, action: #selector(didTapDone))
        let closeItem = UIBarButtonItem(title: "Отмена".localized(), style: .plain, target: self, action: #selector(closeVC))
        resetItem.tintColor = .customFilterNabButtons()
        closeItem.tintColor = .customFilterNabButtons()
        navItem.rightBarButtonItem = resetItem
        navItem.leftBarButtonItem = closeItem
       
        navBar.backgroundColor = .customFilterBG()
        navBar.barTintColor = .customFilterBG()
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.setItems([navItem], animated: false)
        
        subTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        
        searchView.backgroundColor = .customFilterSearchBar()
        overlay.isHidden = true
        searchBar.placeholder = "Найти торговый инструмент".localized()
        searchBar.backgroundColor = .customFilterSearchBar()
        searchBar.barTintColor = .customFilterSearchBar()
        searchBar.layer.borderWidth = 0
       
        searchBar.showsCancelButton = true
        searchBar.setValue("Отмена".localized(), forKey: "cancelButtonText")
        searchBar.tintColor = .black
        searchBar.isHidden = true
        searchBar.searchTextField.delegate = self
        
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена".localized()
        searchBar.delegate = self
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            rangeCell = ["Биржевые индексы".localized(), "Акции".localized(), "Металлы и нефть".localized(), "Криптовалюты".localized(), "Валюты".localized()]
        }
        
        view.addSubview(navBar)
        view.addSubview(scrollView)
        view.addSubview(headerView)
        scrollView.addSubview(checkInView)
        scrollView.addSubview(checkOutView)
        scrollView.addSubview(timeView)
        scrollView.addSubview(toolsView)
        scrollView.addSubview(recommendView)
        scrollView.addSubview(subTitle)
        scrollView.addSubview(searchView)
        searchView.addSubview(searchBar)
        searchView.addSubview(searchButton)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(swipeLabel)
        scrollView.addSubview(arrowView)
        scrollView.addSubview(overlay)
        scrollView.addSubview(searchEmptyView)
        
        searchView.addSubview(collectionTitle)
    }
    
    @objc func didTapDone() {
        presenter.dropFilter()
    }
    
    @objc func closeVC() {
        presenter.closeVC()
        self.dismiss(animated: true)
    }
    

    override func viewWillLayoutSubviews() {
       
        super.viewWillLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 61)
        navBar.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: 44)
        
        checkInView.frame = CGRect(x: view.frame.width / 2 + 30, y: 20, width: checkIn.frame.width + 5 + checkInLabel.frame.width, height: 14)
        checkIn.frame.origin = CGPoint(x: 0, y: 0)
        checkInLabel.frame = CGRect(x: checkIn.frame.width + 4, y: 0, width: 58, height: 14)
        
        checkOutView.frame = CGRect(x: view.frame.width - (checkOut.frame.width + 2 + checkOutLabel.frame.width) - 75, y: 20, width: checkOut.frame.width + 2 + checkOutLabel.frame.width, height: 14)
        checkOut.frame.origin = CGPoint(x: 0, y: 0)
        checkOutLabel.frame = CGRect(x: checkOut.frame.width + 4, y: 0, width: 60, height: 14)
        
        scrollView.frame = CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: view.frame.height)
        if UIScreen.main.bounds.height <= 812.0 {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
        } else {
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 350)
        }
        timeView.frame = CGRect(x: 15, y: 50, width: view.frame.width - 30, height: 130)
        toolsView.frame = CGRect(x: 15, y: timeView.frame.maxY + 20, width: view.frame.width - 30, height: 210)
        recommendView.frame = CGRect(x: 15, y: toolsView.frame.maxY + 20, width: view.frame.width - 30, height: 230)
        subTitle.frame = CGRect(x: 15, y: recommendView.frame.maxY + 45, width: view.frame.width, height: 30)
        searchView.frame = CGRect(x: 0, y: subTitle.frame.maxY + 14, width: view.frame.width, height: 50)
        searchButton.frame = CGRect(x: view.frame.width - 55, y: 1, width: 50, height: 48)
        searchBar.frame = CGRect(x: 8, y: 0, width: view.frame.size.width - 16, height: 50)
        collectionTitle.frame = CGRect(x: 15, y: 0, width: view.frame.width - 50, height: 50)
        swipeLabel.frame = CGRect(x: view.frame.width - view.frame.width / 1.3, y: searchView.frame.maxY + 10, width: view.frame.width / 1.4, height: 10)
        arrowView.frame = CGRect(x: swipeLabel.frame.maxX, y: searchView.frame.maxY + 12, width: 14, height: 6)
        collectionView.frame = CGRect(x: 0, y: searchView.frame.maxY + 30, width: scrollView.frame.width, height: view.frame.height + 500)
        
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            checkInLabel.textAlignment = .left
            checkOutLabel.textAlignment = .left
            subTitle.frame = CGRect(x: self.view.frame.width - view.frame.width - 15, y: recommendView.frame.maxY + 45, width: view.frame.width, height: 30)
            //collectionTitle.frame = CGRect(x: self.view.frame.width - self.view.frame.width - 65, y: 0, width: view.frame.width - 50, height: 50)
            searchButton.frame = CGRect(x: 15, y: 1, width: 50, height: 48)
            swipeLabel.frame = CGRect(x: 40, y: searchView.frame.maxY + 10, width: view.frame.width / 1.4, height: 10)
            swipeLabel.textAlignment = .left
            arrowView.frame = CGRect(x: 15, y: searchView.frame.maxY + 12, width: 14, height: 6)
            arrowView.image = UIImage(systemName: "arrow.left")
        }
    }

    @objc func didTapSearch() {
        
        UIView.transition(with: self.collectionTitle, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self!.collectionTitle.isHidden = true
            self?.searchButton.isHidden = true
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.searchBar.isHidden = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        var offsetHeight = scrollViewContentHeight - screenHeight
        
        if UIScreen.main.bounds.height <= 812.0 {
            offsetHeight = scrollViewContentHeight - screenHeight - 80.0
        } else {
            offsetHeight = scrollViewContentHeight - screenHeight + 20.0
        }
            if scrollView == self.scrollView {
                if yOffset >= offsetHeight {
                    self.scrollView.isScrollEnabled = false
                    collectionView.isScrollEnabled = true
                } else {
                    self.scrollView.isScrollEnabled = true
                    self.collectionView.isScrollEnabled = false
                }
            }
        
        if yOffset > 0 {
            UIView.animate(withDuration: 0.3) {
                self.navBar.backgroundColor = .customFilterHeaderViewBG()
                self.headerView.alpha = 1.0
                self.headerView.backgroundColor = .customFilterHeaderViewBG()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navBar.backgroundColor = .customFilterBG()
                self.headerView.alpha = 0.0
               
            }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        let index:Int = Int(collectionView.contentOffset.x / pageWidth)
        print("index \(index)")
        let text = rangeCell[index]
        
        presenter.titleCollection = text
       
        UIView.transition(with: self.collectionTitle, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self!.collectionTitle.text = text
        }, completion: nil)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
}


extension FilterViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.uppercased(), !text.replacingOccurrences(of: "", with: "").isEmpty else  {return}
        
        print(text)
        presenter.searchTool(text: text, typeTool: self.collectionTitle.text!)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.collectionTitle.isHidden = false
        self.searchBar.isHidden = true
        self.searchButton.isHidden = false
        self.searchEmptyView.installEmpty(hidden: true, text: searchBar.text!)
        self.searchEmptyView.addOverlayViewFilter(overlayView: self.overlay, text: searchBar.text!, hidden: true, view: self.collectionView, search: self.searchBar)
        self.searchEmptyView.labelEmpty.isHidden = true
        self.collectionView.isUserInteractionEnabled = true
        self.searchEmptyView.isHidden = true
        presenter.cancelSearch()
        
    }
}



extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rangeCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionCell.identifier, for: indexPath) as? FilterCollectionCell else {fatalError()}
        
        let typeTool = presenterSignals.getTypeTool(text: presenter.titleCollection)
        
        presenter.getTitleCollectio(text: presenter.titleCollection)
        let arr = presenter.getNamesForCollection(tool: presenter.titleCollection)
       
        cell.presenter = presenter
        cell.arrNamesTools = arr
        cell.typeTool = typeTool
        cell.typeToolName = rangeCell[indexPath.section]
       
        //DispatchQueue.main.async {
            cell.tableView.reloadData()
       // }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


extension FilterViewController: FilterProtocol {
    func setEmptyView(count: Int, text: String) {
       
        if count == 0 {
            self.searchEmptyView.isHidden = false
            self.collectionView.isUserInteractionEnabled = false
            self.searchEmptyView.installEmpty(hidden: false, text: text)
            self.searchEmptyView.labelEmpty.frame = CGRect(x: 15, y: 0, width: view.frame.width - 30, height: 80)
            let targetMaskLayer = CAShapeLayer()
            let sizeCancelBtn = searchBar.layer.frame.width - searchBar.searchTextField.frame.width
            let squareSideWidth = searchBar.frame.width - sizeCancelBtn
            
            let squareSideHeight = searchBar.frame.height - 17
            let squareSize = CGSize(width: squareSideWidth, height: squareSideHeight)
            let path = UIBezierPath(rect: self.view.bounds)
            let squareOrigin = CGPoint(x: 16,
                                       y: CGFloat(searchBar.frame.minY + 7))
            let square = UIBezierPath(roundedRect: CGRect(origin: squareOrigin, size: squareSize), cornerRadius: 8)
            path.append(square)
            
            targetMaskLayer.path = path.cgPath
            targetMaskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            
            overlay.layer.mask = targetMaskLayer
            overlay.clipsToBounds = true
            overlay.isHidden = false
            overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            overlay.isUserInteractionEnabled = false
        } else {
            self.searchEmptyView.addOverlayViewFilter(overlayView: self.overlay, text: text, hidden: true, view: self.collectionView, search: self.searchBar)
            self.searchEmptyView.labelEmpty.isHidden = true
            self.searchEmptyView.isHidden = true
            self.collectionView.isUserInteractionEnabled = true
        }
        
        self.overlay.frame = CGRect(x: 0, y: subTitle.frame.maxY + 16, width: view.frame.width, height: view.frame.height)
        searchEmptyView.frame = CGRect(x: 0, y: subTitle.frame.maxY + 40, width: view.frame.width, height: view.frame.height)
    }
    
    func success(time: TimeView, tools: ToolsView, recommend: RecommendView, childVC: UIViewController) {
        self.timeView = time
        
        self.toolsView = tools
        self.recommendView = recommend
        //setChildVC(child: childVC)
    }
}


extension FilterViewController: UITextFieldDelegate {
    //MARK: - в textfiled только цифры
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"#qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
