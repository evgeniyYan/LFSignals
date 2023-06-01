//
//  ToolViewController.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import SDWebImageSVGCoder
import Charts

class ToolViewController: UIViewController, ChartViewDelegate {
    var presenter: ToolPresenterProtocol!
    var getCurrencyName = GetCurrencyName()
    var indicators: [ToolIndicator]?
    
    let viewImagesTool = UIView()
    let viewTimeTool = UIView()
    let viewZoneTool = UIView()
    
    let scrollView = UIScrollView()
    
    var arr = [AllDataModel]()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "9:31"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .customFilterNabButtons()
        return label
    }()
    
    let subTitileTime: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.text = "Время сигнала".localized().uppercased()
        label.textAlignment = .center
        label.textColor = .customFilterNabButtons()
        return label
    }()
    
    var imageView: ImageView! = ImageView()
    
    let titleTool: UILabel = {
     let label = UILabel()
        label.text = "".localized()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .customFilterNabButtons()
        label.textAlignment = .center
        return label
    }()
    
    let zoneLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .customFilterNabButtons()
        label.text = "".localized()
        return label
    }()
    
    let subTitileZone: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .customFilterNabButtons()
        label.text = "Таймфрейм".localized().uppercased()
        return label
    }()
    
    let borderView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star")
        image.tintColor = .red
        return image
    }()
    
    let viewWithCurcles = CirclesView()
    
    var chartView = CandleStickChartView()
   
    
    let subTitileCircle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .customFilterNabButtons()
        label.text = "Осторожно продавать".localized().uppercased()
        label.numberOfLines = 0
        return label
    }()
    
    let addFavoriteView = AddFavoriteView(tool: "")
    
    var buySellButton: UIButton! = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 23
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        btn.titleLabel?.textColor = .white
        btn.frame.size = CGSize(width: 250, height: 44)
        return btn
    }()

    var indicatorView = IndicatorView()
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(IndicatorViewCell.self, forCellReuseIdentifier: IndicatorViewCell.identifier)
        table.separatorInset = .zero
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = .customBGNav()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBGNav()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.chartView.delegate = self
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(tapStarButton))
        self.navigationController?.navigationBar.tintColor = .customColorText()

       
        let standartAppearance = UINavigationBarAppearance()
        standartAppearance.backgroundColor = .customBGNav()
        self.navigationController!.navigationBar.standardAppearance = standartAppearance
        self.navigationController!.navigationBar.scrollEdgeAppearance = standartAppearance
        self.navigationController!.navigationBar.compactAppearance = standartAppearance
        
        
        view.addSubview(borderView)
        view.addSubview(scrollView)
        view.addSubview(addFavoriteView)
        
        scrollView.addSubview(viewImagesTool)
        scrollView.addSubview(imageView)
        
        scrollView.addSubview(viewTimeTool)
        viewTimeTool.addSubview(timeLabel)
        viewTimeTool.addSubview(subTitileTime)
        
        scrollView.addSubview(viewZoneTool)
        viewZoneTool.addSubview(zoneLabel)
        viewZoneTool.addSubview(subTitileZone)
        
        scrollView.addSubview(titleTool)
        scrollView.addSubview(viewWithCurcles)
        scrollView.addSubview(subTitileCircle)
        
        
        scrollView.addSubview(chartView)
        scrollView.addSubview(buySellButton)
       
        scrollView.addSubview(tableView)
        
        scrollView.addSubview(indicatorView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.chartView = CandleStickChartView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        
        borderView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: 1)
        imageView.frame = CGRect(x: 0, y: 30, width: view.frame.width, height: 35)
        viewImagesTool.frame = CGRect(x: view.center.x - 40, y:  30, width: 80, height: 35)
        
        titleTool.frame = CGRect(x: 0, y: viewImagesTool.frame.maxY + 15, width: view.frame.width, height: 30)
        
        viewZoneTool.frame = CGRect(x: view.center.x - 50, y: titleTool.frame.maxY + 33, width: 100, height: 50)
        zoneLabel.frame = CGRect(x: 0, y: 0, width: viewZoneTool.frame.width, height: 20)
        subTitileZone.frame = CGRect(x: 0, y: zoneLabel.frame.maxY + 2, width: viewZoneTool.frame.width, height: 25)
        
        viewTimeTool.frame = CGRect(x: viewZoneTool.frame.minX - 120, y:  titleTool.frame.maxY + 35, width: 100, height: 50)
        timeLabel.frame = CGRect(x: 0, y: 0, width: self.viewTimeTool.frame.width, height: 20)
        subTitileTime.frame = CGRect(x: 0, y: timeLabel.frame.maxY, width: self.viewTimeTool.frame.width, height: 25)
        
        viewWithCurcles.frame = CGRect(x: viewZoneTool.frame.maxX + 30, y: titleTool.frame.maxY + 33, width: 70, height: 20)
        subTitileCircle.frame = CGRect(x: viewZoneTool.frame.maxX + 20, y: viewWithCurcles.frame.maxY + 5, width: 100, height: 30)
        
        chartView.frame = CGRect(x: 15, y: subTitileCircle.frame.maxY + 20, width: view.frame.width - 30, height: 140)
        
        buySellButton.frame = CGRect(x: view.frame.width / 5, y: chartView.frame.maxY + 20, width: view.frame.width - (view.frame.width / 5 * 2), height: 44)
      
        indicatorView.frame = CGRect(x: 15, y: chartView.frame.maxY + 50, width: view.frame.width - 30, height: 50)
        
        tableView.frame = CGRect(x: 15, y: chartView.frame.maxY + 90, width: view.frame.width - 30, height: 900)
        
        addFavoriteView.frame = CGRect(x: 15, y: view.frame.maxY - 100, width: view.frame.width - 30, height: 50)
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            viewTimeTool.frame = CGRect(x: viewZoneTool.frame.maxX + 30, y:  titleTool.frame.maxY + 35, width: 100, height: 50)
            viewWithCurcles.frame = CGRect(x: viewZoneTool.frame.minX - 120, y: titleTool.frame.maxY + 33, width: 70, height: 20)
            subTitileCircle.frame = CGRect(x: viewZoneTool.frame.minX - 130, y: viewWithCurcles.frame.maxY + 5, width: 100, height: 30)
        }
    }
    
    
    
    @objc func tapStarButton() {
        
        self.navigationItem.rightBarButtonItem?.image = presenter.delegateToolToFavorite(image: (self.navigationItem.rightBarButtonItem?.image)!)
        if self.navigationItem.rightBarButtonItem?.image == UIImage(systemName: "star.fill") {
            self.addFavoriteView.setText(text: self.titleTool.text!.localized())
        } else {
            self.addFavoriteView.deleteText(text: self.addFavoriteView.deleteTextLabel.text!.localized())
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3) {
            self.addFavoriteView.alpha = 1.0
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            UIView.animate(withDuration: 0.5, delay: 0.3) {
                self.addFavoriteView.alpha = 0.0
            }
        })
        
        
