//
//  HistoryIndexCell.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/27/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class HistoryIndexCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var electricIndex: UILabel!
    @IBOutlet weak var waterIndex: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
