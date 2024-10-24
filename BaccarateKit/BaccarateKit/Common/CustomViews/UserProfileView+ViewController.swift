//
//  UserProfileView+ViewController.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/09/23.
//

import Foundation
import UIKit

extension UIViewController {
    // Custom View to create user profile view
    func userProfileView(userInfo: UserInfo, color: UIColor, isNameRequired: Bool = true) -> (view: UIView, walletLabel: UILabel) {
        var walletTxtFontSize = 14.0
        if Display.typeIsLike == .iphone5 ||  Display.typeIsLike == .iphone6 {
            walletTxtFontSize = 11.0
        }
        let width = Utils.screenWidth/2
        var widthspace = 75.0
        if isNameRequired == true {
            widthspace = 75.0
        } else if Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 {
            widthspace = 75.0
        } else {
            widthspace = 100.0
        }
       //     ((Display.typeIsLike != .iphone5 && Display.typeIsLike != .iphone6) && isNameRequired == false) ? 100.0 : 75.0
      //  let widthspace = ((Display.typeIsLike == .iphone5 && Display.typeIsLike == .iphone6) && isNameRequired == false) ? 80.0 : 100.0
     //   let widthspace = 75.0
        let containerWidth = width - widthspace
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 32))
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: userInfo.headImgURL ?? ""), placeholderImage: UIImage(named: "user-avatar"), options: .continueInBackground, completed: nil)
        imageView.frame = CGRect(x: 5, y: 4, width: 24, height: 24)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        let nameLabel = UILabel(frame: CGRect(x: 33, y: 0, width: containerWidth - 43, height: 18))
        nameLabel.text = userInfo.username
        nameLabel.numberOfLines = 1
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true

       // nameLabel.backgroundColor = .green
        nameLabel.font = .appFont(family: .regular, size: walletTxtFontSize)
       // if color == .white {
            nameLabel.textColor = .white
       // }
        
        let walletLabel = UILabel(frame: CGRect(x: 33, y: (isNameRequired == false ? 0: 14), width: containerWidth - 43, height: (isNameRequired == false ? 32: 16)))
        walletLabel.text = (userInfo.symbol ?? "") + "\(userInfo.userMoney?.walletAmount ?? "")"
        walletLabel.font = .appFont(family: .demibold, size: walletTxtFontSize)
        walletLabel.textColor = color
       // walletLabel.sizeToFit()
        walletLabel.numberOfLines = 1
        walletLabel.adjustsFontSizeToFitWidth = true
        walletLabel.minimumScaleFactor = 0.5
       // walletLabel.backgroundColor = .cyan
       // walletLabel.textColor = color
        walletLabel.textColor = .white
        containerView.addSubview(imageView)
        if isNameRequired == true {
            containerView.addSubview(nameLabel)
        }
        containerView.addSubview(walletLabel)

        // ... Add Autolayouts
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        walletLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
//            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
//            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 38),
//            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
//            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
//        ])
//        walletLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            walletLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
//            walletLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
//            walletLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 38),
//            walletLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
//            walletLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
//        ])
//        
        // ... End Autolyouts
        return (view: containerView, walletLabel: walletLabel)
    }
}
