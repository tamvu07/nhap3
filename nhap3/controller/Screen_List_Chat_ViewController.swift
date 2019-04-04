//
//  Screen_List_Chat_ViewController.swift
//  
//
//  Created by vuminhtam on 3/28/19.
//

import UIKit
import Firebase

let ref = Database.database().reference()
// vua dang nhap hoac dang ky thanh cong thi lay thong tin user ra
var currenUser:User!

class Screen_List_Chat_ViewController: UIViewController {

    
    @IBOutlet weak var table_view_List_chat: UITableView!
    var array_user_chat:Array<User> = Array<User>()
    @IBAction func bt_ListFriend(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_ListFrined") as! Screen_List_Friend_ViewController

        present(scr, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table_view_List_chat.delegate = self
        table_view_List_chat.dataSource = self
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.displayName
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            
            currenUser = User(id: uid, email: email!, fullname: name!, linkAvatar: String("\(photoURL!)") )
//            print("...........<<<<\(currenUser.linkAvatar)>>>>..............")
            let tablename = ref.child("ListFriend")
            // lay id user dang dang nhap hien tai
            let userid = tablename.child(currenUser.id)
            // khoi tao 1 user de up len fire base
            let user:Dictionary<String,String> = ["email":currenUser.email,
                                                  "fullname":currenUser.fullName,
                                                  "linkAvatar":currenUser.linkAvatar
                                                  ]
            // dem du lieu len fire base database
//            print("...xxxxx..<<<<\(currenUser.email)>>>>.................")
            userid.setValue(user)
            
            let url:URL = URL(string: currenUser.linkAvatar)!
            do{
                let data:Data = try Data(contentsOf: url)
                currenUser.Avatar = UIImage(data: data)
            }
            catch{
                print("loi load hinh")
            }
            
        }
        else
        {
            print("khong co user !.............")
        }
        let tablename = ref.child("ListChat").child(currenUser.id)
        // Listen for new comments in the Firebase database
        // lay du lieu ve luu vao mang array_user_chat
        tablename.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if(postDict != nil)
            {
                let email:String = (postDict?["email"])! as! String
                 let fullName:String = (postDict?["fullName"])! as! String
                 let linkAvata:String = (postDict?["linkAvatar"])! as! String
                let user:User = User(id: snapshot.key, email: email, fullname: fullName, linkAvatar: linkAvata)
                self.array_user_chat.append(user)
                self.table_view_List_chat.reloadData()
            }
        })
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Screen_List_Chat_ViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_user_chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! CELL_List_Chat_TableViewCell
        Cell.lb_name.text = array_user_chat[indexPath.row].fullName
        Cell.Avatar.loadavatar(link: array_user_chat[indexPath.row].linkAvatar)
        return Cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vistor = array_user_chat[indexPath.row]
        //        // chuyen man hinh
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "Show_Avatar") as! Show_Avatar_ViewController
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


