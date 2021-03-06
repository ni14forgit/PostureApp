//
//  ActiveResultsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/28/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import RealmSwift
import UIKit

class ActiveResultsViewController: UIViewController {
    
    @IBOutlet weak var LegImage: UIImageView?
    @IBOutlet weak var BackImage: UIImageView?
    @IBOutlet weak var LegValue: UILabel?
    @IBOutlet weak var BackValue: UILabel?
    @IBOutlet weak var reccommendationValue: UILabel?
    
    let realm = try! Realm()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        leftArrows?.image = UIImage(named: leftImage)
//        rightArrows?.image = UIImage(named: rightImage)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        
        let measurement = MeasurementTwo()
        measurement.timestamp = formattedDate
        measurement.measurement = 5;
        realm.beginWrite()
        realm.add(measurement)
        try! realm.commitWrite()
//        try! realm.write {
//            realm.add(measurement)
//        }
//

        // Do any additional setup after loading the view.
    }
    
    
    func retrieve() {
        let pastMeasurements = realm.objects(MeasurementTwo.self)
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

class MeasurementTwo: Object {
    
    @objc dynamic var measurement = 0
    @objc dynamic var timestamp = ""
    
    
    
}
