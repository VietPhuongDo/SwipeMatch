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
    // 3 images
    var imageURL1: String?
    var imageURL2: String?
    var imageURL3: String?
    var uid: String?
    // seeking age
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    
    init(dictionary: [String:Any]) {
        //Initialize user
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"]  as? String
        self.name = dictionary["username"] as? String ?? ""
        self.imageURL1 = dictionary["imageURL1"] as? String
        self.imageURL2 = dictionary["imageURL2"] as? String
        self.imageURL3 = dictionary["imageURL3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributeText = NSMutableAttributedString(string: "\(name!)", attributes: [.font:UIFont.systemFont(ofSize: 28, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        attributeText.append(NSMutableAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = (profession != nil) ? "\(profession!)" : "Not available"
        attributeText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        var imageURLs = [String]()
        if let url = imageURL1 {imageURLs.append(url)}
        if let url = imageURL2 {imageURLs.append(url)}
        if let url = imageURL3 {imageURLs.append(url)}
        
        return CardViewModel(imageNames: imageURLs, attributedString: attributeText, textAlignment: .left)
    }
    
}
