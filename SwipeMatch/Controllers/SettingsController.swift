//
//  SettingsControllerTableViewController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 18/11/2023.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePicker: UIImagePickerController{
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePicker)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    //instance properties
    lazy var imageButton1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton3 = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton){
        let imagePicker = CustomImagePicker()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        tableView.backgroundColor = .init(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUsers()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUsers(){
        // Data from uid of firebase
        guard let uid = Auth.auth().currentUser?.uid else {return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return }
            self.user = User(dictionary: dictionary)
            self.loadUsersPhoto()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUsersPhoto(){
        guard let imageURL = user?.imageURL1, let url = URL(string: imageURL) else { return }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: - Header
    lazy var header = {
        let header = UIView()
        
        header.addSubview(imageButton1)
        imageButton1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        imageButton1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageButton2,imageButton3])
        header.addSubview(stackView)
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.anchor(top: header.topAnchor, leading: imageButton1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        return header
    }()
    
    // Cell information
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Username"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        return headerLabel
}

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
            return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter username"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter age"
            if let age = user?.age{
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        default:
            cell.textField.placeholder = "Enter bio"
        }
        return cell
    }
    
    @objc fileprivate func handleNameChange(tf : UITextField){
        self.user?.name = tf.text
    }
    
    @objc fileprivate func handleProfessionChange(tf : UITextField){
        self.user?.profession = tf.text
    }
    
    @objc fileprivate func handleAgeChange(tf : UITextField){
        self.user?.age = Int(tf.text ?? "")
    }
    
    // Navbar
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
            }
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String : Any] = [
            "uid": uid,
            "username": user?.name ?? "",
            "imageURL": user?.imageURL1 ?? "",
            "age" : user?.age ?? -1,
            "profession" : user?.profession ?? ""
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving information..."
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err{
                print("Failed to save :",err)
                return
            }
            
            print("Save info successfully!")
        }

    }
    
}
