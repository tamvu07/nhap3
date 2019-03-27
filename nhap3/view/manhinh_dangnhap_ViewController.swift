//
//  manhinh_dangnhap_ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/26/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit
import Firebase

class manhinh_dangnhap_ViewController: UIViewController {

    
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_pass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLogOut()
        isLogin()

    }
    
    @IBAction func bt_dangky(_ sender: Any) {
        let SCR = storyboard?.instantiateViewController(withIdentifier: "MH_dangky") as! ViewController
        present(SCR, animated: true, completion: nil)
    }
    
    
    @IBAction func bt_dangnhap(_ sender: Any) {
        // khi bam vao thi xoay xoay
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = CGRect(x: (view.frame.size.width/2), y: 10, width: 0, height: 0)
        activity.color = UIColor.red
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        self.present(alertActivity, animated: true, completion: nil)
        Auth.auth().signIn(withEmail: txt_email.text!, password: txt_pass.text!) { [weak self] user, error in
            

            if(error == nil)
            {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                print("dang nhap thanh cong !")
            }
            else
            {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                // dang nhap khong thanh cong
                let alert = UIAlertController(title: "Thong Bao", message: "Email hoac password khong chinh xac", preferredStyle: .alert)
                let btn_ok:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btn_ok)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func isLogin()
    {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == user)
            {
                print(user?.email)
            }
            else
            {
                print("chua dang nhap !..........")
            }
        }
    }
    
    func isLogOut()  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
