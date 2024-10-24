//
//  RecordDetailVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import UIKit

class RecordDetailVC: UIViewController {
    @IBOutlet weak var settlementTimeLbl: UILabel!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var betAmountLbl: UILabel!
    @IBOutlet weak var validBetAmountLbl: UILabel!
    @IBOutlet weak var winLoseAmountLbl: UILabel!
    var eventHandler: RecordUIInterface?
    var data: PageResultData?
    var recordDetailArr = [RecordDetailsData]()
    let emptyView = EmptyStateView()
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        if eventHandler == nil {
            self.eventHandler = RecordPresenter(ui: self, wireframe: ProjectWireframe())
        }
        if let recordData = data {
            self.eventHandler?.getRecordDetail(data: recordData)
        }
        // Do any additional setup after loading the view.
        customNavBar()
        detailTable.delegate = self
        detailTable.dataSource = self
        self.languageSetup()
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
        // Write logic what to try again
        if let recordData = data {
            self.eventHandler?.getRecordDetail(data: recordData)
        }
    }
    func languageSetup() {
        settlementTimeLbl.text = "Settlement time".localizable
        playerNameLbl.text = "How to play".localizable
        betAmountLbl.text = "Bet".localizable
        validBetAmountLbl.text = "Effective bet".localizable
        winLoseAmountLbl.text = "Win or lose".localizable
        self.title = "Details".localizable
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: DetailTableView Delegate & Datasource Methods

extension RecordDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordDetailArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordDetailTVCell {
            cell.data = self.recordDetailArr[indexPath.row]
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .tableColor1
            } else {
                cell.backgroundColor = .tableColor2
            }
            return cell
        }
        return UITableViewCell()
    }
}
extension RecordDetailVC: RecordUI {
    func recordDetailSucess (_ data: RecordDetailsResponse) {
        self.recordDetailArr = data.datas ?? [RecordDetailsData]()
        if recordDetailArr.count == 0 {
            emptyView.showView(type: .general, title: nil)
        } else {
            emptyView.hideView()
        }
        self.detailTable.reloadData()
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
           // self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: "Alert".localizable)
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
extension RecordDetailVC: LoginDismissDelegate {
    func loginDismissed() {
        if let recordData = data {
            self.eventHandler?.getRecordDetail(data: recordData)
        }
    }
}
