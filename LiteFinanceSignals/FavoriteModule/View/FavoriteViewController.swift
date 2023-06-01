//
//  FavoriteViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var presenter: FavoritePresenterProtocol!
    var presenterSignals: SignalsPresenterProtocol!
    var customBar = CustomBar()
    
    var allNames = [String]()
    
    var nav = UINavigationController()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.text = "Здесь ничего нет".localized()
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
        table.register(CryptoViewCell.self, forCellReuseIdentifier: CryptoViewCell.identifier)
        table.register(MetalViewCell.self, forCellReuseIdentifier: MetalViewCell.identifier)
        table.register(StockViewCell.self, forCellReuseIdentifier: StockViewCell.identifier)
        table.register(IndexViewCell.self, forCellReuseIdentifier: IndexViewCell.identifier)
        table.backgroundColor = .customBGViewController()
        table.separatorInset = .zero
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        view.backgroundColor = .customBGViewController()
        super.viewDidLoad()
        
        var mass = presenter.updateTools!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0..<mass.count {
            let item = mass[i]
            self.allNames.append(item.title)
        }
        allNames = allNames.uniqued()
       // allNames.sort()
        
        if presenter.tools!.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        
        view.addSubview(customBar)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            mass = self.presenter.getToolsFromParse(tools: self.allNames)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIScreen.main.bounds.height / 6.5)
        tableView.frame = CGRect(x: 15, y: 160, width: view.frame.width - 30, height: view.frame.height + 160)
        emptyLabel.frame = CGRect(x: 0, y: view.center.y, width: view.frame.width, height: 20)
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReady  = UITableViewCell()
        let saveArr = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String]
        let range = self.customBar.titleRangeButton.text
        let row = self.allNames[indexPath.row]
        let color = presenter.processingColorRating(arr: presenter.tools, name: row, range: range!)
        let data = presenter.processingDate(arr: presenter.tools, name: row, range: range!)
        let bool = presenter.newStatus(dateAPI: data)
        let difTime = presenter.returnTime(dateAPI: data)
        let type = presenter.getTypeTool(arr: row)
        
        
        switch type {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier, for: indexPath) as? CurrencyViewCell else { fatalError() }
            cell.backgroundColor = .customBGViewController()
            cell.sellButton.isHidden = self.presenter.router.hintsBool
            cell.configure(title: row, time: data, color: color, new: bool, difTime: difTime)
            cellReady = cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoViewCell.identifier, for: indexPath) as? CryptoViewCell else { fatalError() }
            cell.backgroundColor = .customBGViewController()
            cell.sellButton.isHidden = self.presenter.router.hintsBool
            cell.configure(title: row, time: data, color: color, new: bool, difTime: difTime)
            cellReady = cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MetalViewCell.identifier, for: indexPath) as? MetalViewCell else {fatalError()}
            cell.backgroundColor = .customBGViewController()
            cell.sellButton.isHidden = self.presenter.router.hintsBool
            cell.configure(title: row, time: data, color: color, new: bool, difTime: difTime)
            cellReady = cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockViewCell.identifier, for: indexPath) as? StockViewCell else { fatalError() }
            cell.backgroundColor = .customBGViewController()
            cell.sellButton.isHidden = self.presenter.router.hintsBool
            cell.configure(title: row, time: data, color: color, new: bool, difTime: difTime)
            cellReady = cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IndexViewCell.identifier, for: indexPath) as? IndexViewCell else {fatalError()}
            cell.backgroundColor = .customBGViewController()
            cell.sellButton.isHidden = self.presenter.router.hintsBool
            cell.configure(title: row, time: data, color: color, new: bool, difTime: difTime)
            cellReady = cell
        }
      
        return cellReady
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.taponDetailVC(tool: self.allNames[indexPath.row])
    }
}

extension FavoriteViewController: FavoriteProtocol {
    
    func success(customBar: CustomBar) {
       print("favorite success")
        self.customBar = customBar
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    func updateTableView(tools: [AllDataModel], timeZone: String) {
        
        //if !UserDefault.decodableData(key: UserSettings.favoriteTool).isEmpty {
            self.presenter.getToolCount(arr: UserDefault.decodableData(key: UserSettings.favoriteTool))
            self.presenter.tools = UserDefault.decodableData(key: UserSettings.favoriteTool)

            let mass = presenter.updateTools!
            //let mass = presenter.getToolsFromParse(tools: self.allNames)
//        let mass = tools
            self.allNames = [String]()

            for i in 0..<mass.count {
                let item = mass[i]
                self.allNames.append(item.title)
            }
            allNames = allNames.uniqued()

            if allNames.isEmpty {
                emptyLabel.isHidden = false
            } else {
                emptyLabel.isHidden = true
            }
        //}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
