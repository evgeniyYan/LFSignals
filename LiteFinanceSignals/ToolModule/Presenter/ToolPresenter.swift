//
//  ToolPresenter.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit
import Charts

struct ChartData {
    var date: String
    var open: Double
    var high: Double
    var low: Double
    var close: Double
}

protocol ToolProtocol: AnyObject {
    func success(tool: String, arr: [AllDataModel], timeText: String, zone: String, color: [UIColor], btnHeight: CGFloat)
    var arr: [AllDataModel] {get set}
    var buySellButton: UIButton! {get set}
    var indicators: [ToolIndicator]? {get set}
    var imageView: ImageView! {get set}
}

protocol ToolPresenterProtocol: AnyObject {
    init(customBar: CustomBarProtocol, network: NetworkProtocol, view: ToolProtocol, tool: String?, router: RouterProtocol, arr: [AllDataModel], signals: SignalsPresenterProtocol)
    func getTool()
    var customBar: CustomBarProtocol! {get set}
    var arr: [AllDataModel] {get set}
    var presenterSignals: SignalsPresenterProtocol! {get set}
    func getData(arr: [AllDataModel]) -> String
    var allIndicator: [ToolIndicator]? {get set}
    var arrIndicator: [Int]? {get set}
    var nameIndicator: [String] {get set}
    func processingColorRating(arr: Int?) -> [UIColor]
    var imageView: ImageView! {get set}
    func delegateToolToFavorite(image: UIImage) -> UIImage
    var dataChart: [Any]! {get set}
    var date: [Double]! {get set}
    var open: [Float64]! {get set}
    var high: [Float64]! {get set}
    var low: [Float64]! {get set}
    var close: [Float64]! {get set}
    var chartModelArr: [ChartData]! {get set}
    var chartView: CandleStickChartView! {get set}
    var freeArea: CGFloat! {get set}
}

class ToolPresenter: ToolPresenterProtocol {
    weak var view: ToolProtocol?
    var network: NetworkProtocol!
    var tool: String?
    var router: RouterProtocol!
    var customBar: CustomBarProtocol!
    var arr = [AllDataModel]()
    var presenterSignals: SignalsPresenterProtocol!
    var time = ""
    var buySellButton: UIButton! = UIButton()
    var allIndicator: [ToolIndicator]?
    var arrIndicator: [Int]?
    var nameIndicator: [String] = ["ma10", "ma20", "ma50", "ma100", "macd", "bbands", "ichimoku", "stochastic", "williams", "zigzag"]
    var imageView: ImageView!
    var dataChart: [Any]!
    var date: [Double]! = [Double]()
    var open: [Double]! = [Double]()
    var high: [Double]! = [Double]()
    var low: [Double]! = [Double]()
    var close: [Double]! = [Double]()
    var chartModelArr: [ChartData]!  = [ChartData]()
    var chartView: CandleStickChartView! = CandleStickChartView()
    var freeArea: CGFloat! = 44
    
    required init(customBar: CustomBarProtocol, network: NetworkProtocol, view: ToolProtocol, tool: String?, router: RouterProtocol, arr: [AllDataModel], signals: SignalsPresenterProtocol) {
        self.view = view
        self.network = network
        self.tool = tool
        self.router = router
        self.customBar = customBar
        self.arr = arr
        self.presenterSignals = signals
        self.time = getData(arr: self.arr)
        getData()
        getChartData(tool: tool!, range: customBar.titleRangeButton.text!)
    }
    
