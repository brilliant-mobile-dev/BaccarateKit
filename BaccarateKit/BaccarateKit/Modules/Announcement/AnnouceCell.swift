//
//  AnnouceCell.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 18/9/23.
//

import UIKit

class AnnouceCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    var data: NoticeInfo? {
        didSet {
            self.setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData() {
      //  self.titleLbl.text = self.data?.title ?? ""
        self.contentLbl.text = self.data?.content ?? ""
        self.dateLbl.text = self.data?.createTime ?? ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
