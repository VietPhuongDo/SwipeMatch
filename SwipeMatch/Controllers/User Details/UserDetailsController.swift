//
//  UserDetailsController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 23/11/2023.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet{
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotoController.cardViewModel = cardViewModel
        }
    }
    
    // layout instances
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    let swipingPhotoController = SwipingPhotoViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "down_icon")!.withRenderingMode(.alwaysOriginal) , for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    //Create button bar
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton{
        let button = UIButton(type:.system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill 
        return button
    }
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    @objc fileprivate func handleDislike(){
        
    }
    
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleLike))
    @objc fileprivate func handleLike(){
        
    }
    
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleSuperLike))
    @objc fileprivate func handleSuperLike(){
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControl()
    }
    
    fileprivate func setupVisualBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let imageView = swipingPhotoController.view!
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -35, left: 0, bottom: 0, right: 35), size: .init(width: 70, height: 70))
    }
    
    fileprivate func setupBottomControl(){
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, likeButton, superLikeButton])
        view.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50 , right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc fileprivate func handleTapDismiss(){
            self.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        var width = view.frame.width - changeY * 2
        let swipingView = swipingPhotoController.view!
        width = max(view.frame.width, width)
        swipingView.frame = CGRect(x: min(0, changeY), y: min(0, changeY), width: width, height: width)
    }
}
