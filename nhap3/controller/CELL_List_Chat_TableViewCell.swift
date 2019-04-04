//
//  CELL_List_Chat_TableViewCell.swift
//  nhap3
//
//  Created by vuminhtam on 4/3/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit

class CELL_List_Chat_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
