//
//  CreateMotelController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/25/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Firebase
import FirebaseStorage
import CodableFirebase
import TextFieldEffects

class CreateMotelController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate  {
    
    //MARK: Global Var
    let sortMotelData = ["Tầng", "Dãy", "Khác"]
    let formLeaseData = ["Nguyên căn","Ở ghép, kí túc xá", "Khác"]
    var sortPicker:UIPickerView!
    var formLeasePicker:UIPickerView!
    var dayCalenderIndexPicker:UIPickerView!
    var dayCollectingRentPicker:UIPickerView!
    var isCreating:Bool!
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    var images = [UIImage]()
    var frameForPage = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //MARK: Outlet
    @IBOutlet weak var nameField: AkiraTextField!
    @IBOutlet weak var sortMotelField: AkiraTextField!
    @IBOutlet weak var formLeaseField: AkiraTextField!
    @IBOutlet weak var dayCalenderIndexField: AkiraTextField!
    @IBOutlet weak var dayCollectingRentField: AkiraTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var creatAndUpdateButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if isCreating{
            creatAndUpdateButton.setTitle("Thêm khu trọ", for: .normal)
        }else{
            creatAndUpdateButton.setTitle("Cập nhật", for: .normal)
            setupView()
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
        if images.count == 0{
            return
        }
        setupScrollView()
        
    }
    
    //MARK: Actions
    