    func getData() {
        self.network.parseIndicatorsTool(tool: self.tool!) { result in
            switch result {
            case .success(let indicators):
                self.allIndicator = indicators
                
                DispatchQueue.main.async {
                    self.allIndicator = indicators!.filter({$0.timeframe == self.customBar.titleRangeButton.text!})
                    self.arrIndicator = self.getIndicators(indicator: self.allIndicator![0].indicators)
                    self.getTool()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getChartData(tool: String, range: String) {
        var newTool = ""
        let arrString = tool.components(separatedBy: "#")
        
        if arrString.count == 1 {
            newTool = arrString[0]
        } else {
            newTool = "%23\(arrString[1])"
        }
        
       
        self.network.parseChartData(tool: newTool, range: range) { result in
            switch result {
            case .success(let data):
                self.dataChart = data
                self.convertDataChart(data: data!)
               
            case .failure(let error):
                self.dataChart = [Float64]()
                print(error.localizedDescription)
            }
        }
    }
    
    func createChartsView() {
        let getChart = Charts()
        getChart.presenter = self
        self.chartView = getChart.setChart(chart: self.chartView)
        
    }
    
    func convertDataChart(data: [ChatrModel]?) {
        self.chartModelArr = [ChartData]()
        var timeString = ""
        
        for i in 0..<data!.count {
            let arr = data![i]

            self.open.append(arr.open)
            self.high.append(arr.high)
            self.low.append(arr.low)
            self.close.append(arr.close)
            let time = Date(timeIntervalSince1970: TimeInterval(arr.time))
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "HH:MM"
            dateFormat.string(from: time)
            timeString = dateFormat.string(from: time)
            
            let arrModel = ChartData(date: timeString, open: arr.open, high: arr.high, low: arr.low, close: arr.close)
            self.chartModelArr.append(arrModel)
        }
       
    }
    
    func getIndicators(indicator: Indicator) -> [Int] {
        var arr = [Int]()
        arr.append(indicator.ma10)
        arr.append(indicator.ma20)
        arr.append(indicator.ma50)
        arr.append(indicator.ma100)
        arr.append(indicator.macd)
        arr.append(indicator.bbands)
        arr.append(indicator.ichimoku)
        arr.append(indicator.stochastic)
        arr.append(indicator.williams)
        arr.append(indicator.zigzag)
        
        return arr
    }
    
    func getTool() {
        //createChartsView()
        let color = presenterSignals.processingColorRating(arr: self.arr, name: self.tool!, range: self.customBar.titleRangeButton.text!)
        
        
       
        if color[0] == .customRatingRed() {
            self.buySellButton.backgroundColor = .customRatingRed()
            self.buySellButton.setTitle("Продать".localized() + " " + self.tool!, for: .normal)
            self.view?.success(tool: self.tool!, arr: self.arr, timeText: self.time, zone: self.customBar.titleRangeButton.text!, color: color, btnHeight: 94)
            
        } else if color[0] == .customRatingGreen() {
            self.buySellButton.backgroundColor = .customRatingGreen()
            self.buySellButton.setTitle("Купить".localized() + " " + self.tool!, for: .normal)
            self.view?.success(tool: self.tool!, arr: self.arr, timeText: self.time, zone: self.customBar.titleRangeButton.text!, color: color, btnHeight: 94)
            
        } else {
            self.buySellButton.isHidden = true
            self.buySellButton.frame.size.height = 1
            self.view?.buySellButton.frame.size.height = self.buySellButton.frame.size.height
            self.view?.buySellButton.removeFromSuperview()
            self.view?.success(tool: self.tool!, arr: self.arr, timeText: self.time, zone: self.customBar.titleRangeButton.text!, color: color, btnHeight: 34)
        }
        
        self.view?.buySellButton.setTitle(self.buySellButton.titleLabel?.text, for: .normal)
        self.view?.buySellButton.backgroundColor = self.buySellButton.backgroundColor
        
        switch self.allIndicator![0].type {
        case 1:
            let firstCur = GetCurrencyName().getCurrencyName(title: self.tool!)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: self.tool!)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur).svg"
            let urlQuote = "https://api.litemarkets.com/images/signals/day/\(secondCur).svg"
            
            DispatchQueue.main.async {
                self.imageView.imageFirstTool.sd_setImage(with: URL(string: urlBase))
                self.imageView.imageSecondTool.sd_setImage(with: URL(string: urlQuote))
                self.imageView.alongTool.isHidden = true
            }
        case 2:
            let firstCur = GetCurrencyName().getCurrencyName(title: self.tool!)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: self.tool!)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur).svg"
            let urlQuote = "https://api.litemarkets.com/images/signals/day/\(secondCur).svg"
            
            DispatchQueue.main.async {
                self.imageView.imageFirstTool.sd_setImage(with: URL(string: urlBase))
                self.imageView.imageSecondTool.sd_setImage(with: URL(string: urlQuote))
                self.imageView.alongTool.isHidden = true
            }
        case 3:
            let firstCur = GetCurrencyName().getCurrencyName(title: self.tool!)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: self.tool!)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur)\(secondCur).svg"
            
