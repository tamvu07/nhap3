//
//  Screen_List_Friend_TableViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/31/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit

class Screen_List_Friend_TableViewController: UITableViewController{
    
  var listFriend:Array<User> = Array<User>()
    var mangMH:[String] = ["dia","su","sinh","hoa","ly","toan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tablename = ref.child("ListFriend")
        // Listen for new comments in the Firebase database
        tablename.observe(.childAdded, with: { (snapshot) in
            // kiem tra xem postDict co du lieu hay ko
            let postDict = snapshot.value as? [String : AnyObject]
            if(postDict != nil)
            {
                // day la tra ve cac doi tuong tren database
                let email:String = (postDict?["email"])! as! String
                let fullName:String = (postDict?["fullname"])! as! String
                let linkAvatar:String = (postDict?["linkAvatar"])! as! String
                
                let user:User = User(id: snapshot.key, email: email, fullname: fullName, linkAvatar: linkAvatar)
                // them user vao trong mang
                self.listFriend.append(user)
                
            }
        })


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // so nhom
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! Screen_List_Friend_CELL_TableViewCell
//        Cell.myLable.text = mangMH[indexPath.row]
//       return Cell
//    }

    
}
