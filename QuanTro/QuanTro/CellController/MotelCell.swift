//
//  MotelCell.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/25/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class MotelCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numOfRooms: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
