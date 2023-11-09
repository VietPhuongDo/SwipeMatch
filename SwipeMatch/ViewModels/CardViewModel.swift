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

struct CardViewModel{
    // define the properties that are the view will display
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}
