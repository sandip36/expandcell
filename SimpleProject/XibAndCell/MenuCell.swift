//
//  MenuCell.swift
//  SimpleProject
//
//  Created by applicationsupport on 15/10/17.
//  Copyright © 2017 SandipJadhav. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cid: UILabel!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
