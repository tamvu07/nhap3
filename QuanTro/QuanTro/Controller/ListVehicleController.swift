//
//  ListVehicleController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 1/1/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase

class ListVehicleController: UITableViewController {

    var listVehicle:[Vehicle]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(VehicleCell.self, forCellReuseIdentifier: "VehicleCell")
        let nib = UINib(nibName: "VehicleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VehicleCell")
        tableView.rowHeight = 150
        
        setupRightButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listVehicle = ListOfMotel.shared.getListVehicle()
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listVehicle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as! VehicleCell
        
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let actionSheet = UIAlertController(title: "Bạn muốn xoá xe này?", message: "Nếu xoá sẽ không thể khôi phục lại xe này", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tôi muốn xoá", style: .destructive, handler: { (action) in
                ListOfMotel.shared.deleteVehicle(withIndex: indexPath.row)
                self.listVehicle.remove(at: indexPath.row)
                ListOfMotel.shared.saveDataToFirebase()
                let alert = UIAlertController(title: "Xoá xe thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }

    
    func setupRightButton(){
        let infoImage = UIImage(named: "plusicon")
        let imgWidth = infoImage?.size.width
        let imgHeight = infoImage?.size.height
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth!, height: imgHeight!))
        button.setBackgroundImage(infoImage, for: .normal)
        button.addTarget(self, action: #selector(createNewVehicle), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func createNewVehicle(){
        performSegue(withIdentifier: "FromListVehicleToCreateVehicle", sender: UIBarButtonItem.self)
    }
    
}
