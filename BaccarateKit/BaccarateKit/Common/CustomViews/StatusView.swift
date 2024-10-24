//
//  StatusView.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 26/09/23.
//

import UIKit

class StatusView: UIView {
    private let imageV = UIImageView(image: UIImage(named: "StatusViewBG"))
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .appFont(family: .demibold, size: 18)
        label.numberOfLines = 3
        return label
    }()
    
    init(isDisplayBg: Bool) {
        super.init(frame: .zero)
        imageV.contentMode = .scaleToFill
        backgroundColor = .clear
        layer.cornerRadius = 10
        clipsToBounds = true
        if isDisplayBg == true {
            addSubview(imageV)
            imageV.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageV.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                imageV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                imageV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                imageV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                imageV.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
        } else {
            backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        }
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showStatus(_ message: String, duration: TimeInterval = 2.0) {
        label.text = message
        alpha = 0.0
        isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                self.alpha = 0.0
            }) { (_) in
                self.isHidden = true
            }
        }
    }
}
class ShowImageAnimation {
    static func showAnimation(imgView: UIImageView, imageIcon: String) {
              imgView.image = UIImage(named: imageIcon)
   //     imgView.startBlinking(blinkCount: 3)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .autoreverse, .repeat, .autoreverse, .beginFromCurrentState], animations: {
                    UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                        imgView.alpha = 0
                    }
                }) { dd in
                    imgView.alpha = 1
                    let imageIcon = "empty"
                    imgView.image = UIImage(named: imageIcon)
                }
    }
}
