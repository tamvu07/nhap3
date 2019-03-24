//
//  ServicePricesController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/4/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import TextFieldEffects

class ServicePricesController: UIViewController {

    
    
    @IBOutlet weak var electricField: AkiraTextField!
    @IBOutlet weak var waterField: AkiraTextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 4
        button.layer.shadowOpacity = 0.5
        
        self.title = "Bảng gía dịch vụ"
        setupView()
    }
    
    func setupView(){
        if let servicePrices = ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex].servicePrices{
            electricField.text = String(servicePrices.electricPrice)
            waterField.text = String(servicePrices.waterPrice)
        }else{
            electricField.text = "0"
            waterField.text = "0"
        }
    }
    


    @IBAction func update(_ sender: Any) {
        
        if electricField.text?.isEmpty == true || waterField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        var newServicePrices = ServicePrices()
        newServicePrices.electricPrice = UInt(electricField.text ?? "0")
        newServicePrices.waterPrice = UInt(waterField.text ?? "0")
        ListOfMotel.shared.updateServicePrices(servicePrices: newServicePrices)
        
        ListOfMotel.shared.saveDataToFirebase()
        
        let alert = UIAlertController(title: "Cập nhật thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        (sender as! UITextField).resignFirstResponder()
    }
    
    @IBAction func tap(_ sender: Any) {
        waterField.resignFirstResponder()
        electricField.resignFirstResponder()
    }
}
