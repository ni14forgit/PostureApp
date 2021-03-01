//
//  GoalsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 3/1/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var minutesTracked: UILabel?
    @IBOutlet weak var degreesOfVariation: UILabel?
    @IBOutlet weak var minutesImage: UIImageView?
    @IBOutlet weak var degreesImage: UIImageView?
    @IBOutlet weak var badgeMinutes: UILabel?
    @IBOutlet weak var badgeDegrees: UILabel?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
