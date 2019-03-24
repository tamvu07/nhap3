//
//  ListRoomController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/30/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class ListRoomController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    var listRoom:[Room]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightButton()
        listRoom = ListOfMotel.shared.getListRoom()
        tableView.register(RoomCell.self,
                           forCellReuseIdentifier: "RoomCell")
        let xib = UINib(nibName: "RoomCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "RoomCell")
        tableView.rowHeight = 110
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listRoom = ListOfMotel.shared.getListRoom()
        tableView.reloadData()
    }
    

    //MARK: Datasource and Delegate of tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoom.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
        
        let cellSize = tableView.getSizeCell()
        
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
        cell.name.text = listRoom[indexPath.row].name
        if listRoom[indexPath.row].isStaying{
            cell.imageV.image = UIImage(named: "closed")
            cell.numberOfRoomer.text = String(listRoom[indexPath.row].listRoomer!.count)
        }else{
            cell.imageV.image = UIImage(named: "opened")
            cell.numberOfRoomer.text = "0"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ListOfMotel.shared.currentRoomIndex = indexPath.row
        performSegue(withIdentifier: "ShowDetailRoom", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let actionSheet = UIAlertController(title: "Bạn muốn xoá phòng này?", message: "Nếu xoá sẽ không thể khôi phục lại dữ liệu của phòng này", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tôi muốn xoá", style: .destructive, handler: { (action) in
                ListOfMotel.shared.deleteRoom(withIndex: indexPath.row)
                self.listRoom.remove(at: indexPath.row)
                ListOfMotel.shared.saveDataToFirebase()
                let alert = UIAlertController(title: "Xoá phòng thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK: HELPER METHOD
    
    //MARK: Setup func
    func setupRightButton(){
        let infoImage = UIImage(named: "plusicon")
        let imgWidth = infoImage?.size.width
        let imgHeight = infoImage?.size.height
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth!, height: imgHeight!))
        button.setBackgroundImage(infoImage, for: .normal)
        button.addTarget(self, action: #selector(createRoom), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func createRoom(){
        performSegue(withIdentifier: "FromListRoomToCreateRoom", sender: UIBarButtonItem.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromListRoomToCreateRoom"{
            let newVC = segue.destination as! CreateRoomController
            newVC.isCreating = true
            return
        }
//        newVC.isCreating = false
        let indexPath = tableView.indexPath(for: sender as! RoomCell)
        ListOfMotel.shared.currentRoomIndex = indexPath?.row
//        newVC.currentRoom = ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex].listRoom![(indexPath?.row)!]
    }
}
