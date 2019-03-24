//
//  HistoryIndexController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/27/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class HistoryIndexController: UITableViewController {

    var room:Room!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        tableView.rowHeight = 150
        
        self.title = room.name
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return room.listIndex.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryIndexCell
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        cell.dateLabel.text = dateFormatter.string(from: room.listIndex[indexPath.row].date)
        cell.electricIndex.text = String(room.listIndex[indexPath.row].electricIndex)
        cell.waterIndex.text = String(room.listIndex[indexPath.row].waterIndex)
        
        return cell
    }

}
