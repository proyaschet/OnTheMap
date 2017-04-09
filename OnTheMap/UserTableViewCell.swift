//
//  UserTableViewCell.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 08/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var pimage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    
    func uiForCell(user : Student)
    {
        pimage.image = UIImage(named: "icon_pin")
        nameLabel.text = user.fullName
        urlLabel.text = user.mediaURL
    }
}
