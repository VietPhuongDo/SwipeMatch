//
//  CustomTextField.swift
//  SwipeMatch
//
//  Created by PhuongDo on 10/11/2023.
//

import UIKit

class CustomTextField:UITextField {
    var padding: CGFloat
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        layer.cornerRadius = 20
        backgroundColor = .white
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
