//
//  CreateRoomController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/1/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Firebase
import FirebaseStorage
import CodableFirebase
import TextFieldEffects

class CreateRoomController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var nameField: AkiraTextField!
    @IBOutlet weak var areaField: AkiraTextField!
    @IBOutlet weak var rentalPriceField: AkiraTextField!
    
    
    @IBOutlet weak var maxRoomerField: AkiraTextField!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var creatAndUpdateButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    var isCreating = false
    var currentRoom:Room!
    
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    var images = [UIImage]()
    var frameForPage = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if isCreating{
            creatAndUpdateButton.setTitle("Thêm phòng", for: .normal)
        }else{
            creatAndUpdateButton.setTitle("Cập nhật", for: .normal)
            currentRoom = ListOfMotel.shared.getCurrentRoom()
            setupView()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
        if images.count == 0{
            return
        }
        setupScrollView()
    }
    
    
    
    //MARK: ACTION
    
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        nameField.resignFirstResponder()

        maxRoomerField.resignFirstResponder()
        rentalPriceField.resignFirstResponder()
        areaField.resignFirstResponder()
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        nameField.resignFirstResponder()
    }
    
    @IBAction func addImage(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func onCreateAndUpdateButtonPressed(_ sender: Any) {
        if nameField.text?.isEmpty == true ||  maxRoomerField.text?.isEmpty == true || rentalPriceField.text?.isEmpty == true || areaField.text?.isEmpty == true || images.count == 0{
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if isCreating{
            handleCreateRoom()
            return
        }
        handleUpdateRoom()
    }
    
    //MARK: -- Picker delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
    //MARK: HELPER METHOD
    
    func setupUI(){
        addImageButton.layer.cornerRadius = 3
        addImageButton.layer.shadowOpacity = 1
        creatAndUpdateButton.layer.cornerRadius = 5
        creatAndUpdateButton.layer.shadowOpacity = 1
    }
    
    func handleCreateRoom(){
        var newRoom = Room()
        newRoom.name = nameField.text
        newRoom.maxRoomer = Int(maxRoomerField.text!) ?? 0
        newRoom.area = Float(areaField.text!) ?? 0
        newRoom.rentalPrice = UInt32(rentalPriceField.text!) ?? 0
        
        newRoom.isStaying = false
        
        newRoom.imagesStringURL = [String]()
        for imageTemp in images{
            let idImage = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("imagesOfRooms/\(idImage).jpg")
            let data = imageTemp.jpegData(compressionQuality: 1)
            if data != nil{
                storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                }
                newRoom.imagesStringURL.append("\(idImage).jpg")
            }
        }
        
        
        
        let uid = Auth.auth().currentUser?.uid
        
        newRoom.id = Database.database().reference().childByAutoId().key
        ListOfMotel.shared.addRoom(room: newRoom)
        do{
            let data = try FirebaseEncoder().encode(ListOfMotel.shared.listMotel)
            Database.database().reference().child("user/\(uid!)/listOfMotels").setValue(data)
        }catch{
            print(error)
        }
        
        let alert = UIAlertController(title: "Tạo phòng thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleUpdateRoom(){
        currentRoom.name = nameField.text
        currentRoom.area = Float(areaField.text!) ?? 0
        currentRoom.maxRoomer = Int(maxRoomerField.text!) ?? 0
        currentRoom.rentalPrice = UInt32(rentalPriceField.text!) ?? 0
        
        
        if currentRoom.imagesStringURL == nil{
            currentRoom.imagesStringURL = [String]()
        }
        
        let beginingIndex = currentRoom.imagesStringURL.count
        for index in beginingIndex..<images.count{
            let idImage = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("imagesOfRooms/\(idImage).jpg")
            let data = images[index].jpegData(compressionQuality: 1)
            if data != nil{
                storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                }
                currentRoom.imagesStringURL.append("\(idImage).jpg")
            }
        }
        
        ListOfMotel.shared.updateRoom(newRoom: currentRoom)
        
        let uid = Auth.auth().currentUser?.uid
        
        
        do{
            let data = try FirebaseEncoder().encode(ListOfMotel.shared.listMotel)
            Database.database().reference().child("user/\(uid!)/listOfMotels").setValue(data)
        }catch{
            print(error)
        }
        
        let alert = UIAlertController(title: "Cập nhật thông tin thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MART: setup func
    
    func setupView(){
        guard let currentRoom = currentRoom else {
            return
        }
        
        nameField.text = currentRoom.name
        areaField.text = String(currentRoom.area)
        rentalPriceField.text = String(currentRoom.rentalPrice)
        maxRoomerField.text = String(currentRoom.maxRoomer)
        if currentRoom.imagesStringURL == nil{
            return
        }
        for imageString in currentRoom.imagesStringURL{
            let storageRef = Storage.storage().reference().child("imagesOfRooms/\(imageString)")
            storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
                if error != nil{
                    print(error!)
                }else{
                    self.images.append(UIImage(data: data!)!)
                    if self.images.count == currentRoom.imagesStringURL.count{
                        DispatchQueue.main.async {
                            self.setupScrollView()
                        }
                        
                    }
                }
                
            }
        }
        
    }
    
    
    
    
    
    
   // ADD IMAGE HELPER FUNC
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
