//
//  StreamingVideoPlayer.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 13/09/23.
//

import AVFoundation
import AVKit
import ZFPlayer

public class StreamingVideoPlayer {
//    private let playerVC = AVPlayerViewController()
//
//    private let avPlayer = AVPlayer()
    
    var livePlayer = ZFPlayerController()
    var liveManager = ZFIJKPlayerManager()
    
    public init() {}
    
    // MARK: Public interface
    func add(to view: UIView, placeholder: UIView, activityIndicator: UIActivityIndicatorView) {
        livePlayer = ZFPlayerController(playerManager: liveManager, containerView: view)
        livePlayer.currentPlayerManager.scalingMode = .aspectFit
        livePlayer.pauseWhenAppResignActive = false
        livePlayer.currentPlayerManager.view.bounds = view.bounds
        livePlayer.allowOrentitaionRotation = false
        livePlayer.isPauseByEvent = false
     //   livePlayer.isPauseByEvent = false
       // livePlayer.allowOrentitaionRotation = false
      //  livePlayer.scrollView?.setZoomScale(0.5, animated: false)
        placeholder.isHidden = false
        activityIndicator.startAnimating()
        livePlayer.playerReadyToPlay = { manager, _ in
            switch manager.playState {
            case .playStatePlaying:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    placeholder.isHidden = true
                    activityIndicator.stopAnimating()
                }
            case .playStatePaused:
                placeholder.isHidden = false
                activityIndicator.startAnimating()
            case .playStatePlayStopped:
                placeholder.isHidden = false
                activityIndicator.startAnimating()
            case .playStatePlayFailed:
                placeholder.isHidden = false
                activityIndicator.startAnimating()
            case .playStateUnknown:
                placeholder.isHidden = false
                activityIndicator.startAnimating()
            default:
                break
            }
        }
        view.addSubview(livePlayer.currentPlayerManager.view)
    }
    func play(url: String) {
        if let assetURL = URL(string: url) {
            if livePlayer.currentPlayerManager != nil {
                livePlayer.currentPlayerManager.assetURL = assetURL
                livePlayer.currentPlayerManager.play()
            }
        }
    }
    func stop() {
        livePlayer.currentPlayerManager.stop()
    }
}
