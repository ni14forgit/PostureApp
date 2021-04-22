//
//  TrackViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/22/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit


//class Example {
//    var exampleField: String?
//
//    init(prField:String){
//        self.exampleField = prField
//    }
//}

class TrackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var table: UITableView!
    
//     var products = [Example]()
    var products = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(ActivityTableViewCell.nib(), forCellReuseIdentifier: ActivityTableViewCell.identifer)
        table.delegate = self
        table.dataSource = self
        
        products.append("Sitting")
        products.append("Standing")
        products.append("Squatting")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello World"
//        return cell
        let customCell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifer, for: indexPath) as! ActivityTableViewCell
        customCell.configure(with: products[indexPath.row], imageName:products[indexPath.row] )
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ResultsViewController()
//        navigationController?.pushViewController(vc, animated: true)
        performSegue(withIdentifier:"showAngleResults" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ResultsViewController {
            destination.activity = products[(table.indexPathForSelectedRow?.row)!]
        }
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
