//
//  ProjectWireframe.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import UIKit

class ProjectWireframe: BaseWireframe {

    static let sharedInstance = ProjectWireframe()   // need to verify this code
    func dismissToRootViewController(_ window: UIWindow) {
        window.rootViewController?.dismiss(animated: false, completion: nil)
    }

    func dismissViewController(vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }

    func dismissViewController(vc: UIViewController, WithCompletion completion: (() -> Void)? = nil) {
        vc.dismiss(animated: true, completion: completion)
    }
}
