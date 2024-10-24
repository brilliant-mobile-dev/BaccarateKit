//
//  RankingTVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit
import SDWebImage
class RankingTVCell: UITableViewCell {
    @IBOutlet weak var column3: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column1: UILabel!
    @IBOutlet weak var imgViewRank: UIImageView!
    var userInfo = ConfigurationDataManager.shared.userInfo
    var data: RichListData? {
       didSet {
           setData()
       }
   }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData() {
        let serialNo = data?.sortNo ?? 0
        if serialNo == 1 {
            self.imgViewRank.image = UIImage(named: "today_ranking_no1")
            self.column1.text = ""
        } else if serialNo == 2 {
            self.imgViewRank.image = UIImage(named: "today_ranking_no2")
            self.column1.text = ""
        } else if serialNo == 3 {
            self.imgViewRank.image = UIImage(named: "today_ranking_no3")
            self.column1.text = ""
        } else {
            self.imgViewRank.image = UIImage(named: "clearColorImg")
            self.column1.text = "\(data?.sortNo ?? 0)"
        }
        self.column2.text = data?.username ?? ""
        self.column3.text = (self.userInfo?.symbol ?? "$") + "\((data?.money ?? 0.0).afterDecimal2Digit)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
