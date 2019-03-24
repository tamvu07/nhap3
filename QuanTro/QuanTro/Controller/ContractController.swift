//
//  ContractController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 1/1/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import TextFieldEffects

class ContractController: UIViewController {

    @IBOutlet weak var contractSigningDateField:AkiraTextField!
    @IBOutlet weak var dayStartAtField:AkiraTextField!
    @IBOutlet weak var dayEndAtField:AkiraTextField!
    @IBOutlet weak var despoistField:AkiraTextField!
    @IBOutlet weak var rentalPriceField:AkiraTextField!
    @IBOutlet weak var nameFirstRoomer:AkiraTextField!
    @IBOutlet weak var cancleContractButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancleContractButton.layer.cornerRadius = 3
        cancleContractButton.layer.shadowOpacity = 1
        if ListOfMotel.shared.getCurrentRoom().contract == nil{
            let alert = UIAlertController(title: "Phòng này chưa làm hợp đồng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        setupInfo()
    }
    
    func setupInfo(){
        guard let contract = ListOfMotel.shared.getCurrentRoom().contract else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        contractSigningDateField.text = dateFormatter.string(from: contract.contractSigningDate)
        dayStartAtField.text = dateFormatter.string(from: contract.dayStartAt)
        dayEndAtField.text = dateFormatter.string(from: contract.dayEndAt)
        despoistField.text = String(contract.desposit)
        rentalPriceField.text = String(contract.rentalPrice)
        nameFirstRoomer.text = contract.nameRoomer
    }

    @IBAction func cancelContract(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Bạn muốn huỷ hợp đồng?", message: "Dữ liệu về người trọ của phòng này sẽ bị xoá", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Huỷ hợp đồng", style: .destructive, handler: { (action) in
            let alert = UIAlertController(title: "Huỷ hợp đồng thành công", message: "Số tiền cọc cần trả cho người trọ: \(self.despoistField.text!)", preferredStyle: .alert)
            ListOfMotel.shared.cancelContractForCurrentRoom()
            ListOfMotel.shared.saveDataToFirebase()
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
}
