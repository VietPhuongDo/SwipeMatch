//
//  RegistrationViewModel.swift
//  SwipeMatch
//
//  Created by PhuongDo on 14/11/2023.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var username: String? {
        didSet {
            checkFormValidity()
        }
    }
    var gmail: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = username?.isEmpty == false && gmail?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    var bindableIsFormValid = Bindable <Bool>()
    
}

