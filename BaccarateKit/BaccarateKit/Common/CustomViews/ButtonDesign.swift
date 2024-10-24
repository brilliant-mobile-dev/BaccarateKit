//
//  ButtonDesign.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 09/09/23.
//

import UIKit

@IBDesignable
class ButtonDesign: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    func updateView() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
    }
}
