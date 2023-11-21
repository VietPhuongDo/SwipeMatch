//
//  RegistrationViewModel.swift
//  SwipeMatch
//
//  Created by PhuongDo on 14/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class RegistrationViewModel {
   
    var bindableImage = Bindable<UIImage>()
    
    // info observer
    var username: String? { didSet { checkFormValidity() } }
    var gmail: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // Firebase observer
    var bindableIsRegistering = Bindable<Bool>()
    func performRegistration(completion: @escaping (Error?) -> ()){
        guard let gmail = gmail else {return}
        guard let password = password else {return}
        bindableIsRegistering.value = true
        // Register to firebase
        Auth.auth().createUser(withEmail: gmail, password: password) { (res, err) in
            if let err = err{
                completion(err)
                return
            }
            print("Successfully register user:",res?.user.uid ?? "")
            
            self.SaveImageOnFirebase(completion: completion)
        }
    }
    
    //Upload avatar to Firebase Storage
    fileprivate func SaveImageOnFirebase(completion:@escaping (Error?) -> ()){
        let filename = UUID().uuidString
        let ref = Storage.storage().reference().child("/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData( compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil, completion:{ (_, err) in
            if let err = err{
                completion(err)
                return
            }
            print("Finish registering user!")
            
        print("Upload image firebase storage successfully!")
            ref.downloadURL( completion: { (url, err) in
                if let err = err{
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                
                let imageURL1 = url?.absoluteString ?? ""
                self.saveInformationToFirestore(imageURL1: imageURL1,completion: completion)
                completion(nil)
            })
            
        })
    }
    
    fileprivate func saveInformationToFirestore(imageURL1: String,completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid  ?? ""
        let docData = ["username":username ?? "", "uid":uid , "imageURL1":imageURL1]
        Firestore.firestore().collection("users").document(uid).setData(docData){ (err) in
            if let err = err{
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    // formValid observer
    var bindableIsFormValid = Bindable <Bool>()
    fileprivate func checkFormValidity() {
        let isFormValid = username?.isEmpty == false && gmail?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
}

