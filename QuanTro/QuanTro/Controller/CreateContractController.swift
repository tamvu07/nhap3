//
//  CreateContractController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/3/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage
import CodableFirebase
import  TextFieldEffects

class CreateContractController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    //Outlet of contract
    @IBOutlet weak var contractSigningDateField:AkiraTextField!
    @IBOutlet weak var dayStartAtField:AkiraTextField!
    @IBOutlet weak var dayEndAtField:AkiraTextField!
    @IBOutlet weak var despoistField:AkiraTextField!
    @IBOutlet weak var rentalPriceField:AkiraTextField!
    @IBOutlet weak var waterIndexField:AkiraTextField!
    @IBOutlet weak var electricIndexField:AkiraTextField!
    
    //Outlet of Roomer
    @IBOutlet weak var nameField: AkiraTextField!
    @IBOutlet weak var dateOfBirthField: AkiraTextField!
    @IBOutlet weak var identifyCardField: AkiraTextField!
    @IBOutlet weak var numPhoneField: AkiraTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var page: UIPageControl!
    
    @IBOutlet var buttons: [UIButton]!
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    var images = [UIImage]()
    var frameForPage = CGRect(x: 0, y: 0, width: 0, height: 0)
    var isAddProfileImage:Bool!
    
    var datePicker:UIDatePicker!
    var room:Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons{
            button.layer.cornerRadius = 3
            button.layer.shadowOpacity = 0.4
        }
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "vi")
        setupView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
        if images.count == 0{
            return
        }
        setupScrollView()
        
    }
    
    

    
    //MARK: -- SETUP FUNC
    func setupView(){
        rentalPriceField.text = String(room.rentalPrice)
        self.title = room.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        contractSigningDateField.text = dateFormatter.string(from: Date())
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        switch true {
        case dayStartAtField.isEditing:
            dayStartAtField.text = dateFormatter.string(from: datePicker.date)
        case dayEndAtField.isEditing:
            dayEndAtField.text = dateFormatter.string(from: datePicker.date)
        case contractSigningDateField.isEditing:
            contractSigningDateField.text = dateFormatter.string(from: datePicker.date)
        case dateOfBirthField.isEditing:
            dateOfBirthField.text = dateFormatter.string(from: datePicker.date)
        default:
            break
        }
        cancelClick()
        
    }
    
    @objc func cancelClick(){
        dayStartAtField.resignFirstResponder()
        dayEndAtField.resignFirstResponder()
        contractSigningDateField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
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
    func setupScrollView(){
        scrollView.isHidden = false
        page.isHidden = false
        
        page.numberOfPages = images.count
        for i in 0..<images.count{
            frameForPage.origin.x = scrollView.frame.size.width * CGFloat(i)
            frameForPage.size = scrollView.frame.size
            let imageV = UIImageView(frame: frameForPage)
            imageV.image = images[i]
            scrollView.addSubview(imageV)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.width * CGFloat(images.count)), height: scrollView.frame.height)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        page.currentPage = Int(pageNumber)
    }
    
    
    //MARK: Setup UIImagePickerDelegate
    @objc func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                if isAddProfileImage{
                    profileImageView.image = image
                }else{
                images.append(image!)
                }
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
    
    
    //MARK: -- ACTION FUNC
    @IBAction func textFieldBeginEditting(_ sender: Any) {
        
        (sender as! UITextField).inputView = datePicker
        (sender as! UITextField).inputAccessoryView = setupToolBar()
    }
    
    
    
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        cancelClick()
        despoistField.resignFirstResponder()
        rentalPriceField.resignFirstResponder()
        waterIndexField.resignFirstResponder()
        electricIndexField.resignFirstResponder()
        nameField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
        identifyCardField.resignFirstResponder()
        numPhoneField.resignFirstResponder()
        
    }
    
    @IBAction func createContract(_ sender: Any) {
        
        if nameField.text?.isEmpty == true || despoistField.text?.isEmpty == true || rentalPriceField.text?.isEmpty == true || waterIndexField.text?.isEmpty == true || electricIndexField.text?.isEmpty == true || dateOfBirthField.text?.isEmpty == true || identifyCardField.text?.isEmpty == true || numPhoneField.text?.isEmpty == true || images.count == 0 || profileImageView.image == nil || dayEndAtField.text?.isEmpty == true || dayStartAtField.text?.isEmpty == true || contractSigningDateField.text?.isEmpty == true{
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        //create contract
        var contract = Contract()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        contract.contractSigningDate = dateFormatter.date(from: contractSigningDateField.text!)
        contract.dayStartAt = dateFormatter.date(from: dayStartAtField.text!)
        contract.dayEndAt = dateFormatter.date(from: dayEndAtField.text!)
        contract.desposit = UInt32(despoistField.text!)
        contract.rentalPrice = UInt32(rentalPriceField.text!)
        contract.nameRoomer = nameField.text
        var firstIndex = Index()
        firstIndex.waterIndex = Int(waterIndexField.text!)
        firstIndex.electricIndex = Int(electricIndexField.text!)
        firstIndex.date = contract.contractSigningDate
        contract.index = firstIndex
        //create roomer
        var roomer = Roomer()
        roomer.dateOfBirth = dateFormatter.date(from: dateOfBirthField.text!)
        roomer.name = nameField.text
        roomer.identifyCard = identifyCardField.text
        roomer.numPhone = numPhoneField.text
        roomer.roomID = room.id
        roomer.identityImageString = [String]()
        for imageTemp in images{
            let idImage = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("imagesOfMotels/\(idImage).jpg")
            let data = imageTemp.jpegData(compressionQuality: 1)
            if data != nil{
                storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                }
                roomer.identityImageString.append("\(idImage).jpg")
            }
        }
        let idImage = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("imagesOfMotels/\(idImage).jpg")
        let data = profileImageView.image?.jpegData(compressionQuality: 1)
        if data != nil{
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
            }
            roomer.profileImageString = "\(idImage).jpg"
        }
        ListOfMotel.shared.addRoomer(newRoomer: roomer)
        ListOfMotel.shared.addContract(contract: contract)
        
        let uid = Auth.auth().currentUser?.uid
        do{
            let data = try FirebaseEncoder().encode(ListOfMotel.shared.listMotel)
            Database.database().reference().child("user/\(uid!)/listOfMotels").setValue(data)
        }catch{
            print(error)
        }
        
        
        
        
        let alert = UIAlertController(title: "Tạo hợp đồng thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func addProfileImage(_ sender: Any) {
        isAddProfileImage = true
        showActionSheet()
    }
    
    @IBAction func addIdentifyCardImage(_ sender: Any) {
        isAddProfileImage = false
        showActionSheet()
    }
    
}
