//
//  CollectingFeeController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/27/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class CollectingFeeController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var categoryData = ["Tất cả", "Chưa thu", "Đã thu"]
    private var yearData = ["2018","2019","2020","2021","2022","2023","2024","2025"]
    private var monthData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ]
    
    private var categoryPicker:UIPickerView!
    private var timePicker:UIPickerView!
    var dict:[String:[FeeBill]]!
    var key:String!
    var listBillCollected = [FeeBill]()
    var listBillNotCollected = [FeeBill]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return categoryData.count
        }
        return component == 0 ? monthData.count:yearData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return categoryData[row]
        }
        
        return component == 0 ? "Tháng \(monthData[row])":yearData[row]
    }
    
    
    
    
    
    @IBAction func categoryFieldBeginEditting(_ sender: Any) {
        categoryPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.tag = 0
        
        categoryField.inputView = categoryPicker
        categoryField.inputAccessoryView = setupToolBar()
    }
    
    @IBAction func timeFieldBeginEditting(_ sender: Any) {
        timePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.tag = 1
        
        timeField.inputView = timePicker
        timeField.inputAccessoryView = setupToolBar()
    }
    
    func setupView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.date(from: "12/01/2019")!
        
        
        key = "\(currentDate.getCurrentDateComponents().month!)-\(currentDate.getCurrentDateComponents().year!)"
        
        categoryField.layer.borderColor = UIColor.orange.cgColor
        categoryField.layer.borderWidth = 1.5
        categoryField.layer.shadowOpacity = 0.3
        
        timeField.layer.borderColor = UIColor.orange.cgColor
        timeField.layer.borderWidth = 1.5
        timeField.layer.shadowOpacity = 0.3
        
        categoryField.text = categoryData[0]
        timeField.text = "Tháng \(key!)"
        
        tableView.register(BillCell.self, forCellReuseIdentifier: "BillCell")
        let xib = UINib(nibName: "BillCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "BillCell")
        tableView.rowHeight = 140
        
        
        
        dict = ListOfMotel.shared.getCollectedFee()
        
        guard let temp = dict[key] else{return}
        
        for i in 0..<temp.count{
            if temp[i].isCollected{
                listBillCollected.append(temp[i])
            }else{
                listBillNotCollected.append(temp[i])
            }
        }
        
    }
    
    func setupToolBar()->UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 199/255, green: 90/255, blue: 90/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Chọn", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneClick(){
        switch true {
        case categoryField.isEditing:
            let index = categoryPicker.selectedRow(inComponent: 0)
            categoryField.text = categoryData[index]
        case timeField.isEditing:
            let monthIndex = timePicker.selectedRow(inComponent: 0)
            let yearIndex = timePicker.selectedRow(inComponent: 1)
            key = "\(monthData[monthIndex])-\(yearData[yearIndex])"
            timeField.text = "Tháng \(key!)"
        default:
            break
        }
        reloadList()
        tableView.reloadData()
        cancelClick()
        
    }
    
    @objc func cancelClick(){
        categoryField.resignFirstResponder()
        timeField.resignFirstResponder()
    }
    
    
   
    private func reloadList(){
        listBillNotCollected.removeAll()
        listBillCollected.removeAll()

        guard let subDict = dict[key] else{return}
        for bill in subDict{
            if bill.isCollected{
                listBillCollected.append(bill)
            }else{
                listBillNotCollected.append(bill)
            }
        }
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categoryField.text {
        case "Tất cả":
            self.tableView.tag = 0
            return listBillCollected.count + listBillNotCollected.count
        case "Chưa thu":
            self.tableView.tag = 1
            return listBillNotCollected.count
        case "Đã thu":
            self.tableView.tag = 2
            return listBillCollected.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell") as! BillCell
        
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
        let temp = tableView.tag == 2 ? 0:listBillNotCollected.count
        let servicePrice = ListOfMotel.shared.getServicePrice()
        
        if indexPath.row < listBillNotCollected.count && tableView.tag != 2{
            let bill = listBillNotCollected[indexPath.row]
            cell.nameRoom.text = bill.nameRoom
            
            let waterMoney = (bill.endIndex.waterIndex - bill.beginIndex.waterIndex) * Int(servicePrice.waterPrice)
            let electricMoney = (bill.endIndex.electricIndex - bill.beginIndex.electricIndex) * Int(servicePrice.electricPrice)
            
            cell.totalMoney.text =  "\(waterMoney + electricMoney)"
            cell.button.tag = indexPath.row
            cell.button.setTitle("Thu tiền", for: .normal)
            cell.button.isEnabled = true
            cell.button.addTarget(self, action: #selector(handleCollecting(_:)), for: .touchUpInside)
            cell.button.backgroundColor = UIColor.green
        }else{
            let bill = listBillCollected[indexPath.row - temp]
            cell.nameRoom.text = bill.nameRoom
            
            let waterMoney = (bill.endIndex.waterIndex - bill.beginIndex.waterIndex) * Int(servicePrice.waterPrice)
            let electricMoney = (bill.endIndex.electricIndex - bill.beginIndex.electricIndex) * Int(servicePrice.electricPrice)
            cell.totalMoney.text =  "\(waterMoney + electricMoney)"
            cell.button.setTitle("Đã thu", for: .normal)
            cell.button.isEnabled = false
            cell.button.backgroundColor = UIColor.gray
        }
        
        return cell
    }
    
    @objc func handleCollecting(_ button:UIButton){
        
        guard var temp = dict[key] else{return}
        for i in  0..<temp.count{
            if listBillNotCollected[button.tag].roomID == temp[i].roomID{
                temp[i].isCollected = true
                break
            }
        }
        ListOfMotel.shared.updateCollectedFee(withKey: key, listFeeBill: temp)
        listBillCollected.append(listBillNotCollected.remove(at: button.tag))
        ListOfMotel.shared.saveDataToFirebase()
        tableView.reloadData()
    }
}