//        if self.navigationItem.rightBarButtonItem?.image == UIImage(systemName: "star") {
//            let image = UIImageView(image: UIImage(systemName: "star"))
//            //presenter.delegateToolToFavorite(image: image)
//            self.starImage.image = UIImage(systemName: "star.fill")
//            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
//
//
//
//        } else {
//            let image = UIImageView(image: UIImage(systemName: "star.fill"))
//            //presenter.delegateToolToFavorite(image: image)
//            self.starImage.image = UIImage(systemName: "star")
//            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
//
//        }
        
    }

}


extension ToolViewController: ToolProtocol {
    
    func success(tool: String, arr: [AllDataModel], timeText: String, zone: String, color: [UIColor], btnHeight: CGFloat) {
        self.titleTool.text = tool
        //self.addFavoriteView.setText(text: tool)
        self.indicatorView.frame = CGRect(x: 15, y: chartView.frame.maxY + btnHeight, width: view.frame.width - 30, height: 50)
        self.arr = arr
       
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
            let charts = Charts()
            charts.presenter = self.presenter
            self.chartView = charts.setChart(chart: self.chartView)
        }
        
        if !UserDefault.decodableData(key: UserSettings.favoriteTool).isEmpty {
        //if !FavotiteTools.favoriteArr.isEmpty {
            for i in 0..<UserDefault.decodableData(key: UserSettings.favoriteTool).count {
                let item = UserDefault.decodableData(key: UserSettings.favoriteTool)[i]
               
                if tool == item.title {
                    self.starImage.image = UIImage(systemName: "star.fill")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: starImage.image, style: .plain, target: self, action: #selector(tapStarButton))
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
                }
            }
        }
        
        print("tool success")
        self.timeLabel.text = timeText
        self.zoneLabel.text = zone
        
        let arrColor = [viewWithCurcles.circleFirst, viewWithCurcles.circleSecond, viewWithCurcles.circleThird]
        let arrLeftColor = [indicatorView.leftCirclesView.circleFirst, indicatorView.leftCirclesView.circleSecond, indicatorView.leftCirclesView.circleThird]
        let arrRightColor = [indicatorView.rightCirclesView.circleFirst, indicatorView.rightCirclesView.circleSecond, indicatorView.rightCirclesView.circleThird]
        
        for i in 0..<arrColor.count {
            arrColor[i].backgroundColor = color[i]
            arrColor[i].frame.size = CGSize(width: 20, height: 20)
            arrColor[i].layer.cornerRadius = arrColor[i].frame.width / 2
//            if traitCollection.userInterfaceStyle == .dark {
//                arrColor[i].backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
//            }
        }
        
        if color[0] == .customRatingRed() {
            for i in 0..<arrColor.count {
                arrLeftColor[i].backgroundColor = color[i]
//                if traitCollection.userInterfaceStyle == .dark {
//                    arrLeftColor[i].backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
//                }
            }
        }
        
        if color[0] == .customRatingGreen() {
            for i in 0..<arrColor.count {
                arrRightColor[i].backgroundColor = color[i]
//                if traitCollection.userInterfaceStyle == .dark {
//                    arrRightColor[i].backgroundColor = UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
//                }
            }
        }
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        presenter.imageView = self.imageView
    }
}

extension ToolViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.arrIndicator?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IndicatorViewCell.identifier, for: indexPath) as! IndicatorViewCell
        cell.selectionStyle = .none
        let color = presenter.processingColorRating(arr: presenter.arrIndicator![indexPath.row])
        
        cell.nameIndicator.text = presenter.nameIndicator[indexPath.row].uppercased()
        
        let arrLeftColor = [cell.leftCirclesView.circleFirst, cell.leftCirclesView.circleSecond, cell.leftCirclesView.circleThird]
        let arrRightColor = [cell.rightCirclesView.circleFirst, cell.rightCirclesView.circleSecond, cell.rightCirclesView.circleThird]
        
        for i in 0..<arrLeftColor.count {
            if color[i] == .customRatingRed() {
                arrLeftColor[i].backgroundColor = color[i]
            }
            
            if color[i] == .customRatingGreen() {
                arrRightColor[i].backgroundColor = color[i]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
