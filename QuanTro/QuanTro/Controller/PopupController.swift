//
//  PopupController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/16/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class PopupController: UIViewController {

    @IBOutlet weak var nameRoom: UILabel!
    @IBOutlet weak var electricField: UITextField!
    @IBOutlet weak var waterField: UITextField!
    
    var name:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameRoom.text = name
        electricField.inputAccessoryView = setupToolBar()
        waterField.inputAccessoryView = setupToolBar()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if electricField.text == "" || waterField.text == ""{
            let alert = UIAlertController(title: "Lỗi", message: "Bạn cần nhập đầy đủ thông tin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            
            NotificationCenter.default.post(name: .saveIndex, object: self)
            
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func cancleButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGestureRecognied(_ sender: Any) {
        waterField.resignFirstResponder()
        electricField.resignFirstResponder()
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
        
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneClick(){
        waterField.resignFirstResponder()
        electricField.resignFirstResponder()
    }
}
