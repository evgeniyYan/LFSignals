//
//  CustomBar.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class CustomBar: UINavigationBar, CustomBarProtocol {
    
    var presenter: CustomBarProtocol!
    var presenterSignal: SignalsPresenterProtocol!
    var presenterFavorite: FavoritePresenterProtocol!
    var router: RouterProtocol!
    var popOver: UIViewController! = PopOverViewController()
    weak var view: UIViewController?
    let navItem = UINavigationItem(title: "")
    
    var titleNav: UILabel! = {
        let title = UILabel()
        title.text = "Сигналы".localized()
        title.font = .systemFont(ofSize: 28, weight: .bold)
        return title
    }()
    
    var filterButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "filter"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        
        return btn
    }()
    
    var searchButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.tintColor = .customColorText()
        return btn
    }()
    
    let searchVC: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Найти торговый инструмент".localized()
        search.searchBar.alpha = 0.0
        search.searchBar.barTintColor = .orange
        //search.searchBar.tintColor = .customColorText()
        search.searchBar.showsCancelButton = true
        search.automaticallyShowsScopeBar = false
        search.searchBar.layer.cornerRadius = 10
        return search
    }()
    
    var rangeButton: UIButton = UIButton()
    
    var titleRangeButton: UILabel! = {
        let label = UILabel()
        //label.text = "M1"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .customColorText()
        label.textAlignment = .right
        return label
    }()
    
    let symbolRangeButton: UIImageView = {
      let image = UIImageView()
        image.image = UIImage(systemName: "arrowtriangle.down.fill")
        image.tintColor = .customColorText()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(view: UIViewController, title: String, filterButton: Bool, searchButton: Bool, rangeButton: Bool, router: RouterProtocol) {
        super.init(frame: CGRect.zero)
        self.view = view
        self.filterButton.isHidden = filterButton
        self.titleNav.text = title
        self.searchButton.isHidden = searchButton
        self.rangeButton.isHidden = rangeButton
        self.router = router
        
        if UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)!.isEmpty {
        //if TimeZoneRange.arrCheckIn.isEmpty {
            titleRangeButton.text = TimeZoneRange.arr.first
            UserDefaults.standard.set(titleRangeButton.text, forKey: UserSettings.timeZoneSignals)
            UserDefaults.standard.set(titleRangeButton.text, forKey: UserSettings.timeZoneFavorite)
        } else {
            let saveArr = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String]
            print(UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String])
            print("saveArr.first \(saveArr.first)")
            titleRangeButton.text = saveArr.first
