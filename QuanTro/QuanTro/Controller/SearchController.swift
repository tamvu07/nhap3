//
//  SearchController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/27/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var listRoomer = [Roomer]()
    var listRoomerResult = [Roomer]()
    
    var listVehicle = [Vehicle]()
    var listVehicleResult = [Vehicle]()
    
    var listRoom = [Room]()
    var listRoomResult = [Room]()
    
    var searchBar = UISearchBar()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Nhập thông tin tìm kiếm"
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        tableView.tableHeaderView = searchBar
        
        tableView.register(VehicleCell.self, forCellReuseIdentifier: "VehicleCell")
        let nib = UINib(nibName: "VehicleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VehicleCell")
        
        tableView.register(RoomerCellForSearching.self, forCellReuseIdentifier: "RoomerCellForSearching")
        let nib1 = UINib(nibName: "RoomerCellForSearching", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "RoomerCellForSearching")
        
        tableView.register(RoomCell.self, forCellReuseIdentifier: "RoomCell")
        let nib2 = UINib(nibName: "RoomCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "RoomCell")
        tableView.rowHeight = 120
        
        prepareData()
    }
    

    func prepareData(){
        let listRoomUnavailable = ListOfMotel.shared.getListRoomUnavailable()
        for room in listRoomUnavailable{
            listRoomer.append(contentsOf: room.listRoomer)
        }
        listRoom = ListOfMotel.shared.getListRoomAvailable()
        listRoom.append(contentsOf: listRoomUnavailable)
        
        listVehicle = ListOfMotel.shared.getListVehicle()
        
    }
    
    @IBAction func segmentedChangedValue(_ sender: Any) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmented.selectedSegmentIndex {
        case 0: //Vehicle
            return isSearching ? listVehicleResult.count:listVehicle.count
        case 1: // Roomer
            return isSearching ? listRoomerResult.count:listRoomer.count
        case 2: // Room
            return isSearching ? listRoomResult.count:listRoom.count
        default:
            break
        }
        return 0
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmented.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as! VehicleCell
            
            let cellSize = tableView.getSizeCell()
            cell.contentView.addSubview(cellSize)
            cell.contentView.sendSubviewToBack(cellSize)
            
            if isSearching{
                cell.nameRoomer.text = listVehicleResult[indexPath.row].nameRoomer
                cell.licensePlate.text = listVehicleResult[indexPath.row].licensePlates
                cell.sortVehicle.text = listVehicleResult[indexPath.row].sortVehicel
                if let imageString = listVehicleResult[indexPath.row].imageString{
                    let storageRef = Storage.storage().reference().child("imagesOfMotels/\(imageString)")
                    storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                        if error != nil{
                            print(error!)
                        }else{
                            DispatchQueue.main.async{
                                cell.imageV.image = UIImage(data: data!)!
                            }
                        }
                        
                    }
                }
            }else{
                cell.nameRoomer.text = listVehicle[indexPath.row].nameRoomer
                cell.licensePlate.text = listVehicle[indexPath.row].licensePlates
                cell.sortVehicle.text = listVehicle[indexPath.row].sortVehicel
                if let imageString = listVehicle[indexPath.row].imageString{
                    let storageRef = Storage.storage().reference().child("imagesOfMotels/\(imageString)")
                    storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                        if error != nil{
                            print(error!)
                        }else{
                            DispatchQueue.main.async{
                                cell.imageV.image = UIImage(data: data!)!
                            }
                        }
                        
                    }
                }
            }
            return cell
        case 1: //Roomer
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomerCellForSearching", for: indexPath) as! RoomerCellForSearching
            
            let cellSize = tableView.getSizeCell()
            cell.contentView.addSubview(cellSize)
            cell.contentView.sendSubviewToBack(cellSize)
            
            if isSearching {
                cell.name.text = listRoomerResult[indexPath.row].name
                cell.room.text = ListOfMotel.shared.getRoomName(withRoomID: listRoomerResult[indexPath.row].roomID)
                if let profileImageString = listRoomerResult[indexPath.row].profileImageString{
                    let storageRef = Storage.storage().reference().child("imagesOfMotels/\(profileImageString)")
                    storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                        if error != nil{
                            print(error!)
                        }else{
                            DispatchQueue.main.async{
                                cell.imageV.image = UIImage(data: data!)!
                            }
                        }
                    }
                }
                
            }else{
                cell.name.text = listRoomer[indexPath.row].name
                cell.room.text = ListOfMotel.shared.getRoomName(withRoomID: listRoomer[indexPath.row].roomID)
                if let profileImageString = listRoomer[indexPath.row].profileImageString{
                    let storageRef = Storage.storage().reference().child("imagesOfMotels/\(profileImageString)")
                    storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                        if error != nil{
                            print(error!)
                        }else{
                            DispatchQueue.main.async{
                                cell.imageV.image = UIImage(data: data!)!
                            }
                        }
                        
                    }
                }
            }
            
            return cell
        case 2: // Room
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
            
            let cellSize = tableView.getSizeCell()
            cell.contentView.addSubview(cellSize)
            cell.contentView.sendSubviewToBack(cellSize)
            
            if isSearching{
                cell.name.text = listRoomResult[indexPath.row].name
                if listRoomResult[indexPath.row].isStaying{
                    cell.imageV.image = UIImage(named: "closed")
                    cell.numberOfRoomer.text = String(listRoomResult[indexPath.row].listRoomer!.count)
                }else{
                    cell.imageV.image = UIImage(named: "opened")
                    cell.numberOfRoomer.text = "0"
                }
            }else{
                cell.name.text = listRoom[indexPath.row].name
                if listRoom[indexPath.row].isStaying{
                    cell.imageV.image = UIImage(named: "closed")
                    cell.numberOfRoomer.text = String(listRoom[indexPath.row].listRoomer!.count)
                }else{
                    cell.imageV.image = UIImage(named: "opened")
                    cell.numberOfRoomer.text = "0"
                }
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        var isFound = true
        switch segmented.selectedSegmentIndex {
        case 0: //Vehicle
            listVehicleResult.removeAll()
            searchBar.resignFirstResponder()
            for vehicle in listVehicle{
                if vehicle.licensePlates.range(of: searchBar.text!) != nil{
                    listVehicleResult.append(vehicle)
                }
            }
            if listVehicleResult.isEmpty{
                isFound = false
            }
        case 1: //Roomer
            listRoomerResult.removeAll()
            searchBar.resignFirstResponder()
            for roomer in listRoomer{
                if roomer.name.range(of: searchBar.text!) != nil{
                    listRoomerResult.append(roomer)
                }
            }
            if listRoomerResult.isEmpty{
                isFound = false
            }
        case 2: //Room
            listRoomResult.removeAll()
            searchBar.resignFirstResponder()
            for room in listRoom{
                if room.name.range(of: searchBar.text!) != nil{
                    listRoomResult.append(room)
                }
            }
            if listRoomResult.isEmpty{
                isFound = false
            }
        default:
            break
        }
        
        tableView.reloadData()
        if !isFound{
            let alert = UIAlertController(title: "Không tìm thấy", message: "Dữ liệu bạn tìm không tồn tại", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        listRoomerResult.removeAll()
        listRoomResult.removeAll()
        listVehicleResult.removeAll()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
}
