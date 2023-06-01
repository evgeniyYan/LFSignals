//
//  PopOverViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

class PopOverViewController: UIViewController {
    
    var rangeArr = [String]()
    
    var presenter: PopOverPresenterPorotocol!
    
    let tableView: UITableView = {
      let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "rangeCell")
        table.separatorInset = .zero
        table.backgroundColor = .customRabgeTableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customRabgeTableView()
        
        if UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)!.isEmpty {
        //if TimeZoneRange.arrCheckIn.isEmpty {
            rangeArr = TimeZoneRange.arr
        } else {
            rangeArr = UserDefaults.standard.array(forKey: UserSettings.timeZoneRange)! as! [String]
        }
        
        
//
//        for i in 0..<TimeZoneRange.arr.count {
//            print(TimeZoneRange.arrChectOut)
//            print(TimeZoneRange.arr)
//            rangeArr = TimeZoneRange.arrChectOut.filter({$0 == TimeZoneRange.arr[i]})
//        }
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}


extension PopOverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rangeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rangeCell", for: indexPath)
        cell.textLabel?.text = rangeArr[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.textColor = .customColorText()
        cell.backgroundColor = .customRabgeTableView()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.setTitleRangeButton(title: rangeArr[indexPath.row])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.dismiss(animated: true)
        })
    }
}
