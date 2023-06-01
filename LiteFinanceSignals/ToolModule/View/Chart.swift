//
//  Chart.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation
import Charts

class Charts: ChartViewDelegate {
    
    
    var colorChart = UIColor()
    var presenter: ToolPresenterProtocol!
    var entryes = [Float]()
    
    func setChart(chart: CandleStickChartView) -> CandleStickChartView {
        
        chart.chartDescription.enabled = false
        
        chart.dragEnabled = false
        chart.setScaleEnabled(true)
        chart.maxVisibleCount = 5
        chart.pinchZoomEnabled = true
        
        chart.legend.drawInside = false
        chart.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        if LocaleLayout.getLocale() == "fa" || LocaleLayout.getLocale() == "ar" {
            chart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
            chart.leftAxis.spaceTop = 0.3
            chart.leftAxis.spaceBottom = 0.3
            chart.leftAxis.axisMinimum = 0
            chart.rightAxis.enabled = false
        } else {
            chart.rightAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
            chart.rightAxis.spaceTop = 0.3
            chart.rightAxis.spaceBottom = 0.3
            chart.rightAxis.axisMinimum = 0
            chart.leftAxis.enabled = false
        }
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.animate(xAxisDuration: 1.0)
        
        
    
        var entries = [CandleChartDataEntry]()
        
        let count = presenter.chartModelArr.count
        
        for i in 0..<count {
            let item = presenter.chartModelArr[i]
            
            entries.append(CandleChartDataEntry(x: Double(i), shadowH: item.high, shadowL: item.low, open: item.open, close: item.close))
            
        }
        let set1 = CandleChartDataSet(entries: entries)
        set1.axisDependency = .left
        set1.shadowColor = .black
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.decreasingColor = .customRatingRed()
        set1.decreasingFilled = true
        set1.increasingColor = .customRatingGreen()
        set1.increasingFilled = true
        set1.neutralColor = .darkGray
        set1.showCandleBar = true
        set1.shadowWidth = 1
        set1.formLineWidth = 3
        
        let data = CandleChartData(dataSet: set1)
        data.setDrawValues(false)
        chart.data = data
        return chart
   }
    
}
