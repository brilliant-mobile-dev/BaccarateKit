//
//  SideMenuVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import UIKit

class SideMenuVC: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    let menuArray = ["Valid bet".localizable,
                     "View records".localizable,
                     "Ranking".localizable,
                     "Game rules".localizable,
                     "Sound".localizable,
                     "Select language".localizable,
                     "Security setting".localizable,
                     "Download APP".localizable,
                     "Sign out".localizable]
    var delegate: SideMenuDelegate?
    var userInfo = ConfigurationDataManager.shared.userInfo
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuTable.delegate = self
        menuTable.dataSource = self
        versionLabel.text = "Version".localizable + " " + Utils.checkAppVersion()
    }
}
// MARK: MenuTableView Delegate & Datasource Method
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SideMenuTVCell {
            cell.titleLabel.text = menuArray[indexPath.row]
            cell.menuIcon.image = UIImage(named: "menu\(indexPath.row + 1)")
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.userInfo?.isTourists == true) && (indexPath.row == 0 || indexPath.row == 6) {
            self.showAlert(withTitle: "Alert".localizable, message: "Demo account does not support this feature".localizable)
            return
        }
        dismiss(animated: true) {
            self.delegate?.menuSelectedAt(index: indexPath.row)
        }
    }
}

