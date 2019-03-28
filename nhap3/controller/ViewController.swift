//
//  ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/21/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
// khi up tam hinh len thi phai import storage


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage



let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://nhap3a.appspot.com")
// Create a storage reference from our storage service "gs://nhap3a.appspot.com"






class ViewController: UIViewController,UIImagePickerControllerDelegate,	UINavigationControllerDelegate {

    var imgdata:Data!
    
    @IBOutlet weak var txt_ten: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var Avatar_img: UIImageView!
    
    @IBAction func bt_dangky(_ sender: Any) {
        
        let email:String = txt_email.text!
        let pass:String = txt_pass.text!
        // tao tai khoan
        Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
            if(error == nil)
            {
                // dang ky xong ma ko co loi thi cho dang nhap luon
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if(error == nil)
                    {
                        print("dang nhap thanh cong")
                    }
                    
                }
                // dua avatar len database khi dang ky
                let Avatar_Ref = storageRef.child("images/\(email).jpg")
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = Avatar_Ref.putData(self.imgdata, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print("loi up load lan 1")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    Avatar_Ref.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("loi up load lan 2")
                            return
                        }
                        // cah de luu ten va tam hinh len firebase
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.txt_ten.text!
                        changeRequest?.photoURL = downloadURL
                        changeRequest?.commitChanges { (error) in
                            if let error = error{
                                print("loi upload profile")
                            }else{
//                                print("dang ky thanh cong ...... chuyen trang ! ")
                                self.gotoscreen()
                            }
                        }
                    }
                }
                // de up load file len phai chay lenh uploadTask.resume()
                uploadTask.resume()
            }
            else
            {
                print("loi dang ky !")
            }
        }
    }
    
    
    @IBAction func bt_avatar(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "thong bao", message: "chon", preferredStyle: .alert)
        // tao ra 2 button
        let btphoto:UIAlertAction = UIAlertAction(title: "pho to", style: .default) { (UIAlertAction) in
            // chon vao thu muc anh va lay anh o thu vien
            let ImgPicker = UIImagePickerController()
            ImgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            ImgPicker.delegate = self
            // khong cho thay doi anh
            ImgPicker.allowsEditing = false
            // nho man hinh chinh truy cap den no
            self.present(ImgPicker, animated: true, completion: nil)
        }
        
        let btcamera:UIAlertAction = UIAlertAction(title: "camera", style: .default) { (UIAlertAction) in
            // kiem tra xem co camera khong
            if(UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let ImgPicker = UIImagePickerController()
                ImgPicker.sourceType = UIImagePickerController.SourceType.camera
                ImgPicker.delegate = self
                // khong cho thay doi anh
                ImgPicker.allowsEditing = false
                // nho man hinh chinh truy cap den no
                self.present(ImgPicker, animated: true, completion: nil)
            }
            else
            {
                print("khong co camera......!")
            }
        }
        
        alert.addAction(btphoto)
        alert.addAction(btcamera)
        // phai dong no len
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func Tap_Avatar(_ sender: UITapGestureRecognizer) {
        
        
    }
    
    // khi vao camera hay photo thi goi den ham nay
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // chua biet no tra ve kieu gi nen ap ve UIImage
        let chooseimage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // giam do phan giai cua tam hinh
        // lay ra gia tri nao cao nhat
        let imgvalue = max(chooseimage.size.width,chooseimage.size.height)
        if(imgvalue > 3000)
        {
            // giam do phan giai tam hinh xuong 0.1
             imgdata = chooseimage.jpegData(compressionQuality: 0.1)
        }
        else if(imgvalue > 2000)
        {
            // giam do phan giai tam hinh xuong 0.1
            imgdata = chooseimage.jpegData(compressionQuality: 0.3)
        }
        else
        {
            imgdata = chooseimage.pngData()
        }
        // truyen tam hinh moi lay vao UIImageView
        Avatar_img.image = UIImage(data: imgdata)
        // sau do dong hop thoai lai
        dismiss(animated: true, completion: nil)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // khi moi vao co anh tu may luon
        imgdata = UIImage(named: "camera")!.pngData()
    }

    @IBAction func bt_dangnhap(_ sender: Any) {
        // chuyen man hinh dang nhap
        let SCR = storyboard?.instantiateViewController(withIdentifier: "MH_dangnhap") as! manhinh_dangnhap_ViewController
        // chuyen man hinh khong co nut tro ve
       present(SCR, animated: true, completion: nil);
        // chuyen man hinh co nut tro ve
//        navigationController?.pushViewController(SCR, animated: true)
    }
    
    

    
}


