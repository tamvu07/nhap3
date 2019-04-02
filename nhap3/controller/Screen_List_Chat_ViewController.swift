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

    @IBAction func bt_ListFriend(_ sender: Any) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_ListFrined") as! Screen_List_Friend_ViewController

        present(scr, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
        }
        else
        {
            print("khong co user !.............")
        }
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





