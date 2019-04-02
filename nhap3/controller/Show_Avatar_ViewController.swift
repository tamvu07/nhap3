//
//  Show_Avatar_ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 4/1/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit
import Firebase

class Show_Avatar_ViewController: UIViewController {

    var Avatar:String!
    var array_id_chat:Array<String> = Array<String>()
    var tablename:DatabaseReference!
    @IBOutlet weak var txt_messager: UITextField!
    
    @IBAction func bt_send(_ sender: Any) {
        let messager:Dictionary<String,String> = ["id":currenUser.id,"messager":txt_messager.text!]
        tablename.childByAutoId().setValue(messager)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Avatar!)!)
        print("...............<<<<<....\(vistor.email)........")
        array_id_chat.append(currenUser.id)
        array_id_chat.append(vistor.id)
        array_id_chat.sort()
        let key:String = "\(array_id_chat[0])\(array_id_chat[1])"
        tablename = ref.child("Chat").child(key)
    }
    


}