//            UserDefaults.standard.set(titleRangeButton.text, forKey: UserSettings.timeZoneSignals)
//            UserDefaults.standard.set(titleRangeButton.text, forKey: UserSettings.timeZoneFavorite)
        }
        
        if LocaleLayout.getLocale() == "my" {
            titleNav.font = .systemFont(ofSize: 23, weight: .bold)
        }
        
        addSubview(titleNav)
        addSubview(self.filterButton)
        addSubview(self.searchButton)
        self.rangeButton.addSubview(titleRangeButton)
        self.rangeButton.addSubview(symbolRangeButton)
        addSubview(self.rangeButton)
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.searchBar.searchBarStyle = .minimal
        
        self.backgroundColor = .customBGNav()
        
        self.filterButton.addTarget(self, action: #selector(didTapFilterVC), for: .touchUpInside)
        self.searchButton.addTarget(self, action: #selector(tapAddSearcBar), for: .touchUpInside)
        self.rangeButton.addTarget(self, action: #selector(didTapRangeVC), for: .touchUpInside)
        
        navItem.searchController = searchVC
        
        setItems([navItem], animated: true)
        
        if #available(iOS 13, *) {
            let standartAppearance = UINavigationBarAppearance()
            standartAppearance.configureWithOpaqueBackground()
            standartAppearance.configureWithTransparentBackground()
            standartAppearance.backgroundColor = .customBGNav()
            standartAppearance.shadowColor = .customBGNav()
            self.standardAppearance = standartAppearance
            self.scrollEdgeAppearance = standartAppearance
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

       
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            titleNav.frame = CGRect(x: self.frame.width - titleNav.frame.width - 15, y: UIScreen.main.bounds.height / 6.5 - 55, width: self.frame.width / 2, height: 50)
            titleNav.textAlignment = .right
            rangeButton.frame = CGRect(x: 15, y: 103, width: 50, height: 20)
            titleRangeButton.frame = CGRect(x: 15, y: 0, width: 50, height: 20)
            titleRangeButton.textAlignment = .left
            symbolRangeButton.frame = CGRect(x: 0, y: 8, width: 10, height: 5)
            filterButton.frame = CGRect(x: rangeButton.frame.width + 80, y: 105, width: 16, height: 16)
            searchVC.searchBar.frame = CGRect(x: 0, y: self.frame.maxY - 50, width: self.frame.size.width - 10, height: 50)
            searchButton.frame = CGRect(x: rangeButton.frame.maxX + 20, y: 105, width: 18, height: 17)
        } else {
            titleNav.frame = CGRect(x: 16, y: UIScreen.main.bounds.height / 6.5 - 55, width: self.frame.width / 2, height: 50)
//            filterButton.frame = CGRect(x: UIScreen.main.bounds.width / 2 + 20, y: 105, width: 16, height: 16)
            filterButton.frame = CGRect(x: UIScreen.main.bounds.width - rangeButton.frame.width - searchButton.frame.width - 15 - 85, y: UIScreen.main.bounds.height / 6.5 - 35, width: 16, height: 16)
            //searchButton.frame = CGRect(x: UIScreen.main.bounds.width / 2 + filterButton.frame.width + 50, y: 105, width: 18, height: 17)
            searchButton.frame = CGRect(x: UIScreen.main.bounds.width - rangeButton.frame.width - 15 - 50, y: UIScreen.main.bounds.height / 6.5 - 35, width: 18, height: 17)
            rangeButton.frame = CGRect(x: UIScreen.main.bounds.width - rangeButton.frame.width - 15, y: UIScreen.main.bounds.height / 6.5 - 38, width: 50, height: 20)
            titleRangeButton.frame = CGRect(x: -20, y: 0, width: 50, height: 20)
            symbolRangeButton.frame = CGRect(x: 38, y: 8, width: 10, height: 5)
            //rangeButton.frame = CGRect(x: UIScreen.main.bounds.width / 2 + filterButton.frame.width + searchButton.frame.width + 90, y: 103, width: 50, height: 20)
            
            searchVC.searchBar.frame = CGRect(x: 0, y: self.frame.maxY - 50, width: self.frame.size.width - 10, height: 50)
        }
    }
    
    @objc func didTapFilterVC() {
        router.showFilter()
    }
    
    @objc func didTapRangeVC() {
        if self.titleNav.text == "Сигналы".localized() {
            router.showRangePopOver(pop: self.popOver, bar: self, view: self.presenterSignal.view! as! UIViewController)
        } else {
            router.showRangePopOver(pop: self.popOver, bar: self, view: self.presenterFavorite.view! as! UIViewController)
        }
        
    }
    
    func updateTitleRange(text: String) {
        titleRangeButton.text = text
        presenterSignal.tapPopOVerButton(text: text)
        UserDefaults.standard.set(text, forKey: UserSettings.timeZoneSignals)
    }
    
    func onlyUpdateTitleRange(text: String) {
        titleRangeButton.text = text
        UserDefaults.standard.set(text, forKey: UserSettings.timeZoneFavorite)
        presenterFavorite.view?.success(customBar: self)
        self.router.favoriteTimeZone = text
       //let _ = self.router.assemblyBuilder?.createFavoriteViewController(tools: UserDefault.decodableData(key: UserSettings.favoriteTool), router: self.presenterSignal.router, timeZone: UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)!)
        self.router.delegateFavoriteTool(tools: UserDefault.decodableData(key: UserSettings.favoriteTool), timeZone: UserDefaults.standard.string(forKey: UserSettings.timeZoneFavorite)!)
        
        
        //router.updateFavoriteVC()
    }
    
    @objc func tapAddSearcBar() {
        titleNav.layer.layoutIfNeeded()
        searchButton.layer.layoutIfNeeded()
        searchVC.searchBar.layer.layoutIfNeeded()
        
        //MARK: - анимация при включении/отключении поля поиска
        if searchVC.searchBar.alpha == 0.0 {
            if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.titleNav.frame.origin = CGPoint(x: self.frame.width - self.titleNav.frame.width - 15, y: 40)
                    self.filterButton.alpha = 0.0
                    self.searchButton.alpha = 0.0
                    self.rangeButton.alpha = 0.0
                    self.searchVC.searchBar.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.titleNav.frame.origin = CGPoint(x: 16, y: 40)
                    self.filterButton.alpha = 0.0
                    self.searchButton.alpha = 0.0
                    self.rangeButton.alpha = 0.0
                    self.searchVC.searchBar.alpha = 1.0
                }
            }
        }
    }
    
    //MARK: - вызывается при сворачивании приложения
    func allFade() {
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.titleNav.frame.origin = CGPoint(x: self.frame.width - self.titleNav.frame.width - 15, y: 85)
                self.filterButton.alpha = 1.0
                self.rangeButton.alpha = 1.0
                self.searchButton.alpha = 1.0
                self.searchVC.searchBar.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.titleNav.frame.origin = CGPoint(x: 16, y: 85)
                self.filterButton.alpha = 1.0
                self.rangeButton.alpha = 1.0
                self.searchButton.alpha = 1.0
                self.searchVC.searchBar.alpha = 0.0
            }
        }
        
    }
}

extension CustomBar: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
