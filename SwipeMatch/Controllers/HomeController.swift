//
//  ViewController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 03/11/2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeButtonControlsStackView()
    
    let cardViewModel: [CardViewModel] = {
        let produce: [ProduceCardViewModel] = [
            User(name: "Lenin", age: 23, profession: "IT", imageNames: ["nam1","nam2","nam3"]),
            User(name: "Jane", age: 18, profession: "Marketing", imageNames: ["jane1","jane2","jane3"]),
            Advertiser(title: "Delicious and Refreshing", brandName: "Cocacola", posterName: "advertise1"),
            User(name: "Kelly", age: 20, profession: "Đì chây", imageNames: ["kelly1","kelly2","kelly3"])
        ]
        let viewModels = produce.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
        setupCards()
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
    }
    
    @objc func handleSetting(){
        let registrationController = RegistrationController()
        registrationController.modalPresentationStyle = .fullScreen
        present(registrationController, animated: true)
    }
    
    //MARK: - Setup card
    fileprivate func setupCards(){
        cardViewModel.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    //MARK: - Setup layout
    fileprivate func setupLayout() {
        let overallStackview = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView] )
        view.addSubview(overallStackview)
        overallStackview.axis = .vertical
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackview.isLayoutMarginsRelativeArrangement = true
        overallStackview.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackview.bringSubviewToFront(cardsDeckView)
    }
    
}

