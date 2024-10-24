//
//  AnnouncementVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 18/9/23.
//

import UIKit

class AnnouncementVC: UIViewController {
    var annoucementArr = [NoticeInfo]()
    @IBOutlet weak var annoucementTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar()
        self.title = "Announcement".localizable
        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
// MARK: UITableView Delegate & Datasource
extension AnnouncementVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annoucementArr.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouceCell", for: indexPath) as? AnnouceCell
        cell?.data = self.annoucementArr[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
