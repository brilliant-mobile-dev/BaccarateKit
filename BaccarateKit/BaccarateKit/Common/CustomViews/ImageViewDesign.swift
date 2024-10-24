//
//  ImageViewDesign.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import UIKit

@IBDesignable
class ImageViewDesign: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    func updateView() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
