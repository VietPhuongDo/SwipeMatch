//
//  RegistrationController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 10/11/2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ){
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    // Setup UI
    let photoPickerButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Select photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 250).isActive = true
        button.layer.cornerRadius = 20
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    // present pickerPhotoView
    @objc fileprivate func handleSelectPhoto(){
        let photoPickerController = UIImagePickerController()
        photoPickerController.delegate = self
        photoPickerController.modalPresentationStyle = .fullScreen
        present(photoPickerController, animated: true)
    }

    let usernameTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()

    let gmailTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your gmail", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()

    let passwordTextField:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // Form valid observer
    @objc fileprivate func handleTextChange(textField: UITextField){
        if textField == usernameTextField{
            registrationViewModel.username = textField.text
        }
        else if textField == passwordTextField{
            registrationViewModel.password = textField.text
        }
        else{
            registrationViewModel.gmail = textField.text
        }
    }

    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleRegisterFirebase), for: .touchUpInside)
        return button
    }()
    
    // register on firebase
    @objc fileprivate func handleRegisterFirebase(){
        self.handleTapDismiss()
        print("Register on Firebase")
        guard let gmail = gmailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else{
            return
        }
        Auth.auth().createUser(withEmail: gmail, password: password) { (res, err) in
            if let err = err{
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            print("Successfully register user:",res?.user.uid ?? "")
        }
    }
    
    // show error on screen
    fileprivate func showHUDWithError(error: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
//MARK: -setup layout
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupGradient()
            setupLayout()
            setupNotificationCenter()
            setupTapGesture()
            setupRegistrationViewModelObserver()
        }
    
    //Valid Register
    let registrationViewModel = RegistrationViewModel()
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else {return}
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.6196078431, blue: 1, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (img) in
            self.photoPickerButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }

    }
        
    //MARK: - Handle keyboard dismiss
            fileprivate func setupTapGesture(){
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
            }
    
            @objc fileprivate func handleTapDismiss(){
                self.view.endEditing(true)
            }
    //MARK: - Handle stackView when toggle keyboard
            fileprivate func setupNotificationCenter(){
                //add observer when keyboard show
                NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                //add observer when keyboard hide
                NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            
            // remove observer to have a retain cycle
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                NotificationCenter.default.removeObserver(self)
            }
            
            @objc fileprivate func handleKeyboardShow(notification: Notification){
                guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
                    return
                }
                let keyboardFrame = value.cgRectValue
                let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
                let difference = keyboardFrame.height - bottomSpace
                // Toggle up the stackView when the keyboard shown
                UIView.animate(withDuration: 0.2) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
                }
            }
            
            // Reset the position when the keyboard is dismissed
            @objc fileprivate func handleKeyboardHide(notification: Notification){
                UIView.animate(withDuration: 0.2) {
                    self.view.transform = .identity
                }
            }
           
    //MARK: - Add view and gradient layer
        lazy var stackView = UIStackView(arrangedSubviews: [photoPickerButton,usernameTextField,gmailTextField,passwordTextField,registerButton])
        
        fileprivate func setupLayout(){
            view.addSubview(stackView)
            stackView.spacing = 12
            stackView.axis = .vertical
            stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
        }

        fileprivate func setupGradient(){
            let gradientLayer = CAGradientLayer()
            let color1 = #colorLiteral(red: 1, green: 0.7700536847, blue: 0.7738657594, alpha: 1)
            let color2 = #colorLiteral(red: 0.9803921569, green: 0.8901960784, blue: 0.8509803922, alpha: 1)
            let color3 = #colorLiteral(red: 0.7333333333, green: 0.8705882353, blue: 0.8392156863, alpha: 1)
            let color4 = #colorLiteral(red: 0.3803921569, green: 0.7529411765, blue: 0.7490196078, alpha: 1)
            //must use cgColor
            gradientLayer.colors = [color1.cgColor,color2.cgColor,color3.cgColor,color4.cgColor]
            view.layer.addSublayer(gradientLayer)
            gradientLayer.frame = view.bounds
        }

}




