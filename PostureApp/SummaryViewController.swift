//
//  SummaryViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 3/17/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class SummaryViewController: UIViewController, ChartViewDelegate {
    
    var scatterChart = ScatterChartView()
    
    var activity: String?
    
    @IBOutlet weak var titlePage: UILabel?
//    let realm = try! Realm()
    
//    var setOfPastSevenDays = Set<String>()
    var hashMapOfPastSevenDays = [String : Int]()
    var collectedMeasurements = [[Int]]()
    var finalMeasurements = [Double]()
    var lastSevenDaysFormatter = [String]()
    
    let errorRangeForSitting = [1,3]
    let errorRangeForStanding = [1,3]
    let errorRangeForSquatting = [1,3]
    var errorRange = [Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePage?.text = activity;
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        scatterChart.delegate = self
        
        for _ in 0...6 {
            collectedMeasurements.append([])
        }
        
        
        
        let realm = try! Realm()
        let str  = "yyyy-MM-dd HH:mm:ss"
//        let monthDayOnlyRange = desc.startIndex.advancedBy(5)..<desc.startIndex.advancedBy(10)
        let start = str.index(str.startIndex, offsetBy: 5)
        let end = str.index(str.endIndex, offsetBy: -9)
        let range = start..<end
        
        print("hello")
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        
        for index in 0...6 {
//            someSet.insert("c")
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -index, to: todayDate)!
            let finalformattedDate = formatter.string(from: modifiedDate)
            hashMapOfPastSevenDays[String(finalformattedDate.prefix(10))] = 6 - index;
            let newStr = String(finalformattedDate[range]);
            lastSevenDaysFormatter.append(newStr)
        }
        
        print(hashMapOfPastSevenDays)
        
        lastSevenDaysFormatter.reverse()
        
        let results = realm.objects(MeasurementTwo.self)
        
        print("about to nav result")

        for result in results {
            print("results??")
            print(result.timestamp)
            print(String(result.timestamp[range]))
            if hashMapOfPastSevenDays[String(result.timestamp.prefix(10))] != nil {
                print("match!!")
                print(hashMapOfPastSevenDays[result.timestamp])
                print("\n")
                collectedMeasurements[hashMapOfPastSevenDays[String(result.timestamp.prefix(10))] ?? 0].append(result.measurement)
            }
        }
        
        print("collectedmeasurements")
        print(collectedMeasurements)
        
        var counter = 0;
        for measurement in collectedMeasurements {
            
            
            if (measurement.count == 0) {
                
                
                print(counter)
                
                lastSevenDaysFormatter.remove(at: counter)
                
            } else {
                
                let sumArray = measurement.reduce(0, +)
                let avgArrayValue = Double(sumArray / measurement.count)
                finalMeasurements.append(avgArrayValue);
                counter += 1;
            }
            
        }
        print("final measurements")
        print(finalMeasurements)
    
        
        if activity == "Sitting" {
            print("sitting")
            errorRange=errorRangeForSitting
        } else if activity == "Standing" {
            print("Standing")
            errorRange=errorRangeForStanding
        } else if activity == "Squatting" {
            print("Squatting")
            errorRange=errorRangeForSquatting
        } else {
            print("did not work")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scatterChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        scatterChart.center = view.center
        
        view.addSubview(scatterChart)
        var entries = [ChartDataEntry]()
        
        
            scatterChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:lastSevenDaysFormatter)
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
        let tempData = finalMeasurements
        // arrays with circle color definitions

        for i in 0..<tempData.count {
//            let red   = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue  = Double(arc4random_uniform(256))
            
//            41, 112, 227
            
            let blue = UIColor(red: CGFloat(Double(41)/255), green: CGFloat(Double(112)/255), blue: CGFloat(Double(227)/255), alpha: 1)
            
            let red = UIColor(red: CGFloat(Double(227)/255), green: CGFloat(Double(32)/255), blue: CGFloat(Double(71)/255), alpha: 1)
            
            let light_red = UIColor(red: CGFloat(Double(227)/255), green: CGFloat(Double(32)/255), blue: CGFloat(Double(71)/255), alpha: 0.5)
//            227, 32, 71
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            if (abs(tempData[i]) <= Double(errorRange[0])) {
                circleColors.append(blue)
            } else if (abs(tempData[i]) <= Double(errorRange[0])) {
                circleColors.append(light_red)
            } else {
                circleColors.append(red)
            }
            
        }
//        scatterChart.yAxis.drawAxisLineEnabled = false
       
        
        for x in 0..<tempData.count{
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
