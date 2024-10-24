//
//  SideMenuTVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import UIKit

class SideMenuTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let chevron = UIImage(named: "chevron")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
