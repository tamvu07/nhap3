//
//  Show_Avatar_ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 4/1/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit
import Firebase

class Show_Avatar_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var Avatar:String!
    var array_id_chat:Array<String> = Array<String>()
    var tablename:DatabaseReference!
    @IBOutlet weak var txt_messager: UITextField!
    var array_text_chat:Array<String> = Array<String>()
    var array_user_chat:Array<User> = Array<User>()
    
    @IBOutlet weak var table_chat_user1_user2: UITableView!
    
    @IBAction func bt_back(_ sender: Any) {
    let scr = storyboard?.instantiateViewController(withIdentifier: "MH_ListFrined") as! Screen_List_Friend_ViewController
        present(scr, animated: true, completion: nil)
    }
    
    @IBAction func bt_send(_ sender: Any) {
        let messager:Dictionary<String,String> = ["id":currenUser.id,"messager":txt_messager.text!]
        tablename.childByAutoId().setValue(messager)
        txt_messager.text = ""
        // tao ra 1 bang chat cua nguoi chat va ban dang chat
        if(array_text_chat.count == 0)
        {
            addListChat(user1: currenUser, user2: vistor )
            addListChat(user1: vistor, user2: currenUser) 
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        table_chat_user1_user2.dataSource = self
        table_chat_user1_user2.delegate = self
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Avatar!)!)
        print("...............<<<<<....\(vistor.email)........")
        array_id_chat.append(currenUser.id)
        array_id_chat.append(vistor.id)
       array_id_chat.sort()
        let key:String = "\(array_id_chat[0])\(array_id_chat[1])"
        tablename = ref.child("Chat").child(key)
        
        // Listen for new comments in the Firebase database
        tablename.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if(postDict != nil)
            {
                if(postDict?["id"]  as! String == currenUser.id )
                {
                    self.array_user_chat.append(currenUser)
                }
                else
                {
                    self.array_user_chat.append(vistor)
                }
                self.array_text_chat.append(postDict?["messager"] as! String)
//                print(self.array_user_chat)
//                print(self.array_text_chat)
                self.table_chat_user1_user2.reloadData()
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_text_chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(currenUser.id == array_user_chat[indexPath.row].id)
        {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL2", for: indexPath) as! CELL_chat_user_2_TableViewCell
            Cell.lb_user_2.text = array_text_chat[indexPath.row]
//            Cell.Avatar_user_2.image = currenUser.Avatar
//            Cell.lb_user_2.text = "aaaaaaa"
            return Cell
        }
        else
        {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL1", for: indexPath) as! CELL_chat_user_1_TableViewCell
            Cell.lb_user_1.text = array_text_chat[indexPath.row]
            Cell.Avatar_user_1.image = vistor.Avatar
            return Cell
        }
        
    }
    
    func addListChat(user1:User,user2:User) {
        let tablename_2 = ref.child("ListChat").child(user1.id).child(user2.id)
        let user:Dictionary<String,String> = ["email":user2.email,"fullName":user2.fullName,"linkAvatar":user2.linkAvatar]
        tablename_2.setValue(user)
    }

}

//extension Show_Avatar_ViewController: UITableViewDataSource,UITableViewDelegate
//{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return array_text_chat.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(currenUser.id == array_user_chat[indexPath.row].id)
//        {
//           let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL2", for: indexPath) as! CELL_chat_user_2_TableViewCell
//            Cell.lb_user_2.text = array_text_chat[indexPath.row]
//            Cell.Avatar_user_2.image = currenUser.Avatar
//            return Cell
//        }
//        else
//        {
//            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL1", for: indexPath) as! CELL_chat_user_1_TableViewCell
//            Cell.lb_user_1.text = array_text_chat[indexPath.row]
//            Cell.Avatar_user_1.image = currenUser.Avatar
//            return Cell
//        }
//
//    }
//}
