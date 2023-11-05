//
//  TopNavigationStackView.swift
//  SwipeMatch
//
//  Created by PhuongDo on 06/11/2023.
//

import UIKit

class TopNavigationStackView: UIStackView {
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        fireImageView.contentMode = .scaleAspectFit
        settingButton.setImage(#imageLiteral(resourceName:"top_left_profile").withRenderingMode(.alwaysOriginal) , for: .normal)
        messageButton.setImage(#imageLiteral(resourceName:"top_right_messages").withRenderingMode(.alwaysOriginal) , for: .normal)
        
        [settingButton,UIView(),fireImageView,UIView(),messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .equalSpacing
        
        //add margin
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
