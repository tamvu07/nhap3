//
//  VehicleCell.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 1/1/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var nameRoomer: UILabel!
    @IBOutlet weak var licensePlate: UILabel!
    @IBOutlet weak var sortVehicle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageV.layer.borderWidth = 1
        imageV.layer.borderColor = UIColor(displayP3Red: 80, green: 214, blue: 46, alpha: 0.9).cgColor
        imageV.layer.masksToBounds = false
        imageV.layer.cornerRadius = imageV.bounds.size.height / 2
        imageV.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
