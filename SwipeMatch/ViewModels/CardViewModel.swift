//
//  CardViewModel.swift
//  SwipeMatch
//
//  Created by PhuongDo on 08/11/2023.
//

import UIKit

protocol ProduceCardViewModel{
    func toCardViewModel() -> CardViewModel
}

class CardViewModel{
    // define the properties that are the view will display
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    var imageIndex = 0{
        didSet{
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex,image)
        }
    }
    var imageIndexObserver: ((Int,UIImage?)->())?
    func toNextImage(){
        imageIndex = min(imageIndex+1,imageNames.count-1)
    }
    func toPreviousImage(){
        imageIndex = max(imageIndex-1,0)
    }
}
