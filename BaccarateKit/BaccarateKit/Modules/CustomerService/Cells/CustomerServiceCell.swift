//
//  CustomerServiceCell.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 7/10/23.
//
// swiftlint:disable line_length
import UIKit
import SDWebImage
class CustomerServiceCell: UITableViewCell {
    let statusView = StatusView(isDisplayBg: false)
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelID: UILabel!
    var updateDelegate: UpdateActionDelegate?
    var data: CustomerServiceData? {
        didSet {
            self.updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeStatusView()
        // Initialization code
    }
    func updateUI() {
        self.copyBtn.isSelected = data?.isSelected ?? false
        if let url = URL(string: data?.urlApp ?? "") {
            channelIcon.sd_setImage(with: url, placeholderImage: UIImage(named: "customerServiceIcon"))
        } else {
            channelIcon.image = UIImage(named: "customerServiceIcon")
        }
        self.channelName.text = data?.customerChannel ?? ""
        self.channelID.text = "@\(data?.account ?? "")"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func copyBtnClicked(btn: UIButton) {
      //  self.copyBtn.isSelected = true
        self.data?.isSelected = true
        self.updateDelegate?.updateAction(index: btn.tag)
        UIPasteboard.general.string = data?.account ?? ""
        statusView.showStatus("Copy successfully".localizable, duration: 0.4) // Copied Successfully
    }
    func initializeStatusView() {
        self.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            statusView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 200),
            statusView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
protocol UpdateActionDelegate: AnyObject {
    func updateAction(index: Int)
}
