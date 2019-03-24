//
//  ViewController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/24/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CodableFirebase
import FBSDKLoginKit


class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        //addBackGround()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"]
        if FBSDKAccessToken.currentAccessTokenIsActive(){
            
        }
       
    }

    func setupView(){
        
        self.title = "Quan Tro"
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.shadowOpacity = 2
        registerButton.layer.cornerRadius = 4
        registerButton.layer.shadowOpacity = 2
        usernameField.setupUI()
        passwordField.setupUI()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background2")
        backgroundImage.alpha = 0.8
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        let spinner = creatSpinner()
        spinner.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        view.addSubview(spinner)
        spinner.startAnimating()
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                print(err)
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
                return
            }
            // User is signed in
            guard let uid = authResult?.user.uid, let email = authResult?.user.email else{
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
                return
            }
            
            //let ref = Database.database().reference(fromURL: "https://quantro-faf83.firebaseio.com/")
            let userRef = Database.database().reference().child("user/\(uid)")
            let values = ["email":email]
            userRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                if error != nil{
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                    }
                    let alert = UIAlertController(title: "", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        return
                    })
                }
                userRef.child("listOfMotels").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value else{return}
                    do{
                        let listMotel = try FirebaseDecoder().decode([Motel].self, from: value)
                        
                        ListOfMotel.shared.setListMotel(fromList: listMotel)
                    }catch{
                        print(error)
                    }
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                    }
                    self.performSegue(withIdentifier: "FromLoginToListMotel", sender: self.loginButton)
                }, withCancel: nil)
            })
            
            
            
        }
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }


    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = usernameField.text, let password = passwordField.text else {
            return
        }
        let spinner = creatSpinner()
        spinner.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        view.addSubview(spinner)
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let err = error{
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
                let alert = UIAlertController(title: "", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    return
                })
            }else{
                
                
                    let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("user").child(uid!).child("listOfMotels").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    guard let value = snapshot.value else{return}
                    do{
                        let listMotel = try FirebaseDecoder().decode([Motel].self, from: value)
                        
                        ListOfMotel.shared.setListMotel(fromList: listMotel)
                    }catch{
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                    }
                    self.performSegue(withIdentifier: "FromLoginToListMotel", sender: self.loginButton)
                }, withCancel: nil)
            }
            
        }
    }
    
    //MARK: -- FBLOGIN
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if result.isCancelled{
            print(1)
            return
        }
        let spinner = creatSpinner()
        spinner.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        view.addSubview(spinner)
        spinner.startAnimating()
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        print(credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    return
                })
            }
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("user").child(uid!).child("listOfMotels").observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                guard let value = snapshot.value else{return}
                do{
                    let listMotel = try FirebaseDecoder().decode([Motel].self, from: value)
                    
                    ListOfMotel.shared.setListMotel(fromList: listMotel)
                }catch{
                    print(error)
                }
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
                self.performSegue(withIdentifier: "FromLoginToListMotel", sender: self.loginButton)
            }, withCancel: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    @IBAction func textFieldResigned(_ sender: Any) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
    
    func creatSpinner()->UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height:100))
        spinner.style = .white
        spinner.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        
        spinner.hidesWhenStopped = true
        return spinner
    }
    
}


extension UITextField{
    func setupUI(){
        self.layer.shadowOpacity = 0.1
    }
    
    func noneBorder(){
        self.layer.borderWidth = 0
    }
}
