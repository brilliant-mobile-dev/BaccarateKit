//
//  RankingVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 09/09/23.
//

import UIKit

class RankingVC: UIViewController {
    @IBOutlet weak var rankTable: UITableView!
    @IBOutlet weak var bettingListButton: SegmentButton!
    @IBOutlet weak var winnerListButton: SegmentButton!
    @IBOutlet weak var richListButton: SegmentButton!
    @IBOutlet weak var rankingTitleLbl: UILabel!
    @IBOutlet weak var nickNameTitleLbl: UILabel!
    @IBOutlet weak var totalAssetsTitleLbl: UILabel!
    var eventHandler: RankingUIInterface?
    var selectedIndex = 0
    var richTopListArr = [RichListData]()
    var winTopListArr = [RichListData]()
    var betTopListArr = [RichListData]()
    let emptyView = EmptyStateView()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        self.languageSetup()
        // Do any additional setup after loading the view.
        customNavBar()
        updateButtonUI()
        
        rankTable.delegate = self
        rankTable.dataSource = self
        if self.eventHandler == nil {
            self.eventHandler = RankingPresenter(ui: self, wireframe: ProjectWireframe())
        }
        self.eventHandler?.getRichTop10List()
        initializeEmptyView()
    }
    func initializeEmptyView() {
        view.addSubview(emptyView)
        emptyView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonAction), for: .touchUpInside)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    @objc func tryAgainButtonAction() {
        self.callAPiAgain()
    }
    func languageSetup() {
        self.title = "Ranking".localizable
        Utils.setButtonAttributedTitle(btn: self.richListButton, text: "Richest list".localizable)
        Utils.setButtonAttributedTitle(btn: winnerListButton, text: "Winner list".localizable)
        Utils.setButtonAttributedTitle(btn: bettingListButton, text: "Betting list".localizable)
        self.rankingTitleLbl.text = "Ranking".localizable
        self.nickNameTitleLbl.text = "Username".localizable
        self.totalAssetsTitleLbl.text = "Total assets".localizable
    }
    func updateButtonUI() {
        if selectedIndex == 0 {
            // Rich List
            richListButton.backgroundColor = .secondary
            winnerListButton.backgroundColor = .secondaryLight
            bettingListButton.backgroundColor = . secondaryLight
        } else if selectedIndex == 1 {
            // Winner List
            winnerListButton.backgroundColor = .secondary
            richListButton.backgroundColor = .secondaryLight
            bettingListButton.backgroundColor = . secondaryLight
        } else {
            // Betting List
            bettingListButton.backgroundColor = .secondary
            richListButton.backgroundColor = .secondaryLight
            winnerListButton.backgroundColor = . secondaryLight
        }
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func richListButtonAction(_ sender: Any) {
        selectedIndex = 0
        updateButtonUI()
        self.eventHandler?.getRichTop10List()
    }
    @IBAction func winnerListButtonAction(_ sender: Any) {
        selectedIndex = 1
        updateButtonUI()
        self.eventHandler?.getWinTop10List()
    }
    @IBAction func bettingListButtonAction(_ sender: Any) {
        selectedIndex = 2
        updateButtonUI()
        self.eventHandler?.getBetTop10List()
    }
    func callAPiAgain() {
        if selectedIndex == 0 {
            self.richListButtonAction(UIButton())
        } else if selectedIndex == 1 {
            self.winnerListButtonAction(UIButton())
        } else if selectedIndex == 2 {
            self.bettingListButtonAction(UIButton())
        }
    }
}

// MARK: UITableView Delegate & Datasource
extension RankingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return self.richTopListArr.count
        } else if selectedIndex == 1 {
            return self.winTopListArr.count
        } else if selectedIndex == 2 {
            return self.betTopListArr.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RankingTVCell {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .tableColor1
            } else {
                cell.backgroundColor = .tableColor2
            }
            if selectedIndex == 0 {
                cell.data = self.richTopListArr[indexPath.row]
            } else if selectedIndex == 1 {
                cell.data = self.winTopListArr[indexPath.row]
            } else if selectedIndex == 2 {
                cell.data = self.betTopListArr[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
extension RankingVC: RankingUI {
    func successRichTop10(_ data: RichListResponse) {
        
        self.richTopListArr = data.datas ?? [RichListData]()
        if richTopListArr.count == 0 {
            self.rankTable.isHidden = true
            emptyView.showView(type: .general, title: nil)
        } else {
            self.rankTable.isHidden = false
            emptyView.hideView()
        }
        self.rankTable.reloadData()
    }
    func successWinTop10(_ data: RichListResponse) {
        
        self.winTopListArr = data.datas ?? [RichListData]()
        if winTopListArr.count == 0 {
            self.rankTable.isHidden = true
            emptyView.showView(type: .general, title: nil)
        } else {
            self.rankTable.isHidden = false
            emptyView.hideView()
        }
        self.rankTable.reloadData()
    }
    func successBetTop10(_ data: RichListResponse) {
        
        self.betTopListArr = data.datas ?? [RichListData]()
        if betTopListArr.count == 0 {
            self.rankTable.isHidden = true
            emptyView.showView(type: .general, title: nil)
        } else {
            self.rankTable.isHidden = false
            emptyView.hideView()
        }
        self.rankTable.reloadData()
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
           self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            self.rankTable.isHidden = true
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            self.rankTable.isHidden = true
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: "Alert".localizable)
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
extension RankingVC: LoginDismissDelegate {
    func loginDismissed() {
        self.callAPiAgain()
    }
}
