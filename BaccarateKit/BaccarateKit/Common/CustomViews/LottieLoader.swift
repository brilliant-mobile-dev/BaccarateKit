//
//  LottieLoader.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 25/09/23.
//

import UIKit
import Lottie

class LottieLoader {
    static let shared = LottieLoader()
    
    private var blurView: UIVisualEffectView?
    private var loadingView: LottieAnimationView? // AnimationView?

    private init() { }

    func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.blurView?.frame = window.bounds
        window.addSubview(self.blurView!)
        
        self.loadingView = LottieAnimationView(name: "loader") // AnimationView(name: "your_loader_file_name")
        self.loadingView?.frame = UIScreen.main.bounds
        self.loadingView?.contentMode = .scaleAspectFit
        self.loadingView?.loopMode = .loop
        self.loadingView?.animationSpeed = 2

        if let loadingView = self.loadingView {
            window.addSubview(loadingView)
            loadingView.play()
        }
    }

    func hide() {
        self.loadingView?.stop()
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
        
        self.blurView?.removeFromSuperview()
        self.blurView = nil
    }
}
