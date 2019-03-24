//
//  MotelController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/29/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class MotelController: UIViewController {

    
    @IBOutlet var buttons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.layer.cornerRadius = 6.0
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor(displayP3Red: 0, green: 121, blue: 235, alpha: 0.92).cgColor
            button.layer.shadowOffset = CGSize(width: -2, height: -2)
            button.layer.shadowOpacity = 0.3
            button.backgroundColor = UIColor.white
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex].name
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FromMotelToCreateMotel":
            let CreateMotelVC = segue.destination as? CreateMotelController
            CreateMotelVC?.isCreating = false
            
//        case "FromMotelToListRoom":
//            let ListRoomVC = segue.destination as? ListRoomController
        default:
            break
        }
       
    }

}
