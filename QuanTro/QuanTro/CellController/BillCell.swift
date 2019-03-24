//
//  BillCell.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/7/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {

    
    @IBOutlet weak var nameRoom: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.cornerRadius = 3
        button.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func collecting(_ sender: Any) {
    }
    
    
}
