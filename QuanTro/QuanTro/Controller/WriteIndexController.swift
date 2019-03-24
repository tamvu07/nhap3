//
//  WriteIndexController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/13/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class WriteIndexController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    
    var listRoomUnavailable:[Room]!
    var isWrited:Bool!
    
    
    var currentDate = Date()
    var tag:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateFormatter.date(from: "12/02/2019")!
        listRoomUnavailable = ListOfMotel.shared.getListRoomUnavailable()
        setupView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosing), name: .saveIndex, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func handlePopupClosing(notification: Notification){
        let popupVC = notification.object as! PopupController
        var newIndex = Index()
        newIndex.date = currentDate
        newIndex.waterIndex = Int(popupVC.waterField.text!)
        newIndex.electricIndex = Int(popupVC.electricField.text!)
        
        let room = ListOfMotel.shared.getRoom(withId: listRoomUnavailable[tag].id)
        var feeBill = FeeBill()
        feeBill.beginIndex = room.listIndex.last
        feeBill.endIndex = newIndex
        feeBill.nameRoom = room.name
        feeBill.isCollected = false
        feeBill.roomID = room.id
        
        let key = "\(currentDate.getCurrentDateComponents().month!)-\(currentDate.getCurrentDateComponents().year!)"
        ListOfMotel.shared.addFeeBill(key: key, feeBill: feeBill)
        
        listRoomUnavailable[tag].listIndex.append(newIndex)
        ListOfMotel.shared.updateListIndex(withIdRoom: listRoomUnavailable[tag].id, newIndex: newIndex)
        
        
        
        ListOfMotel.shared.saveDataToFirebase()
        tableView.reloadData()
        
    }
    
    func setupView(){
//        categoryField.layer.borderColor = UIColor.orange.cgColor
//        categoryField.layer.borderWidth = 1.0
//        categoryField.text = categoryData[0]
        
        self.title = "Kì \(currentDate.getCurrentDateComponents().month!)/\(currentDate.getCurrentDateComponents().year!)"
        tableView.register(WriteIndexCell.self, forCellReuseIdentifier: "WriteIndexCell")
        let xib = UINib(nibName: "WriteIndexCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "WriteIndexCell")
        tableView.rowHeight = 130
        
        isWrited = true
        sortListRoom()
        
        
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoomUnavailable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WriteIndexCell", for: indexPath) as! WriteIndexCell
        
        cell.roomName.text = listRoomUnavailable[indexPath.row].name
        let endIndex = listRoomUnavailable[indexPath.row].listIndex.count - 1
        if listRoomUnavailable[indexPath.row].listIndex[endIndex].date.getCurrentDateComponents().month != currentDate.getCurrentDateComponents().month{
            
            let cellSize = tableView.getRedBorder()
            cell.contentView.addSubview(cellSize)
            cell.contentView.sendSubviewToBack(cellSize)
            
            cell.WriteButton.isEnabled = true
            cell.WriteButton.tag = indexPath.row
            cell.WriteButton.addTarget(self, action: #selector(handleWriteButton(_:)), for: .touchUpInside)
        }else{
            let cellSize = tableView.getGreenBorder()
            cell.contentView.addSubview(cellSize)
            cell.contentView.sendSubviewToBack(cellSize)
            cell.WriteButton.isEnabled = false
            cell.WriteButton.backgroundColor = UIColor.gray
        }
        cell.historyButton.tag = indexPath.row
        cell.historyButton.addTarget(self, action: #selector(handleHistoryButton(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleHistoryButton(_ button:UIButton){
        performSegue(withIdentifier: "FromWriteIndexToHistoryIndex", sender: button)
    }
    
    @objc func handleWriteButton(_ button:UIButton){
        performSegue(withIdentifier: "ShowPopup", sender: button)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopup" {
            tag = (sender as! UIButton).tag
            let newVC = segue.destination as! PopupController
            newVC.name = listRoomUnavailable[tag].name
        }else{
            let newVC = segue.destination as! HistoryIndexController
            newVC.room = listRoomUnavailable[(sender as! UIButton).tag]
        }
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isWrited = true
        }else{
            isWrited = false
        }
        sortListRoom()
        tableView.reloadData()
        
    }
    

    
    
    func sortListRoom(){
        if listRoomUnavailable.isEmpty{
            return
        }
        var tempList = [Room]()
        var i = 0
        while true {
            let endIndex = listRoomUnavailable[i].listIndex.count - 1
            if listRoomUnavailable[i].listIndex[endIndex].date.getCurrentDateComponents().month != currentDate.getCurrentDateComponents().month{
                tempList.append(listRoomUnavailable.remove(at: i))
            }else{
                i += 1
            }
            if i == listRoomUnavailable.count{
                break
            }
        }
        
        if isWrited{
            listRoomUnavailable.append(contentsOf: tempList)
        }else{
            listRoomUnavailable.insert(contentsOf: tempList, at: 0)
        }
        
        
    }
    
}
extension Date{
    func getCurrentDateComponents()->DateComponents{
        let calendar = NSCalendar.current
        return calendar.dateComponents([.day , .month, .year], from: self)
    }
}

extension Notification.Name{
    static let saveIndex = Notification.Name(rawValue: "saveIndex")
}
