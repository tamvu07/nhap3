//
//  ViewController.swift
//  nhap3
//
//  Created by vuminhtam on 3/21/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,	UINavigationControllerDelegate {

    var imgdata:Data!
    
    @IBAction func Tap_Avatar(_ sender: UITapGestureRecognizer) {
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
            
    }
        
        alert.addAction(btphoto)
        alert.addAction(btcamera)
        // phai dong no len
        
        self.present(alert, animated: true, completion: nil)
        
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
            // giam do tam hinh xuong 0.1
            imgdata = UIImageJPEGRepresentation(chooseimage, 0.5)
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


