//
//  CustomTableCell.swift
//  My Time
//
//  Created by Nazeli Hagen on 11/25/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    @IBOutlet weak var myText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Disables ability to select an event or to do
    override func setSelected(_ selected: Bool, animated: Bool) {}

}
