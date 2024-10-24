//
//  UIApplication.swift
//  Baccarate
//
//  Created by Brilliant Dev on 22/10/24.
//

import Foundation

extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}
