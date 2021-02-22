//
//  ActivityTableViewCell.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/22/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    public func configure(with title: String, imageName: String) {
        activityTitle.text = title
        activityImageView.image = UIImage(systemName: imageName)
        
    }
    
    static let identifer = "ActivityTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ActivityTableViewCell", bundle: nil)
    }
    
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var activityTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
