//
//  PlayerListPopupVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 26/10/23.
//

import UIKit

class PlayerListPopupVC: UIViewController {
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var gamePlayerArr = [PlayerData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if gamePlayerArr.count > 0 {
            tableHeight.constant = CGFloat(gamePlayerArr.count) * 35
            preferredContentSize = CGSize(width: 210, height: tableHeight.constant + 51)
        } else {
            tableHeight.constant = 300
            preferredContentSize = CGSize(width: 210, height: tableHeight.constant + 51)
        }
        self.titleLbl.text = "Players".localizable
        // Do any additional setup after loading the view.
    }
}
extension PlayerListPopupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gamePlayerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GamePlayersCell", for: indexPath) as? GamePlayersCell {
            cell.data = self.gamePlayerArr[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
