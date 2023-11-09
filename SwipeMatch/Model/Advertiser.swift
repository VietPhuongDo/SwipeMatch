//
//  Advertiser.swift
//  SwipeMatch
//
//  Created by PhuongDo on 09/11/2023.
//

import UIKit

struct Advertiser: ProduceCardViewModel{
    let title: String
    let brandName: String
    let posterName: String
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: brandName, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy )])
        attributedText.append(NSMutableAttributedString(string: "\n\(title)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageNames: [posterName], attributedString: attributedText, textAlignment: .center)
    }
}


