//
//  ActiveResultsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/28/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit

class ActiveResultsViewController: UIViewController {
    
    var leftImage = ""
    var rightImage = ""
    
    @IBOutlet weak var leftArrows: UIImageView?
    @IBOutlet weak var rightArrows: UIImageView?
    @IBOutlet weak var leftValue: UILabel?
    @IBOutlet weak var rightValue: UILabel?
    @IBOutlet weak var reccommendationValue: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        leftArrows?.image = UIImage(named: leftImage)
        rightArrows?.image = UIImage(named: rightImage)

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
