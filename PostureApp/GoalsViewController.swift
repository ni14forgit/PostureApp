//
//  GoalsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 3/1/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit
import RealmSwift

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var minutesTracked: UILabel?
    @IBOutlet weak var degreesOfVariation: UILabel?
    @IBOutlet weak var minutesImage: UIImageView?
    @IBOutlet weak var degreesImage: UIImageView?
    @IBOutlet weak var badgeMinutes: UILabel?
    @IBOutlet weak var badgeDegrees: UILabel?
    
    var hashMapOfMinutesMeasured = [String : Int]()
    var hashMapOfAnglesMeasured = [String: [Int]]()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let resultsMeasurements = realm.objects(MeasurementTwo.self)
        
        let resultsNumMinutes = realm.objects(NumMinutes.self)
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalformattedDate = formatter.string(from: todayDate)
        let dateKeyFinal = String(finalformattedDate.prefix(10))
//        var minutesMeasured = 0
        

        
        // calculating the number of minutes measured today
//        for result in resultsNumMinutes {
//            if String(result.timestamp.prefix(10)) == dateKeyFinal {
//                minutesMeasured += result.minutes
//            }
//        }
//        print("measured minutes for today: " + String(minutesMeasured))
        
        // calculating badge count for minutes measured today
        
        for result in resultsNumMinutes {
            if hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] != nil {
                let pastMinutes = hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))]
                print("at some point this should be 6")
                print(pastMinutes)
                hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] = hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] ?? 1 + result.minutes
            } else {
                hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] = result.minutes
            }
        }
        
        var minutesBadgeCountFinal = 0
        for (_, minutesCompounded) in hashMapOfMinutesMeasured {
            if minutesCompounded >= 30 {
                minutesBadgeCountFinal += 1;
            }
        }
        
        print("this many days with 30 minutes measuring"  + String(minutesBadgeCountFinal) + "\n")
        badgeMinutes?.text=String(minutesBadgeCountFinal)
        
        
        let todaydate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: todaydate)
        print(formattedDate)
        
        minutesTracked?.text = String(hashMapOfMinutesMeasured[String(formattedDate.prefix(10))] ?? -4)
        
        if hashMapOfMinutesMeasured[String(formattedDate.prefix(10))] != nil {
            print("was able to retrieve today's minutes from hashmap")
        }
        
        
        
        
        // calculating the average deviation today
//        var measurementArray = [Int]()
//        for result in resultsMeasurements {
//            if String(result.timestamp.prefix(10)) == dateKeyFinal {
//                measurementArray.append(result.measurement)
//            }
//        }
//
//        if (measurementArray.count > 0) {
//            let sumArray = measurementArray.reduce(0, +)
//            let avgArrayValue = Double(sumArray / measurementArray.count)
//
//            if abs(avgArrayValue) < 1 {
//                print("AVERAGE DEVIATION TODAY WAS 0 BADGE! \n")
//            }
//        }
        
//        let constantEmptyList = [Int]()
        
        for result in resultsMeasurements {
            if hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] != nil {
                var pastAnglesList = (hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))]) ?? [Int]()
                pastAnglesList.append(result.measurement)
                hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] = pastAnglesList
                
            } else {
                var emptyInitialList = [Int]()
                emptyInitialList.append(result.measurement)
                hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] =  emptyInitialList
            }
        }
        
        var averageZeroBadgeCountFinal = 0
        for (_, measurementHashMapList) in hashMapOfAnglesMeasured {
            let sumArray = measurementHashMapList.reduce(0, +)
            let avgArrayValue = Double(sumArray / measurementHashMapList.count)
            if abs(avgArrayValue) < 1 {
                averageZeroBadgeCountFinal += 1
            }
        }
        
        print("this many days with avergae 0 measured"  + String(averageZeroBadgeCountFinal) + "\n")
        badgeDegrees?.text=String(averageZeroBadgeCountFinal)
        
       
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        
        let resultsMeasurements = realm.objects(MeasurementTwo.self)
        
        let resultsNumMinutes = realm.objects(NumMinutes.self)
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalformattedDate = formatter.string(from: todayDate)
        let dateKeyFinal = String(finalformattedDate.prefix(10))
//        var minutesMeasured = 0
        

        
        // calculating the number of minutes measured today
//        for result in resultsNumMinutes {
//            if String(result.timestamp.prefix(10)) == dateKeyFinal {
//                minutesMeasured += result.minutes
//            }
//        }
//        print("measured minutes for today: " + String(minutesMeasured))
        
        // calculating badge count for minutes measured today
        
        for result in resultsNumMinutes {
            print("yo mama")
            print(String(result.timestamp.prefix(10)))
            print("result.minutes")
            print(result.minutes)
                
            if hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] != nil {
                let pastMinutes = hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))]
                print("wack if somepoint not 6")
                print(pastMinutes!)
                hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] = hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))]! + result.minutes
                print("already happened")
                print(hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] ?? -32)
            } else {
                hashMapOfMinutesMeasured[String(result.timestamp.prefix(10))] = result.minutes
            }
        }
        
        var minutesBadgeCountFinal = 0
        for (_, minutesCompounded) in hashMapOfMinutesMeasured {
            print(minutesCompounded)
            if minutesCompounded >= 30 {
                minutesBadgeCountFinal += 1;
            }
        }
        
        print("this many days with 30 minutes measuring"  + String(minutesBadgeCountFinal) + "\n")
        badgeMinutes?.text=String(minutesBadgeCountFinal)
        
        
        let todaydate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: todaydate)
        print(formattedDate)
        
        minutesTracked?.text = String(hashMapOfMinutesMeasured[String(formattedDate.prefix(10))] ?? -4)
        
        if hashMapOfMinutesMeasured[String(formattedDate.prefix(10))] != nil {
            print("was able to retrieve today's minutes from hashmap")
            print(String(hashMapOfMinutesMeasured[String(formattedDate.prefix(10))] ?? -6))
        }
        
        
        
        
        // calculating the average deviation today
//        var measurementArray = [Int]()
//        for result in resultsMeasurements {
//            if String(result.timestamp.prefix(10)) == dateKeyFinal {
//                measurementArray.append(result.measurement)
//            }
//        }
//
//        if (measurementArray.count > 0) {
//            let sumArray = measurementArray.reduce(0, +)
//            let avgArrayValue = Double(sumArray / measurementArray.count)
//
//            if abs(avgArrayValue) < 1 {
//                print("AVERAGE DEVIATION TODAY WAS 0 BADGE! \n")
//            }
//        }
        
//        let constantEmptyList = [Int]()
        
        for result in resultsMeasurements {
            if hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] != nil {
                var pastAnglesList = (hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))]) ?? [Int]()
                pastAnglesList.append(result.measurement)
                hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] = pastAnglesList
                
            } else {
                var emptyInitialList = [Int]()
                emptyInitialList.append(result.measurement)
                hashMapOfAnglesMeasured[String(result.timestamp.prefix(10))] =  emptyInitialList
            }
        }
        
        var averageZeroBadgeCountFinal = 0
        for (_, measurementHashMapList) in hashMapOfAnglesMeasured {
            let sumArray = measurementHashMapList.reduce(0, +)
            let avgArrayValue = Double(sumArray / measurementHashMapList.count)
            if abs(avgArrayValue) < 1 {
                averageZeroBadgeCountFinal += 1
            }
        }
        
        print("this many days with avergae 0 measured"  + String(averageZeroBadgeCountFinal) + "\n")
        badgeDegrees?.text=String(averageZeroBadgeCountFinal)
        
       
        
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
