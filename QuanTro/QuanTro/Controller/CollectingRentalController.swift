//
//  CollectingRentalController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/7/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class CollectingRentalController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var categoryData = ["Tất cả", "Chưa thu", "Đã thu"]
    private var yearData = ["2018","2019","2020","2021","2022","2023","2024","2025"]
    private var monthData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ]
    
    private var categoryPicker:UIPickerView!
    private var timePicker:UIPickerView!
    var dict:[String:[String:Bool]]!
    var key:String!
    var listRoomUnavailable:[Room]!
    var listRoomPaid = [Room]()
    var listRoomUnpaid = [Room]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAndUpdate()
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
        
        guard let subDict = dict[key] else{return}
        for room in listRoomUnavailable{
            if subDict[room.id] == false{
                listRoomUnpaid.append(room)
            }else{
                listRoomPaid.append(room)
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
    
    
    private func checkAndUpdate(){
        dict = ListOfMotel.shared.getCollectedRent()
        listRoomUnavailable = ListOfMotel.shared.getListRoomUnavailable()
        let dayCollectingRent = ListOfMotel.shared.getDayCollectingRent()
        //Test
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.date(from: "12/02/2019")!
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month, .year], from: currentDate)
        key = "\(components.month!)-\(components.year!)"
        if components.day! >= dayCollectingRent && dict[key] == nil {
            var subDict = [String:Bool]()
            for room in listRoomUnavailable{
                subDict.updateValue(false, forKey: room.id)
            }
            dict.updateValue(subDict, forKey: key)
        }
    }
    
    private func reloadList(){
        listRoomPaid.removeAll()
        listRoomUnpaid.removeAll()

        guard let subDict = dict[key] else{return}
        for room in listRoomUnavailable{
            if subDict[room.id] == false{
                listRoomUnpaid.append(room)
            }else{
                listRoomPaid.append(room)
            }
        }
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categoryField.text {
        case "Tất cả":
            self.tableView.tag = 0
            return listRoomPaid.count + listRoomUnpaid.count
        case "Chưa thu":
            self.tableView.tag = 1
            return listRoomUnpaid.count
        case "Đã thu":
            self.tableView.tag = 2
            return listRoomPaid.count
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
        let temp = tableView.tag == 2 ? 0:listRoomUnpaid.count
        
        if indexPath.row < listRoomUnpaid.count && tableView.tag != 2{
            cell.nameRoom.text = listRoomUnpaid[indexPath.row].name
            cell.totalMoney.text =  String(listRoomUnpaid[indexPath.row].rentalPrice)
            cell.button.tag = indexPath.row
            cell.button.setTitle("Thu tiền", for: .normal)
            cell.button.isEnabled = true
            cell.button.addTarget(self, action: #selector(handleCollecting(_:)), for: .touchUpInside)
            
            cell.button.backgroundColor = UIColor.green
            
        }else{
            cell.nameRoom.text = listRoomPaid[indexPath.row - temp].name
            cell.totalMoney.text =  String(listRoomPaid[indexPath.row - temp].rentalPrice)
            cell.button.setTitle("Đã thu", for: .normal)
            cell.button.isEnabled = false
            cell.button.backgroundColor = UIColor.gray
           
        }
        
        return cell
    }
    
    @objc func handleCollecting(_ button:UIButton){
        
        
        (dict[key]!).updateValue(true, forKey: listRoomUnpaid[button.tag].id)
        ListOfMotel.shared.updateCollectedRent(dict: dict)
        ListOfMotel.shared.saveDataToFirebase()
        reloadList()
        tableView.reloadData()
    }
}
