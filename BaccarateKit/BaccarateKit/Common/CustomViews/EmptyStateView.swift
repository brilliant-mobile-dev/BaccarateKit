//
//  EmptyStateView.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 19/10/23.
//

import UIKit

class EmptyStateView: UIView {
    private override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.font = .appFont(family: .demibold, size: 15)
        label.textAlignment = .center
        return label
    }()
    
    let imageViewIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    let tryAgainButton: UIButton = {
        let btn = UIButton()
        let titleText = NSAttributedString(string: "Retry".localizable,
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: UIFont.appFont(family: .demibold, size: 16)])
        
        btn.setAttributedTitle(titleText, for: .normal)
        btn.backgroundColor = UIColor(hex: "4A8AFF")
        btn.layer.cornerRadius = 8
        btn.isUserInteractionEnabled = true
        btn.clipsToBounds = true
        return btn
    }()
    
    private func setupView() {
        addSubview(titleLbl)
        addSubview(imageViewIcon)
        addSubview(tryAgainButton)
        isHidden = true
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageViewIcon.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            imageViewIcon.bottomAnchor.constraint(equalTo: titleLbl.topAnchor, constant: -5),
            imageViewIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageViewIcon.heightAnchor.constraint(equalToConstant: 180),
            imageViewIcon.widthAnchor.constraint(equalToConstant: 180),
            
            titleLbl.topAnchor.constraint(equalTo: imageViewIcon.bottomAnchor, constant: 16),
            titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLbl.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20),
            tryAgainButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            tryAgainButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 40),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    func showView(type: EmptyType, title: String?) {
        if isHidden == false {
            isHidden = true
        }
        isHidden = false
        switch type {
            case .general:
                if let text = title {
                    titleLbl.text = text 
                } else {
                    titleLbl.text = "No data available".localizable
                }
                imageViewIcon.image = UIImage(named: "no_data")
            case .internet:
                titleLbl.text = "The Internet connection appears to be offline.".localizable
                imageViewIcon.image = UIImage(named: "no_data")
            case .timeOut:
                titleLbl.text = "Connection timed out".localizable
                imageViewIcon.image = UIImage(named: "no_data")
        }
    }
    func hideView() {
        isHidden = true
    }
}

enum EmptyType {
    case general
    case internet
    case timeOut
}
