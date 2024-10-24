//
//  RecordTVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 07/09/23.
//

import UIKit

class RecordTVCell: UITableViewCell {
    var data: PageResultData? {
       didSet {
           setData()
       }
   }
    var moneyChangedata: MoneyChangeData? {
       didSet {
           setMoneyChangeData()
       }
   }
    var washCodedata: WashCodeData? {
       didSet {
           setWashCodeData()
       }
   }
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var column5: UILabel!
    @IBOutlet weak var column4: UILabel!
    @IBOutlet weak var column3: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column1: UILabel!
    
    var delegate: RecordVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setWashCodeData() {
        column5.textColor = .winColor
        column1.text = washCodedata?.takeTime ?? ""
        column2.text = (washCodedata?.money ?? 0).afterDecimal2Digit
        if (washCodedata?.money ?? 0) < 0 {
            column5.textColor = .loseColor
        } else {
            column5.textColor = .winColor
        }
    }
    func setMoneyChangeData() {
        column5.textColor = .winColor
        column1.text = moneyChangedata?.createTime ?? ""
        column2.text = moneyChangedata?.orderTypeName ?? ""
        column3.text = (moneyChangedata?.beforeMoney ?? 0).afterDecimal2Digit
        column4.text = (moneyChangedata?.afterMoney ?? 0).afterDecimal2Digit
        column5.text = (moneyChangedata?.money ?? 0).afterDecimal2Digit
        if (moneyChangedata?.orderType ?? 0) == 3 || (moneyChangedata?.orderType ?? 0) == 7 {
            column5.textColor = .winColor
        } else {
            column5.textColor = .loseColor
        }
    }
    func setData() {
        column5.textColor = .winColor
        column1.text = data?.calcTime ?? ""
        column2.text = data?.roundNo ?? ""
        column3.text = data?.gameName ?? ""
        column4.text = (data?.betMoney ?? 0).afterDecimal2Digit
        column5.text = (data?.winLossMoney ?? 0).afterDecimal2Digit
        if (data?.winLossMoney ?? 0.00) < 0.0 {
            column5.textColor = .loseColor
        } else {
            column5.textColor = .winColor
        }
    }
    func updateView(selectedIndex: Int) {
        if selectedIndex == 0 {
            // Show Betting Record
            column1.isHidden = false
            column2.isHidden = false
            column3.isHidden = false
            column4.isHidden = false
            column5.isHidden = false
            detailButton.isHidden = false
        } else if selectedIndex == 1 {
            // Show Account Change Record
            column1.isHidden = false
            column2.isHidden = false
            column3.isHidden = false
            column4.isHidden = false
            column5.isHidden = false
            detailButton.isHidden = true
        } else {
            // Turnover Record
            column1.isHidden = false
            column2.isHidden = false
            column3.isHidden = true
            column4.isHidden = true
            column5.isHidden = true
            detailButton.isHidden = true
        }
    }
    @IBAction func detailButtonAction(_ sender: Any) {
        if let pageData = self.data {
            delegate?.showRecordDetail(data: pageData)
        }
    }
}

