//
//  AppColorManager.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 05/09/23.
//

import Foundation
import UIKit

// App Theme - Add all colors used in Application
extension UIColor {
    static var primary: UIColor {
        return UIColor(displayP3Red: 65/255, green: 80/255, blue: 100/255, alpha: 1)
    }
    static var secondary: UIColor {
        return UIColor(displayP3Red: 227/255, green: 206/255, blue: 170/255, alpha: 1)
    }
    static var secondaryDark: UIColor {
        return UIColor(displayP3Red: 144/255, green: 119/255, blue: 92/255, alpha: 1)
    }
    static var secondaryLight: UIColor {
        return UIColor(displayP3Red: 245/255, green: 243/255, blue: 243/255, alpha: 1)
    }
    static var tableColor1: UIColor {
        return UIColor(displayP3Red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    static var tableColor2: UIColor {
        return UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    }
    static var placeholder: UIColor {
        return UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
    }
    static var winColor: UIColor {
        return UIColor(displayP3Red: 90/255, green: 197/255, blue: 97/255, alpha: 1)
    }
    static var loseColor: UIColor {
        return UIColor(displayP3Red: 218/255, green: 69/255, blue: 61/255, alpha: 1)
    }
    static var tieColor: UIColor {
        return UIColor.init(hex: "6DD400")
    }
    static var statusColor: UIColor {
        return (UserPreference.shared.getIsDarkMode() == true) ? .white : .black
    }
    static var appYellow: UIColor {
        return UIColor(hex: "E4CFAA")
    }
    static var buttonTextColor: UIColor {
        return UIColor(hex: "715A35")
    }
    static var roadMapBgColor: UIColor {
        return (UserPreference.shared.getIsDarkMode() == true) ? UIColor(red: 24/255.0, green: 26/255.0, blue: 31/255.0, alpha: 1.0) : .white
    }
    static var gridLineColor: UIColor {
        return (UserPreference.shared.getIsDarkMode() == true) ?  UIColor(displayP3Red: 54/255, green: 56/255, blue: 62/255, alpha: 1) :
        UIColor.gray.withAlphaComponent(0.666667)
    }
}
