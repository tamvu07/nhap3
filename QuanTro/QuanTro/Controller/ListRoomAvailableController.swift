//
//  ListRoomAvailableController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/3/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class ListRoomAvailableController: UITableViewController {

    var listRoomAvailable:[Room]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        tableView.register(RoomCell.self,
                           forCellReuseIdentifier: "RoomCell")
        let xib = UINib(nibName: "RoomCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "RoomCell")
        tableView.rowHeight = 140
       
        self.title = "Danh sách phòng trống"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        listRoomAvailable = ListOfMotel.shared.getListRoomAvailable()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listRoomAvailable.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        cell.imageV.image = UIImage(named: "opened")
        cell.name.text = listRoomAvailable[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var i = 0
        for room in ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex].listRoom!{
            if room.id == listRoomAvailable[indexPath.row].id{
                break
            }
            i += 1
        }
        ListOfMotel.shared.currentRoomIndex = i
        performSegue(withIdentifier: "CreateContract", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as! CreateContractController
        let indexPath = tableView.indexPath(for: sender as! RoomCell)
        newVC.room = listRoomAvailable[(indexPath?.row)!]
    }
    
    
}