            DispatchQueue.main.async {
                self.imageView.alongTool.sd_setImage(with: URL(string: urlBase))
                self.imageView.imageFirstTool.isHidden = true
                self.imageView.imageSecondTool.isHidden = true
            }
        case 4:
            let icon = GetCurrencyName().deleteSymbol(text: self.tool!)
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(icon).svg"
            
            DispatchQueue.main.async {
                self.imageView.alongTool.sd_setImage(with: URL(string: urlBase))
                self.imageView.imageFirstTool.isHidden = true
                self.imageView.imageSecondTool.isHidden = true
            }
        case 5:
            let firstCur = GetCurrencyName().getCurrencyName(title: self.tool!)[0]
            let secondCur = GetCurrencyName().getCurrencyName(title: self.tool!)[1]
            
            let urlBase = "https://api.litemarkets.com/images/signals/day/\(firstCur)\(secondCur).svg"
            
            DispatchQueue.main.async {
                self.imageView.alongTool.sd_setImage(with: URL(string: urlBase))
                self.imageView.imageFirstTool.isHidden = true
                self.imageView.imageSecondTool.isHidden = true
            }
        default:
            print("error image view")
        }
        self.view?.imageView = self.imageView
        
    }
    
    func getData(arr: [AllDataModel]) -> String {
        var timeString = ""
        for i in 0..<arr.count {
            let arrInside = arr[i]
            if arrInside.timeFrame == self.customBar.titleRangeButton.text! {
                let Float64 = arrInside.updateTime
                //let time = Date(timeIntervalSince1970: TimeInterval(Float64))
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "HH:MM"
                dateFormat.string(from: Float64)
                timeString = dateFormat.string(from: Float64)
            }
        }
        return timeString
    }
    
    func processingColorRating(arr: Int?) -> [UIColor] {
        var timeString = [UIColor]()
        
        switch arr! {
        case -3:
            timeString = [.customRatingRed(), .customRatingRed(), .customRatingRed()]
        case -2:
            timeString = [.customRatingRed(), .customRatingRed(), .customRatingWait()]
        case -1:
            timeString = [.customRatingRed(), .customRatingWait(), .customRatingWait()]
        case 0:
            timeString = [.customRatingWait(), .customRatingWait(), .customRatingWait()]
        case 1:
            timeString = [.customRatingGreen(), .customRatingWait(), .customRatingWait()]
        case 2:
            timeString = [.customRatingGreen(),.customRatingGreen(), .customRatingWait()]
        case 3:
            timeString = [.customRatingGreen(), .customRatingGreen(), .customRatingGreen()]
        default:
            print("error rating color")
        }
        return timeString
    }
    
    
    func delegateToolToFavorite(image: UIImage) -> UIImage {
        var newImage = UIImage()
        if image == UIImage(systemName: "star.fill") {
            var new = [AllDataModel]()
            for i in 0..<FavotiteTools.favoriteArr.count {
                let saveTool = FavotiteTools.favoriteArr[i]
                for n in 0..<self.arr.count {
                    let tool = self.arr[n]
                    if saveTool.title == tool.title {
                        new = FavotiteTools.favoriteArr.filter({ tool in
                            let mass = tool
                            return mass.title != saveTool.title
                        })
                    }
                }
            }
            FavotiteTools.favoriteArr = new
            UserDefault.encodableData(data: new, key: UserSettings.favoriteTool)
            //UserDefaults.standard.set(new, forKey: UserSettings.favoriteTool)
            newImage = UIImage(systemName: "star")!
        }
        else {
            for i in 0..<self.arr.count {
                FavotiteTools.favoriteArr.append(self.arr[i])
            }
           
            UserDefault.encodableData(data: FavotiteTools.favoriteArr, key: UserSettings.favoriteTool)
            
            newImage = UIImage(systemName: "star.fill")!
        }
        //let _ = router.assemblyBuilder?.createFavoriteViewController(tools: FavotiteTools.favoriteArr, router: self.router, timeZone: self.router.favoriteTimeZone)
        router.delegateFavoriteTool(tools: FavotiteTools.favoriteArr, timeZone: self.router.favoriteTimeZone)
        //router.initialVCController()
        return newImage
        
    }
}

