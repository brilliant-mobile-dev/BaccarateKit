//
//  GamePlayersCell.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 26/10/23.
//

import UIKit

class GamePlayersCell: UITableViewCell {
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var seatNo: UILabel!
    var data: PlayerData? {
        didSet {
            self.updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        seatNo.layer.masksToBounds = true
        // Initialization code
    }
    func updateUI() {
        self.playerName.text = data?.username ?? ""
        self.seatNo.text = data?.seatNo ?? ""
    }
}
