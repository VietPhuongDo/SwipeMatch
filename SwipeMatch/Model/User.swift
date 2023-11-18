//
//  User.swift
//  SwipeMatch
//
//  Created by PhuongDo on 07/11/2023.
//

import UIKit

struct User: ProduceCardViewModel {
    //define model
    var name: String?
    var age: Int?
    var profession: String?
    var imageURL1: String?
    var uid: String?
    
    init(dictionary: [String:Any]) {
        //Initialize user
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"]  as? String
        self.name = dictionary["username"] as? String ?? ""
        self.imageURL1 = dictionary["imageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString(string: "\(name!)", attributes: [.font:UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        attributeText.append(NSMutableAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = (profession != nil) ? "\(profession!)" : "Not available"
        attributeText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attributeText, textAlignment: .left)
    }
    
}
