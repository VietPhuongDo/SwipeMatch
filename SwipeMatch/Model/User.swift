//
//  User.swift
//  SwipeMatch
//
//  Created by PhuongDo on 07/11/2023.
//

import UIKit

struct User: ProduceCardViewModel {
    //define model
    let name: String
    let age: Int
    let profession: String
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString(string: "\(name)", attributes: [.font:UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributeText.append(NSMutableAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributeText.append(NSMutableAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attributeText, textAlignment: .left)
    }
    
}
