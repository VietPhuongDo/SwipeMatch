//
//  ViewController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 03/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControl = HomeButtonControlsStackView()
    
    var cardViewModel = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControl.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupFirestoreUsersCard()
        fetchUserFromFirestore()
    }
    
    @objc fileprivate func handleSettings(){
        let registrastionController = RegistrationController()
        registrastionController.modalPresentationStyle = .fullScreen
        present(registrastionController, animated: true)
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUserFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUserFromFirestore(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching more users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users")
            .order(by: "uid")
            .start(after: [lastFetchedUser?.uid ?? ""])
            .limit(to: 2)
        query.getDocuments { (snapshot, err) in
            hud.dismiss(animated: true)
            if let err = err{
                print("Fetch users data fail: ", err)
                return
            }
            
            snapshot?.documents.forEach({ (snapshotDocuments) in
                let usersDictionary = snapshotDocuments.data()
                let user = User(dictionary: usersDictionary)
                self.cardViewModel.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    //MARK: - Setup card
    fileprivate func setupFirestoreUsersCard(){
        cardViewModel.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
    }
    
    //MARK: - Setup layout
    fileprivate func setupLayout() {
        let overallStackview = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomControl] )
        view.addSubview(overallStackview)
        overallStackview.axis = .vertical
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackview.isLayoutMarginsRelativeArrangement = true
        overallStackview.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackview.bringSubviewToFront(cardsDeckView)
    }
    
}

