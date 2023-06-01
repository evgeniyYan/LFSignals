//
//  StocksView.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit


class StocksView: UIViewController {

    var presenter: SignalsPresenterProtocol!
    var allNames = [String]()
    var presenterStock: StockPresenterProtocol!
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(StockViewCell.self, forCellReuseIdentifier: StockViewCell.identifier)
        table.backgroundColor = .customBGViewController()
        table.separatorStyle = .none
        table.separatorColor = .clear
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var mass = [AllDataModel]()
        
        if UserDefaults.standard.array(forKey: UserSettings.checkInStock)!.isEmpty {
            mass = presenter.getToolCount(arr: presenter.allDataStock!)
        } else {
            mass = presenter.getToolCount(arr: UserDefaults.standard.array(forKey: UserSettings.checkInStock)! as! [AllDataModel])
        }
       
        for i in 0..<mass.count {
            let item = mass[i]
            self.allNames.append(item.title)
        }
        
        if mass.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        
        allNames = allNames.uniqued()
        allNames.sort()
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        emptyLabel.frame = CGRect(x: 0, y: view.center.y / 2, width: view.frame.width, height: 20)
    }
}




extension StocksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockViewCell.identifier, for: indexPath) as? StockViewCell else { fatalError() }
        
        let range = presenterStock.customBar.titleRangeButton!.text
        let row = self.allNames[indexPath.row]
        let date = presenter.processingDate(arr: presenter.allDataStock, name:  row, range: range!)
        let color = presenter.processingColorRating(arr: presenter.allDataStock, name: row, range: range!)
        let difTime = presenter.returnTime(dateAPI: date)
        let bool = presenter.newStatus(dateAPI: date)
        cell.configure(title: row, time: date, color: color, new: bool, difTime: difTime)
        cell.backgroundColor = .clear
        cell.sellButton.isHidden = UserDefaults.standard.bool(forKey: UserSettings.hintsSwitcher)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.taponDetailVC(tool: self.allNames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
