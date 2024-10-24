//
//  TextfieldDesign.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 07/09/23.
//

import UIKit

@IBDesignable
class TextfieldDesign: UITextField {
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    func updateView() {
        if let image = rightImage {
            rightViewMode = .always
            let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let containerView = UIView(frame: frame)
            let imageView = UIImageView(frame: CGRect(x: -8, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = .center
            containerView.addSubview(imageView)
            rightView = containerView
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(activateTextfield))
            rightView?.addGestureRecognizer(tap)
        } else {
            rightViewMode = .never
            rightView = nil
        }
    }
    @objc func activateTextfield() {
        becomeFirstResponder()
    }
    // Disable select, cut, copy, paste actions
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

@IBDesignable
class PasswordTFDesign: UITextField {
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    func updateView() {
        if let image = rightImage {
            isSecureTextEntry = true
            rightViewMode = .always
            let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let containerView = UIView(frame: frame)
            let imageView = UIImageView(frame: CGRect(x: -8, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = .center
            containerView.addSubview(imageView)
            rightView = containerView
        } else {
            rightViewMode = .never
            rightView = nil
        }
    }
    // Disable select, cut, copy, paste actions
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
