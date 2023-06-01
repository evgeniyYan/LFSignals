//
//  CurrencyView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SkeletonView


class CurrencyView: UIViewController {
    
    var presenter: SignalsPresenterProtocol!
    var presenterCur: CurrencyPresenterProtocol?
   
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
        table.backgroundColor = .clear
        table.backgroundColor = .customBGViewController()
        table.separatorStyle = .none
        table.estimatedRowHeight = UITableView.automaticDimension
        return table
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.text = "Здесь ничего нет".localized()
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    var boolSkeleton = UserDefaults.standard.bool(forKey: UserSettings.boolSkeleton)
    
    var allNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if UserDefaults.standard.bool(forKey: UserSettings.boolSkeleton) {
            tableView.isSkeletonable = true
            tableView.showAnimatedSkeleton()
            UserDefaults.standard.set(false, forKey: UserSettings.boolSkeleton)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tableView.isSkeletonable = false
                self.tableView.hideSkeleton(transition: .crossDissolve(1.5))
            }
        }
        
        var mass = [AllDataModel]()
        
        if UserDefault.decodableData(key: UserSettings.checkInCurrency).isEmpty {
            mass = presenter.getToolCount(arr: presenter.allDataCurrency ?? [AllDataModel]())
        } else {
            
            mass = presenter.getToolCount(arr: UserDefault.decodableData(key: UserSettings.checkInCurrency))
        }
        
       
        for i in 0..<mass.count {
            let item = mass[i]
            self.allNames.append(item.title)
        }
        allNames = allNames.uniqued()
        allNames.sort()
        
        if mass.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    
        
       
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//            DispatchQueue.main.async {
//                self.tableView.hideSkeleton(transition: .crossDissolve(1.5))
//            }
//        }
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        emptyLabel.frame = CGRect(x: 0, y: view.center.y / 2, width: view.frame.width, height: 20)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.isSkeletonable = false
        tableView.hideSkeleton()
    }
}

extension CurrencyView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CurrencyViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allNames.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        let cell = cell as? CurrencyViewCell
        cell?.showAnimatedGradientSkeleton()
        cell?.backgroundColor = .customBGViewController()
        
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier, for: indexPath) as! CurrencyViewCell
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero


        cell.clipsToBounds = true
        
        
       // cell.labelPrice.text = entryes[indexPath.section].currency
        return cell
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
}


extension CurrencyView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allNames.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 10
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier, for: indexPath) as? CurrencyViewCell else {fatalError()}
        cell.isSkeletonable = true
        let range = presenterCur?.customBar.titleRangeButton.text
        let row = self.allNames[indexPath.row]
        let date = presenter.processingDate(arr: presenter.allDataCurrency, name:  row, range: range!)
        let color = presenter.processingColorRating(arr: presenter.allDataCurrency, name: row, range: range!)
        let difTime = presenter.returnTime(dateAPI: date)
        let bool = presenter.newStatus(dateAPI: date)
        let hidden = presenter.router.hintsBool
        cell.sellButton.isHidden = hidden!
        if !date.isEmpty {
            cell.configure(title: row, time: date, color: color, new: bool, difTime: difTime)
        }
        cell.backgroundColor = .clear
        cell.sellButton.isHidden = UserDefaults.standard.bool(forKey: UserSettings.hintsSwitcher)
        //cell.sellButton.isHidden = self.presenter.router.hintsBool
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.taponDetailVC(tool: self.allNames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }

}





