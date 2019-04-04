//
//  Screen_List_Friend_ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 4/1/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit
var vistor:User!

class Screen_List_Friend_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var table_view: UITableView!
    var listFriend:Array<User> = Array<User>()
    
    var mang:[sieunhan] = [
        sieunhan(hinh: "camera", ten: "hinh 1"),
        sieunhan(hinh: "1_apple", ten: "hinh 2"),
        sieunhan(hinh: "2_apple", ten: "hinh 3"),
        sieunhan(hinh: "3_apple", ten: "hinh 4"),
        sieunhan(hinh: "anh_dai_dien", ten: "hinh 5")
    ]
    
    @IBAction func bt_back(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "isLogin") as! Screen_List_Chat_ViewController
        present(scr, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.dataSource = self
        table_view.delegate = self
        
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
                // kiem tra khong cho user minh hien thi ra
                if(user.id != currenUser.id)
                {
                    // them user vao trong mang
                    self.listFriend.append(user)
                }

//                print(".........\(self.listFriend).......")
                self.table_view.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
//      return mang.count
       return listFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! Screen_List_Friend_CELL_TableViewCell
//        Cell.textLabel?.text = mang[indexPath.row]
//        Cell.detailTextLabel?.text = "Dong" +   String(indexPath.row)
//        Cell.image_1.image = UIImage(named: "anh_dai_dien")
//            Cell.avatar_1.image = UIImage(named: mang[indexPath.row].Hinh )
//            Cell.lb_1.text = mang[indexPath.row].Ten
            Cell.lb_1.text = listFriend[indexPath.row].fullName
            Cell.avatar_1.loadavatar(link: listFriend[indexPath.row].linkAvatar)
       
           return Cell
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "section" + String(section)
//    }
    
    // chuyen man hinh khi click vao
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
//        // chuyen man hinh
     let scr = self.storyboard?.instantiateViewController(withIdentifier: "Show_Avatar") as! Show_Avatar_ViewController
//         scr.Avatar = mang[indexPath.row].Hinh
        
////        self.navigationController?.pushViewController(scr, animated: true)
       
        vistor = listFriend[indexPath.row]
        // lay avatar ve
        let url:URL = URL(string: vistor.linkAvatar)!
        do
        {
            let data:Data = try Data(contentsOf: url)
            vistor.Avatar = UIImage(data: data)
        }
        catch{
            print("loi load avatar vistor ! ")
        }
        
        self.present(scr, animated: true, completion: nil)
        
    }

    
    
}
