//
//  ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/21/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func Tap_Avatar(_ sender: UITapGestureRecognizer) {
        let alert:UIAlertController = UIAlertController(title: "thong bao", message: "chon", preferredStyle: .alert)
        // tao ra 2 button
        let btphoto:UIAlertAction = UIAlertAction(title: "pho to", style: .default) { (UIAlertAction) in
            
        }
        
        let btcamera:UIAlertAction = UIAlertAction(title: "camera", style: .default) { (UIAlertAction) in
            
        }
        
        alert.addAction(btphoto)
        alert.addAction(btcamera)
        // phai dong no len
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