    @IBAction func sortFieldBeginChanged(_ sender: Any) {
        
        sortPicker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200))
        sortPicker.tag = 0
        sortPicker.dataSource = self
        sortPicker.delegate = self
        (sender as! AkiraTextField).inputView = sortPicker
        
       
        
        (sender as! AkiraTextField).inputAccessoryView = setupToolBar()
        
    }
    
    @IBAction func formLeaseFieldBeginChanged(_ sender: Any) {
        formLeasePicker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200))
        formLeasePicker.tag = 1
        formLeasePicker.dataSource = self
        formLeasePicker.delegate = self
        (sender as! UITextField).inputView = formLeasePicker
        
        
        
        (sender as! UITextField).inputAccessoryView = setupToolBar()
        
    }
    
    @IBAction func dayCalenderIndexFieldBeginChanged(_ sender: Any) {
        
        
        dayCalenderIndexPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        dayCalenderIndexPicker.tag = 2
        dayCalenderIndexPicker.dataSource = self
        dayCalenderIndexPicker.delegate = self
        dayCalenderIndexField.inputView = dayCalenderIndexPicker
        dayCalenderIndexField.inputAccessoryView = self.setupToolBar()
    }
    
    @IBAction func dayCollectingRentFieldBeginChanged(_ sender: Any) {
        dayCollectingRentPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        dayCollectingRentPicker.tag = 3
        dayCollectingRentPicker.dataSource = self
        dayCollectingRentPicker.delegate = self
        dayCollectingRentField.inputView = dayCollectingRentPicker
        dayCollectingRentField.inputAccessoryView = self.setupToolBar()
    }
    @IBAction func nameFieldExit(_ sender: Any) {
        nameField.resignFirstResponder()
    }
    @IBAction func tapGestureRecognized(_ sender: Any) {
        nameField.resignFirstResponder()
        cancelClick()
    }
    
   
    
    @IBAction func addImage(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func addMotel(_ sender: Any) {
        
        if nameField.text?.isEmpty == true || sortMotelField.text?.isEmpty == true || dayCalenderIndexField.text?.isEmpty == true || dayCollectingRentField.text?.isEmpty == true || formLeaseField.text?.isEmpty == true || images.count == 0 {
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if isCreating{
            handleCreateMotel()
            return
        }
       handleUpdateMotel()
    }
    
    
    //MARK: helper method for add motel or update motel
    func handleCreateMotel(){
        var newMotel = Motel()
        newMotel.name = nameField.text
        newMotel.dayCalenderIndex = dayCalenderIndexPicker.selectedRow(inComponent: 0) + 1
        newMotel.dayCollectingRent = dayCollectingRentPicker.selectedRow(inComponent: 0) + 1
        newMotel.formLease = formLeaseField.text
        newMotel.sortMotel = sortMotelField.text
        var servicePrice = ServicePrices()
        servicePrice.electricPrice = 0
        servicePrice.waterPrice = 0
        
        newMotel.servicePrices = servicePrice
        newMotel.imagesStringURL = [String]()
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
                newMotel.imagesStringURL.append("\(idImage).jpg")
            }
        }
        
        
        
        let uid = Auth.auth().currentUser?.uid
        
        let newMotelRef = Database.database().reference().child("user/\(uid!)/listOfMotels").childByAutoId()
        newMotel.id = newMotelRef.key
        ListOfMotel.shared.addMotel(newMotel: newMotel)
        
        
       
       
        ListOfMotel.shared.saveDataToFirebase()
        
        let alert = UIAlertController(title: "Tạo khu trọ thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleUpdateMotel(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var motel = ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex]
        motel.name = nameField.text
        
        motel.dayCalenderIndex = Int(dayCalenderIndexField.text!)
        motel.dayCollectingRent = Int(dayCollectingRentField.text!)
        motel.formLease = formLeaseField.text
        motel.sortMotel = sortMotelField.text
        
        if motel.imagesStringURL == nil{
             motel.imagesStringURL = [String]()
        }
       
        let beginingIndex = motel.imagesStringURL.count
        for index in beginingIndex..<images.count{
            let idImage = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("imagesOfMotels/\(idImage).jpg")
            let data = images[index].jpegData(compressionQuality: 1)
            if data != nil{
                storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                }
                motel.imagesStringURL.append("\(idImage).jpg")
            }
        }
        
        ListOfMotel.shared.updateMotel(newMotel: motel)
        
        let uid = Auth.auth().currentUser?.uid
        
        
        do{
            let data = try FirebaseEncoder().encode(ListOfMotel.shared.listMotel)
            Database.database().reference().child("user/\(uid!)/listOfMotels").setValue(data)
        }catch{
            print(error)
        }
        
        let alert = UIAlertController(title: "Cập nhật khu trọ thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Picker data and delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return sortMotelData.count
        }else if pickerView.tag == 1{
            return formLeaseData.count
        }
        return 28
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return sortMotelData[row]
        }else if pickerView.tag == 1{
            return formLeaseData[row]
        }
        return "Ngày \(row + 1)"
    }
    
    //MARK: Helper method
    func setupView(){
        
        let motel = ListOfMotel.shared.listMotel[ListOfMotel.shared.currentMotelIndex]
        nameField.text = motel.name
        sortMotelField.text = motel.sortMotel
        formLeaseField.text = motel.formLease
        dayCalenderIndexField.text = String(motel.dayCalenderIndex)
        dayCollectingRentField.text = String(motel.dayCollectingRent)
        
        if motel.imagesStringURL == nil{
            return
        }
        for i in 0..<motel.imagesStringURL.count{
            let storageRef = Storage.storage().reference().child("imagesOfMotels/\(motel.imagesStringURL[i])")
            storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                if error != nil{
                    print(error!)
                }else{
                    self.images.append(UIImage(data: data!)!)
                    if self.images.count == motel.imagesStringURL.count{
                        DispatchQueue.main.async {
                            self.setupScrollView()
                        }
                        
                    }
                }
                
            }
        }
        
        
        
    }
    
    func setupUI(){
        addImageButton.layer.cornerRadius = 3
        addImageButton.layer.shadowOpacity = 0.7
        creatAndUpdateButton.layer.cornerRadius = 5
        creatAndUpdateButton.layer.shadowOpacity = 0.7
        
        
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
        case sortMotelField.isEditing:
            let index = sortPicker.selectedRow(inComponent: 0)
            sortMotelField.text = sortMotelData[index]
        case formLeaseField.isEditing:
            let index = formLeasePicker.selectedRow(inComponent: 0)
            formLeaseField.text = formLeaseData[index]
        case dayCalenderIndexField.isEditing:
            let index = dayCalenderIndexPicker.selectedRow(inComponent: 0)
            dayCalenderIndexField.text = "Ngày \(index + 1)"
        case dayCollectingRentField.isEditing:
            let index = dayCollectingRentPicker.selectedRow(inComponent: 0)
            dayCollectingRentField.text = "Ngày \(index + 1)"
        default:
            break
        }
       cancelClick()

    }
    
    @objc func cancelClick(){
        sortMotelField.resignFirstResponder()
        formLeaseField.resignFirstResponder()
        dayCalenderIndexField.resignFirstResponder()
        dayCollectingRentField.resignFirstResponder()
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
                images.append(image!)
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
   
}



