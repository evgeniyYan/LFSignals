//
//  SignalsViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SkeletonView

class SignalsViewController: UIViewController {
    var typeToolsList = [String]()
    var presenter: SignalsPresenterProtocol!
    var customBar = CustomBar()
    var errorView = ErrorView()
    let overlayView = UIView()
    let searchEmptyView = SearchEmprtyView()
    var tabBarVC = TabBarViewController()
    var child = UIViewController()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ButtonsCollectionViewCell.self, forCellWithReuseIdentifier: ButtonsCollectionViewCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBGViewController()
        //UserDefaults.standard.set(TypeTools.checkInType, forKey: UserSettings.typeTools)
        let arr = UserDefaults.standard.array(forKey: UserSettings.typeTools) as! [String]
        if arr.isEmpty {
        //if UserDefault.decodableData(key: UserSettings.typeTools).isEmpty {
            //if TypeTools.checkInType.isEmpty {
               //typeToolsList = TypeTools.typeToolsList
                if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
                    TypeTools.typeToolsList = ["Биржевые индексы".localized(), "Акции".localized(), "Металлы и нефть".localized(), "Криптовалюты".localized(), "Валюты".localized()]
                    typeToolsList = TypeTools.typeToolsList
                } else {
                    TypeTools.typeToolsList = ["Валюты".localized(), "Криптовалюты".localized(), "Металлы и нефть".localized(), "Акции".localized(), "Биржевые индексы".localized()]
                    typeToolsList = TypeTools.typeToolsList
                }
//            } else {
//                typeToolsList = TypeTools.checkInType
//            }
        } else {
            typeToolsList = UserDefaults.standard.array(forKey: UserSettings.typeTools)! as! [String]
        }
        print(typeToolsList)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
       // UNUserNotificationCenter.current().delegate = self
        
        let standartAppearance = UINavigationBarAppearance()
        standartAppearance.backgroundColor = .clear
        standartAppearance.shadowColor = .clear
        standartAppearance.configureWithOpaqueBackground()
        standartAppearance.configureWithTransparentBackground()
        
        customBar.searchVC.searchBar.delegate = self
        customBar.searchVC.searchBar.searchTextField.delegate = self
        overlayView.isHidden = true
        view.addSubview(customBar)
        view.addSubview(errorView)
        view.addSubview(collectionView)
        view.addSubview(overlayView)
        view.addSubview(searchEmptyView)
        let number = TimeInterval(UserDefaults.standard.integer(forKey: UserSettings.updateNumber))
        Timer.scheduledTimer(withTimeInterval: number * 60, repeats: true) { timer in
            timer.invalidate()
            self.presenter.timerUpdate(time: number * 60)
        }
        
        Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { _ in
            print("start localPush()")
            self.presenter.localPush()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenCustomBarSearch), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func hiddenCustomBarSearch() {
        presenter.allFadeObj()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        customBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 140)
        customBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIScreen.main.bounds.height / 6.5)
        collectionView.frame = CGRect(x: 0, y: customBar.frame.height, width: view.frame.width, height: 40)
        errorView.frame = view.bounds
        searchEmptyView.frame = view.bounds
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            collectionView.frame = CGRect(x: view.frame.width - collectionView.frame.width - 15, y: customBar.frame.height, width: view.frame.width - 15, height: 40)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.customBar.allFade()
    }
    
}


extension SignalsViewController: SignalsProtocol {
    
    func showErrorView(tableView: Bool, errorView: Bool) {
        DispatchQueue.main.async {
            self.errorView.isHidden = errorView
            self.errorView.presenter = self.presenter
        }
    }
    
