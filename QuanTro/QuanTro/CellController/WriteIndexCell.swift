//
//  WriteIndexCell.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/15/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class WriteIndexCell: UITableViewCell {

    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var WriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        historyButton.layer.cornerRadius = 3
        historyButton.layer.shadowOpacity = 0.2
        WriteButton.layer.cornerRadius = 3
        WriteButton.layer.shadowOpacity = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
