//
//  ViewController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 03/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let topStackView = TopNavigationStackView()
        
        let midView = UIView()
        midView.backgroundColor = .cyan
       
        let bottomStackView = HomeButtonControlsStackView()
        
        let overallStackview = UIStackView(arrangedSubviews: [topStackView,midView,bottomStackView] )
        view.addSubview(overallStackview)
        overallStackview.axis = .vertical
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
    }
}

