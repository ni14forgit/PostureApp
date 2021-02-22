//
//  TrackViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/22/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(ActivityTableViewCell.nib(), forCellReuseIdentifier: ActivityTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello World"
//        return cell
        let customCell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifer, for: indexPath) as! ActivityTableViewCell
        customCell.configure(with: "Custom Cell", imageName: "gear")
        return customCell
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
