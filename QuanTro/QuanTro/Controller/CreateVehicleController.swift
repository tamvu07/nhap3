//
//  CreateVehicleController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 1/1/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
import Firebase
import TextFieldEffects

class CreateVehicleController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    

    @IBOutlet weak var nameRoomerField: AkiraTextField!
    @IBOutlet weak var licensePlateField: AkiraTextField!
    @IBOutlet weak var sortVehicleField: AkiraTextField!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var createButon: UIButton!
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    
    var listRoomer:[String]!
    var picker:UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listRoomer = ListOfMotel.shared.getListNameRoomer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDisplay()
    }
    
    func setupUI(){
        addImageButton.layer.cornerRadius = 4
        addImageButton.layer.shadowOpacity = 0.4
        createButon.layer.cornerRadius = 5
        createButon.layer.shadowOpacity = 0.4
    }
    
    @IBAction func nameRoomerFieldBeginEditting(_ sender: Any) {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        
        picker.delegate = self
        picker.dataSource = self
        
        nameRoomerField.inputView = picker
        nameRoomerField.inputAccessoryView = setupToolBar()
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        (sender as! UITextField).resignFirstResponder()
    }
    @IBAction func addImage(_ sender: Any) {
        showActionSheet()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listRoomer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listRoomer[row]
    }
    
    func showActionSheet(){
        let actionSheet = UIAlertController(title: "Chọn ảnh", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: Setup frame of scollView and UIScrollViewDelegate
    
    
    //MARK: Setup UIImagePickerDelegate
    @objc func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                imageV.image = image
            }
        }
        lastChosenMediaType = nil
        image = nil
    }
    
    @objc func pickMediaFromSource(_ sourceType:UIImagePickerController.SourceType) {
        let mediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        lastChosenMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func createVehicle(_ sender: Any) {
        if nameRoomerField.text?.isEmpty == true || sortVehicleField.text?.isEmpty == true || licensePlateField.text?.isEmpty == true || imageV.image == nil {
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        var newVehicle = Vehicle()
        newVehicle.nameRoomer = nameRoomerField.text
        newVehicle.licensePlates = licensePlateField.text
        newVehicle.sortVehicel = sortVehicleField.text
        let idImage = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("imagesOfMotels/\(idImage).jpg")
        let data = imageV.image?.jpegData(compressionQuality: 1)
        if data != nil{
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
            }
            newVehicle.imageString = "\(idImage).jpg"
        }
        
        ListOfMotel.shared.addVehicle(newVehicle: newVehicle)
        ListOfMotel.shared.saveDataToFirebase()
        let alert = UIAlertController(title: "Tạo xe thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupToolBar()->UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 199/255, green: 90/255, blue: 90/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Chọn", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneClick(){
        switch true {
        case nameRoomerField.isEditing:
            if listRoomer.isEmpty{
                break
            }
            let index = picker.selectedRow(inComponent: 0)
            nameRoomerField.text = listRoomer[index]
       
        default:
            break
        }
        cancelClick()
        
    }
    
    @objc func cancelClick(){
        nameRoomerField.resignFirstResponder()
    }

}
