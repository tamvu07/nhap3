//
//  ListRoomerController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/31/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class ListRoomerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var listRoomer:[Roomer]!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.register(RoomerCell.self, forCellReuseIdentifier: "RoomerCell")
        let nib = UINib(nibName: "RoomerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RoomerCell")
        tableView.rowHeight = 110
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listRoomer = ListOfMotel.shared.getCurrentRoom().listRoomer
        tableView.reloadData()
    }
    // MARK:- DELEGATE and DATASOURCE OF TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !ListOfMotel.shared.getCurrentRoom().isStaying{
            return 0
        }
        return listRoomer.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == listRoomer.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlusCell", for: indexPath)
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.tableView.frame.size.width - 20, height: self.tableView.rowHeight - 16))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 4.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: -1)
            
            whiteRoundedView.layer.borderColor = UIColor.gray.cgColor
            
            whiteRoundedView.layer.borderWidth = 2
            whiteRoundedView.layer.shadowOpacity = 0.2
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomerCell", for: indexPath) as! RoomerCell
        
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
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
        
        cell.name.text = listRoomer[indexPath.row].name
        cell.numPhone.text = listRoomer[indexPath.row].numPhone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == listRoomer.count && ListOfMotel.shared.getCurrentRoom().maxRoomer == listRoomer.count{
            let alert = UIAlertController(title: "Không thể tạo người trọ", message: "Số người trọ của phòng này đã tới mức giới hạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "FromListRoomerToCreate", sender: tableView.cellForRow(at: indexPath))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: (sender as! UITableViewCell))
        let newVC = segue.destination as! CreateRoomerController
        newVC.isCreating = indexPath?.row == listRoomer.count ? true:false
        newVC.indexRoomer = indexPath?.row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == listRoomer.count ? false:true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let actionSheet = UIAlertController(title: "Bạn muốn xoá người trọ này?", message: "Nếu xoá sẽ không thể khôi phục lại người trọ này", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tôi muốn xoá", style: .destructive, handler: { (action) in
                ListOfMotel.shared.deleteRoomer(withIndex: indexPath.row)
                self.listRoomer.remove(at: indexPath.row)
                ListOfMotel.shared.saveDataToFirebase()
                let alert = UIAlertController(title: "Xoá người trọ thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
}
