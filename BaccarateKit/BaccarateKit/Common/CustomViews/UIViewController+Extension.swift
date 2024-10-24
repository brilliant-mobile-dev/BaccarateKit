//
//  UIViewController+Extension.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import Foundation
import UIKit

extension UIViewController {
    func customNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryDark]
        navigationController?.navigationBar.backgroundColor = .secondary
        navigationController?.navigationBar.barTintColor = .secondary
    }
}
