//
//  BaseWireframe.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//

import UIKit

class BaseWireframe: RootWireframe {
    static var window: UIWindow!
    // This function will present Activation view controller and this will be our root view controller till config loaded.
    func presentInitialViewControllerInWindow(_ window: UIWindow) {
        BaseWireframe.window = window
    }
    
    func presentLanguageVCInWindow(_ window: UIWindow) {
        BaseWireframe.window = window
    }
}
