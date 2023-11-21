//
//  CardView.swift
//  SwipeMatch
//
//  Created by PhuongDo on 06/11/2023.
//

import UIKit
import SDWebImage

class CardView: UIView {
    //Encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    //Config
    fileprivate let threshold: CGFloat = 80
    
    var cardViewModel: CardViewModel!{
        didSet{
            let imageName = cardViewModel.imageNames.first ?? ""
            if let url = URL(string: imageName){
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let v = UIView()
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
                imageStackBar.addArrangedSubview(v)
            }
            imageStackBar.arrangedSubviews.first?.backgroundColor = .white
            setupIndexObserver()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // add layout
        setupLayout()
        // add gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Layout
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        // add stackImageStackBar
        setupImageStackBar()
        // add gradient layer
        addGradientLayer()
        //add label
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    //MARK: - GradientLayer
    fileprivate func addGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1]
        layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - ImageBar
    fileprivate let imageStackBar = UIStackView()
    fileprivate func setupImageStackBar(){
        addSubview(imageStackBar)
        imageStackBar.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        imageStackBar.spacing = 5
        imageStackBar.distribution = .fillEqually
        
    }
    
    //MARK: - Tap Gesture
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldUpdatePhoto = tapLocation.x > self.frame.width / 2 ? true : false
        if shouldUpdatePhoto{
            cardViewModel.toNextImage()
        }
        else{
            cardViewModel.toPreviousImage()
        }
            }
    
    fileprivate func setupIndexObserver(){
        cardViewModel.imageIndexObserver = { (idx, imgURL) in
            if let url = URL(string: imgURL ?? ""){
                self.imageView.sd_setImage(with: url)
            }
            self.imageStackBar.arrangedSubviews.forEach { (v) in
                v.backgroundColor = .init(white: 0, alpha: 0.1)
            }
            (0..<idx+1).forEach { (i) in
                self.imageStackBar.arrangedSubviews[i].backgroundColor = .white
            }
        }
    }
    
    //MARK: - Pan Gesture
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
 
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations:  {
            if shouldDismissCard{
                self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            }
            else{
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
