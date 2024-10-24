//
//  RecordDetailTVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import UIKit

class RecordDetailTVCell: UITableViewCell {

    @IBOutlet weak var column5: UILabel!
    @IBOutlet weak var column4: UILabel!
    @IBOutlet weak var column3: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column1: UILabel!
    var data: RecordDetailsData? {
        didSet {
            setData()
        }
    }
    func setData() {
        column1.text = data?.calcTime ?? ""
        column2.text = data?.playName ?? ""
        column3.text = (data?.betMoney ?? 0.00).afterDecimal2Digit
        column4.text = (data?.betValidMoney ?? 0.00).afterDecimal2Digit
        column5.text = (data?.winLossMoney ?? 0.00).afterDecimal2Digit
        if (data?.winLossMoney ?? 0.00) < 0.0 {
            self.backgroundColor = .tableColor1
            column5.textColor = .loseColor
        } else {
            self.backgroundColor = .tableColor2
            column5.textColor = .winColor
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