    func failure(error: Error, tableView: Bool, errorView: Bool) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.errorView.isHidden = errorView
            self.errorView.presenter = self.presenter
        }
    }
    
    func successs(customBar: CustomBar) {
        self.customBar = customBar
        
        print("signals success")
    }
    
    
   
    func setChildVC(child: UIViewController) {
        if self.children.count > 0{
            //let viewControllers:[UIViewController] = self.children
//            for viewContoller in viewControllers{
//                viewContoller.willMove(toParent: nil)
//                viewContoller.view.removeFromSuperview()
//                viewContoller.removeFromParent()
//            }
            child.removeFromParent()
        }
        self.view.addSubview(child.view)
        self.addChild(child)
        child.didMove(toParent: self)
        
        if UIScreen.main.bounds.height <= 667.0 {
            child.view.frame = CGRect(x: 15, y: view.frame.height - (view.frame.height - 170), width: view.frame.width - 30, height: view.frame.height - 220)
        } else {
            child.view.frame = CGRect(x: 15, y: view.frame.height - (view.frame.height - 200), width: view.frame.width - 30, height: view.frame.height - 220)
        }
       
        //self.child = child
        let view = SignalsViewController.setEmptyView(width: child.view.frame.width, height: child.view.frame.height)
        child.view.addSubview(view)
        
        if searchEmptyView.isHidden == false {
            view.isHidden = false
        } else {
            child.view.isHidden = false
        }
    }
    
    
    
    func showSearchEmptyView(count: Int, text: String) {
        
        if count == 0 {
            self.searchEmptyView.isHidden = false
            self.searchEmptyView.addOverlayView(overlayView: self.overlayView, text: text, hidden: false, view: self.tabBarVC, search: self.customBar.searchVC.searchBar)
            self.searchEmptyView.labelEmpty.isHidden = false
            self.tabBarVC.overlay.isHidden = false
            self.tabBarVC.tabBar.isUserInteractionEnabled = false
            self.collectionView.isUserInteractionEnabled = false
            
        } else {
            self.searchEmptyView.installEmpty(hidden: true, text: text)
            self.searchEmptyView.addOverlayView(overlayView: self.overlayView, text: text, hidden: true, view: self, search: self.customBar.searchVC.searchBar)
            self.searchEmptyView.labelEmpty.isHidden = true
            self.tabBarVC.overlay.isHidden = true
            self.tabBarVC.tabBar.isUserInteractionEnabled = true
            self.searchEmptyView.isHidden = true
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}

extension SignalsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeToolsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCollectionViewCell.identifier, for: indexPath) as? ButtonsCollectionViewCell else {fatalError()}
        let btn = typeToolsList[indexPath.row]
        cell.configurate(btn: btn)
        cell.button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        ModuleButton.buttonArr.append(cell.button)
//        if cell.button.titleLabel?.text == "Валюты" {
       
        if LocaleLayout.getLocale() == "ar" || LocaleLayout.getLocale() == "fa" {
            let button = UIButton()
            button.setTitle(typeToolsList.last, for: .normal)
            ModuleButton.checkButton = button
        } else {
            ModuleButton.checkButton = ModuleButton.buttonArr.first!
        }
//        print("ModuleButton.buttonArr.first! \(ModuleButton.buttonArr.first!.titleLabel!.text)")
//        print("btn \(btn)")
//        }
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            if indexPath.row == typeToolsList.count - 1 {
                cell.button.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                cell.button.setTitleColor(.white, for: .normal)
                
            }
        } else {
            if indexPath.row == 0 {
                cell.button.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                cell.button.setTitleColor(.white, for: .normal)
            }
        }
        if cell.button.titleLabel!.text == "Валюты" {
            cell.contentView.addSubview(cell.emptyView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = typeToolsList[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 23, height: 32)
    }
    
    @objc func didTap(_ sender: UIButton) {
        presenter.tapCollectionButton(sender: sender)
    }
}

extension SignalsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.uppercased(), !text.replacingOccurrences(of: "", with: "").isEmpty else {
            return
        }
        
        print(text)
       presenter.searchTool(text: text, typeTool: ModuleButton.checkButton.titleLabel!.text!)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.customBar.allFade()
        presenter.cancelSearch()
        self.searchEmptyView.installEmpty(hidden: true, text: searchBar.text!)
        self.searchEmptyView.addOverlayView(overlayView: self.overlayView, text: searchBar.text!, hidden: true, view: self, search: self.customBar.searchVC.searchBar)
        self.searchEmptyView.labelEmpty.isHidden = true
        self.tabBarVC.tabBar.backgroundColor = .customBGTab()
        self.tabBarVC.tabBar.isUserInteractionEnabled = true
        self.searchEmptyView.isHidden = true
        presenter.tapCollectionButton(sender: ModuleButton.checkButton)
        self.tabBarVC.overlay.isHidden = true
    }
    
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let aSet = NSCharacterSet(charactersIn:"#qwertyuiopasdfghjklzxcvbnm").inverted
//        let compSepByCharInSet = text.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        return text == numberFiltered
//    }
    
}


extension SignalsViewController: UITextFieldDelegate {
    //MARK: - в textfiled только цифры
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"#qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}


//extension SignalsViewController: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert])
//    }
//}
