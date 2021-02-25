//
//  ResultsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/25/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var labelOne: UILabel?
    @IBOutlet weak var labelTwo: UILabel?
    @IBOutlet weak var trackButton: UIButton?
    
    
    var activity: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelOne?.text = activity
        labelTwo?.text = "label2"
        
        trackButton?.layer.cornerRadius = 5
        trackButton?.clipsToBounds = true

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
