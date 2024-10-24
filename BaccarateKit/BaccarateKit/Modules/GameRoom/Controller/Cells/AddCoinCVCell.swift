//
//  AddCoinCVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 27/09/23.
//

import UIKit

class AddCoinCVCell: UICollectionViewCell {
    @IBOutlet weak var chipStatusVU: ViewDesign!
    @IBOutlet weak var chipImage: UIImageView!
    func updateView(coin: CasinoChip) {
        chipImage.image = coin.image
    }
}
