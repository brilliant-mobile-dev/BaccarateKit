//
//  BaseStoryboard.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//

import UIKit

public struct BaseStoryboard {

    fileprivate let name: String

    // init
    public init(name: String) {
        self.name = name
    }
    // This function will load storyborad by there name
    fileprivate func storyboard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    // This function will load initial view controller from storyborad by storyboard name
    fileprivate func initialViewController<T>() -> T {
        let uiStoryboard = storyboard(name)
        return (uiStoryboard.instantiateInitialViewController() as? T)!
    }

    // This function will load view controller by identifier name
    public func instantiateViewController<T>(_ viewControllerIdentifier: String) -> T {
        let uiStoryboard = storyboard(name)
        return (uiStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T)!
    }
    public func instantiateViewController<T>() -> T {
        return instantiateViewController(String(describing: T.self))
    }
}
