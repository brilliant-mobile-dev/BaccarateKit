//
//  CoinCVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 12/09/23.
//

import UIKit

class CoinCVCell: UICollectionViewCell {
    @IBOutlet weak var bgView: ViewDesign!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinDisbaleView: UIView!
    @IBOutlet weak var selectCoinBgImage: UIImageView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinHeight: NSLayoutConstraint!
    @IBOutlet weak var coinWidth: NSLayoutConstraint!
    @IBOutlet weak var coinCenter: NSLayoutConstraint!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateView(isSelected: Bool, coin: CasinoChip) {
        if isSelected {
            coinHeight.constant = 50
            coinWidth.constant = 50
            coinCenter.constant = -8
            self.selectCoinBgImage.isHidden = false
            coinDisbaleView.layer.cornerRadius = 25
            coinDisbaleView.clipsToBounds = true
        } else {
            coinHeight.constant = 46
            coinWidth.constant = 46
            coinCenter.constant = 0
            coinDisbaleView.layer.cornerRadius = 23
            coinDisbaleView.clipsToBounds = true
            self.selectCoinBgImage.isHidden = true
        }
        if let coin = coin.image {
            coinImage.image = coin
        }
    }
}
