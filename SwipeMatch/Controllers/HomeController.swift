//
//  ViewController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 03/11/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate{
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControl = HomeButtonControlsStackView()
    
    var cardViewModel = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControl.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //kick out the user
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    fileprivate var user: User?
    func fetchCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return }
            self.user = User(dictionary: dictionary)
            self.fetchUserFromFirestore()
        }
    }
    
    @objc fileprivate func handleSettings(){
        let settings = SettingsController()
        let navController = UINavigationController(rootViewController: settings)
        settings.delegate = self
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUserFromFirestore()
    }
    
    //Fetch from firestore
    var lastFetchedUser: User?
    fileprivate func fetchUserFromFirestore(){
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching more users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isLessThanOrEqualTo: maxAge).whereField("age", isGreaterThanOrEqualTo: minAge)
            
        query.getDocuments { (snapshot, err) in
            hud.dismiss(animated: true)
            if let err = err{
                print("Fetch users data fail: ", err)
                return
            }
            
            snapshot?.documents.forEach({ (snapshotDocuments) in
                let usersDictionary = snapshotDocuments.data()
                let user = User(dictionary: usersDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo() {
        let userDetailsController = UserDetailsController()
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
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

