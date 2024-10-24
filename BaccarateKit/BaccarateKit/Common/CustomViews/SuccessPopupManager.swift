//
//  SuccessPopupManager.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/10/23.
//

import UIKit
import Lottie

class SuccessPopupManager {
    static let shared = SuccessPopupManager()
    
    private var blurView: UIVisualEffectView?
    private let blurEffect = UIBlurEffect(style: .light)
    private var animationView = LottieAnimationView()
    private var successPopup = SuccessPopupView(header: "", price: "$0")
    
    private init() {} // Private initializer to ensure it's a singleton
    
    func setupLottieAnimation(on viewController: UIViewController) {
        animationView = .init(name: "success")
        animationView.frame = viewController.view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
        animationView.addGestureRecognizer(tap)
        viewController.view.addSubview(animationView)
        animationView.play()
    }
    
    func showSuccessPopup(on viewController: UIViewController, header: String, price: String) {
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView!.frame = viewController.view.bounds
        viewController.view.addSubview(blurView!)
        
        setupLottieAnimation(on: viewController)
        
        successPopup = SuccessPopupView(header: header, price: price)
        successPopup.translatesAutoresizingMaskIntoConstraints = false
        // Set up constraints and add to viewController's view
        
        successPopup.closeButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        
        viewController.view.addSubview(successPopup)
        NSLayoutConstraint.activate([
            successPopup.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            successPopup.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            successPopup.widthAnchor.constraint(equalToConstant: viewController.view.frame.width - 60),
            successPopup.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        UIView.animate(withDuration: 1) {
            self.successPopup.alpha = 1
        } completion: { _ in
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hidePopup()
        }
    }
    
    @objc func hidePopup() {
        UIView.animate(withDuration: 0.3) {
            self.successPopup.alpha = 0
            self.animationView.stop()
        } completion: { _ in
            self.blurView?.removeFromSuperview()
            self.successPopup.removeFromSuperview()
            self.animationView.removeFromSuperview()
        }
    }
}
