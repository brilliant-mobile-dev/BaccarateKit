//
//  FontManager.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/09/23.
//

import Foundation
import UIKit

extension UIFont {
    // Enum to define commonly used font families
    enum FontFamily: String {
        case ultraLight = "AvenirNext-UltraLight"
        case regular = "AvenirNext-Regular"
        case medium = "AvenirNext-Medium"
        case demibold = "AvenirNext-DemiBold"
        case bold = "AvenirNext-Bold"
        case heavy = "AvenirNext-Heavy"
    }
    // Convenience method to set a font with a specified family and size
    static func appFont(family: FontFamily, size: CGFloat) -> UIFont {
        if let font = UIFont(name: family.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
