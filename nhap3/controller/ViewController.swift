//
//  ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/21/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
// TTT
ßßß
import UIKit
import Firebase

class ViewController: UIViewController,UIImagePickerControllerDelegate,	UINavigationControllerDelegate {

    var imgdata:Data!
    
    @IBOutlet weak var txt_ten: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var Avatar_img: UIImageView!
    
    @IBAction func bt_dangky(_ sender: Any) {
        // tao tai khoan
        Auth.auth().createUser(withEmail: txt_email.text!, password: txt_pass.text!) { authResult, error in
            if(error == nil)
            {
                // cah de luu ten va tam hinh len firebase
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = ""
                changeRequest?.photoURL = NSURL(fileURLWithPath: "") as URL
                changeRequest?.commitChanges { (error) in
                    // ...
                }
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
            // khon cho thay doi anh
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
        // Do any additional setup after loading the view, typically from a nib.
    }


}


