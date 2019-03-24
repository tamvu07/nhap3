//
//  RegisterController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/24/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import TextFieldEffects

class RegisterController: UIViewController {

    @IBOutlet weak var usernameFiled: AkiraTextField!
    @IBOutlet weak var passwordField: AkiraTextField!
    
    @IBOutlet weak var confirmField: AkiraTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var handle:AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
   
    func setupView(){
        
        self.title = "Đăng kí tài khoản"
        
        usernameFiled.setupUI()
        passwordField.setupUI()
        confirmField.setupUI()
        registerButton.layer.cornerRadius = 5
        registerButton.layer.shadowOpacity = 2
    }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let username = usernameFiled.text, let password = passwordField.text, let confirm = confirmField.text else{return}
         
        if password == confirm {
            Auth.auth().createUser(withEmail: username, password: password) { (authResult, error) in
                if let error = error {
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        return
                    })
                    return
                }
                
                guard let uid = authResult?.user.uid, let email = authResult?.user.email else{
                    return
                }
                
                let ref = Database.database().reference(fromURL: "https://quantro-faf83.firebaseio.com/")
                let userRef = ref.child("user").child(uid)
    
                let values = ["email":email]
                userRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                    if error != nil{
                        return
                    }
                   
                })
                
                
                let alert = UIAlertController(title: "", message: "Tạo tài khoản thành côn ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
                self.present(alert, animated: true, completion: nil)
                
            }
        }else{
            let alert = UIAlertController(title: "", message: "Password không trùng nhau", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
                return
            })
        }
        
      
    }
    
    func closeKeyBoard(){
        usernameFiled.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmField.resignFirstResponder()
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        closeKeyBoard()
    }
    
    @IBAction func enterToCloseKeyboard(_ sender: Any) {
        closeKeyBoard()
    }
    
}
