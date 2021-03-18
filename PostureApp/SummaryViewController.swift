//
//  SummaryViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 3/17/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit
import Charts

class SummaryViewController: UIViewController, ChartViewDelegate {
    
    var scatterChart = ScatterChartView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        scatterChart.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scatterChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        scatterChart.center = view.center
        
        view.addSubview(scatterChart)
        var entries = [ChartDataEntry]()
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"]
            scatterChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        scatterChart.xAxis.granularity = 1
        scatterChart.xAxis.labelCount = 7
        scatterChart.xAxis.drawAxisLineEnabled = false
        scatterChart.leftAxis.drawAxisLineEnabled = false
        scatterChart.rightAxis.drawGridLinesEnabled = false
        scatterChart.leftAxis.drawGridLinesEnabled = false
        scatterChart.xAxis.gridColor = .clear
        scatterChart.leftAxis.gridColor = .clear
        scatterChart.rightAxis.gridColor = .clear
        scatterChart.rightAxis.enabled = false
        scatterChart.legend.enabled = false
        
        var circleColors: [NSUIColor] = []
        let tempData = [1,-3,-4,3,2,4,5,-2,0,-1]
        // arrays with circle color definitions

        for i in 0..<10 {
//            let red   = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue  = Double(arc4random_uniform(256))
            
//            41, 112, 227
            
            let blue = UIColor(red: CGFloat(Double(41)/255), green: CGFloat(Double(112)/255), blue: CGFloat(Double(227)/255), alpha: 1)
            
            let red = UIColor(red: CGFloat(Double(227)/255), green: CGFloat(Double(32)/255), blue: CGFloat(Double(71)/255), alpha: 1)
            
            let light_red = UIColor(red: CGFloat(Double(227)/255), green: CGFloat(Double(32)/255), blue: CGFloat(Double(71)/255), alpha: 0.5)
//            227, 32, 71
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            if (abs(tempData[i]) <= 1) {
                circleColors.append(blue)
            } else if (abs(tempData[i]) <= 2) {
                circleColors.append(light_red)
            } else {
                circleColors.append(red)
            }
            
        }
//        scatterChart.yAxis.drawAxisLineEnabled = false
       
        
        for x in 0..<10{
            entries.append(ChartDataEntry(x: Double(x), y:Double(tempData[x])))
        }
        
        
        let set = ScatterChartDataSet(entries: entries)
        let circle = ScatterChartDataSet.Shape.circle
        set.setScatterShape(circle)
        set.scatterShapeSize = CGFloat(20.0)
        
//        scatterChart.largeContentTitle = "Posture Progress"
        scatterChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    
//        set.colors = ChartColorTemplates.joyful()
        set.colors = circleColors
        let data = ScatterChartData(dataSet: set)
        scatterChart.data = data
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
