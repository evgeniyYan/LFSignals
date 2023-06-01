//
//  FilterCollectionCell.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {
    static let identifier = "collectionCell"
    
    var arrNamesTools = [String]()
    var typeTool = 0
    var typeToolName = ""
    var presenter: FilterPresenterProtocol!
    
    var overlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isHidden = true
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(FilterViewCell.self, forCellReuseIdentifier: FilterViewCell.identifier)
        table.backgroundColor = .clear
        table.separatorInset = .zero
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tableView)
        contentView.addSubview(overlay)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = CGRect(x: 15, y: 0, width: contentView.frame.width - 30, height: contentView.frame.height / 2.4)
        overlay.frame = self.contentView.bounds
    }
    
    
}

extension FilterCollectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch arrNamesTools.first {
//        case "AUDCAD":
//            presenter.titleCollection = "Валюты"
//        case "AAVUSD":
//            presenter.titleCollection = "Криптовалюты"
//        case "UKBRENT":
//            presenter.titleCollection = "Металлы и нефть"
//        case "#AA":
//            presenter.titleCollection = "Акции"
//        default:
//            presenter.titleCollection = "Индексы"
//        }
        return arrNamesTools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterViewCell.identifier, for: indexPath) as? FilterViewCell else {fatalError()}
        
        cell.configurate(text: arrNamesTools[indexPath.row], type: typeTool)
        cell.backgroundColor = .clear
        //cell.unClickCell()
        
        let color = presenter.setToolCollection(tool: arrNamesTools[indexPath.row])
        
        if color == .white {
            cell.unClickCell()
        } else {
            cell.clickCell()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = tableView.cellForRow(at: indexPath) as? FilterViewCell
       if row?.cellView.backgroundColor == .clear {
           row?.unClickCell()
           presenter.checkToolinCollection(tool: arrNamesTools[indexPath.row], title: typeToolName, color: .white)
       } else {
           row?.clickCell()
           presenter.checkToolinCollection(tool: arrNamesTools[indexPath.row], title:typeToolName, color: .clear)
       }
        
        
    }
}
