//
//  LanguageCVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit
import SDWebImage
class LanguageCVCell: UICollectionViewCell {
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var containerVU: ViewDesign!
    @IBOutlet weak var checkmarkView: ViewDesign!
    
    func updateView(isSelected: Bool, data: LanguageData) {
        if isSelected {
            containerVU.borderColor = .systemGreen
            containerVU.borderWidth = 1
            checkmarkView.isHidden = false
        } else {
            containerVU.borderWidth = 0
            checkmarkView.isHidden = true
        }
        if let url = URL(string: data.icon ?? "") {
            iconIV.sd_setImage(with: url, placeholderImage: UIImage(systemName: "flag.slash.fill"))
        } else {
            iconIV.image = UIImage(systemName: "flag.slash.fill")
        }
        language.text = data.name ?? ""
    }
}
