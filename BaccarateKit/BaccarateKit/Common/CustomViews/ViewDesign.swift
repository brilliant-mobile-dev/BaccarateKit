//
//  ViewDesign.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/09/23.
//

import UIKit
import Lottie

@IBDesignable
class LineView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    func updateView() {
        let gradientLayer = CAGradientLayer()
            // Set the colors and locations for the gradient layer
        let color1 = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        let color2 = UIColor(red: 255, green: 255, blue: 255, alpha: 0.25)
        let color3 = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        let color4 = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 1.0]
//        rgba(255, 255, 255, 0)
//        rgba(255, 255, 255, 0.25)
//        rgba(255, 255, 255, 0)
//        rgba(255, 255, 255, 1)
            // Set the start and end points for the gradient layer
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

            // Set the frame to the layer
            gradientLayer.frame = self.frame

            // Add the gradient layer as a sublayer to the background view
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
@IBDesignable
class ViewDesign: UIView {
    
    var loadingView: LottieAnimationView?
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var topCornered: Bool = false {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if topCornered {
            let path = UIBezierPath(roundedRect: CGRect(x: bounds.minX, y: bounds.minY, width: Utils.screenWidth, height: bounds.height),
                                    byRoundingCorners:[.topRight, .topLeft],
                                    cornerRadii: CGSize(width: cornerRadius, height:  cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        } else {
            layer.cornerRadius = cornerRadius
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = borderWidth
            clipsToBounds = true
        }
    }
}

extension ViewDesign {
    func removeShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.0
        layer.shouldRasterize = false
        layer.rasterizationScale = 0
    }
    func dropShadow(color: UIColor, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    // With Lottie Files
    func showMarqueAnimation() {
        hideMarqueAnimation()
        loadingView = LottieAnimationView(name: "card_indicator")
        loadingView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        loadingView?.contentMode = .scaleToFill
        loadingView?.loopMode = .loop
        loadingView?.animationSpeed = 1.5
        loadingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(loadingView!)
        loadingView?.play()
    }
    func hideMarqueAnimation() {
        loadingView?.removeFromSuperview()
    }
}

// UIView Blink Animation

extension UIView: CAAnimationDelegate {
    func startBlinking(blinkCount: Float) {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        flash.isRemovedOnCompletion = true
        flash.delegate = self
       layer.add(flash, forKey: "blinkLayer")
    }
    func removeBlink() {
        if let imgView = self as? UIImageView {
            imgView.image = UIImage(named: "")
        }
        self.layer.removeAllAnimations()
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers! {
                if layer.name == "blinkLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    // MARK: CAAnimation Delegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            removeBlink()
        }
    }
}
