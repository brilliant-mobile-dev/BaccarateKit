//
//  RecordsVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import UIKit
import DropDown
import SDWebImage
// swiftlint:disable type_body_length
class RecordsVC: UIViewController {
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var unTurnViewView: ViewDesign!
    // Footer Label Outlet
    @IBOutlet weak var footer6: UILabel!
    @IBOutlet weak var footer5: UILabel!
    @IBOutlet weak var footer4: UILabel!
    @IBOutlet weak var footer3: UILabel!
    @IBOutlet weak var footer2: UILabel!
    @IBOutlet weak var footer1: UILabel!
    // Title Header Label Outlet
    @IBOutlet weak var title6: UILabel!
    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var recordTable: UITableView!
    @IBOutlet weak var endDateTF: TextfieldDesign!
    @IBOutlet weak var startDateTF: TextfieldDesign!
    @IBOutlet weak var todayButton: SegmentButton!
    @IBOutlet weak var turnoverBtn: UIButton!
    @IBOutlet weak var accountChangeBtn: UIButton!
    @IBOutlet weak var bettingRecordBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var unTurnOverLabel: UILabel!
    var selectedIndex = 0
    let datepicker = UIDatePicker()
    var activeTFTag: Int = 0
    let dropDown = DropDown()
    var eventHandler: RecordUIInterface?
    var currentPage = 1
    var startDate = ""
    var endDate = ""
    var startDateD = Date()
    var endDateD = Date()
    var pageResultArr = [PageResultData]()
    var moneyChangeArr = [MoneyChangeData]()
    var washCodeArr = [WashCodeData]()
    var userInfo = ConfigurationDataManager.shared.userInfo
    var todayBtnTitle = ""
    let emptyView = EmptyStateView()
    var totalPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userInfo?.isTourists == true {
            unTurnViewView.isHidden = true
            self.turnoverBtn.isHidden = true
        }
        self.languageSetup()
        startDate = Utils.getDateStringWithFormate(date: Date()) + prefixStartTime
        endDate = Utils.getDateStringWithFormate(date: Date()) + prefixEndTime
        currentVC = self
        // Do any additional setup after loading the view.
        customNavBar()
        changeRecordButtonUI()
        updateView()
        setupDropDown()
        if eventHandler == nil {
            self.eventHandler = RecordPresenter(ui: self, wireframe: ProjectWireframe())
        }
        if self.selectedIndex == 2 {
            self.turnoverButtonAction()
        } else {
            self.getRecordList(startDate: startDate, endDate: endDate)
        }
        self.setUserData()
        initializeEmptyView()
    }
    func initializeEmptyView() {
        view.addSubview(emptyView)
        emptyView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonAction), for: .touchUpInside)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        emptyView.tryAgainButton.isHidden = true
       // emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180).isActive = true
    }
    @objc func tryAgainButtonAction() {
        self.getDataList()
    }
    func languageSetup() {
        self.title = "Personal center".localizable
        Utils.setButtonAttributedTitle(btn: self.bettingRecordBtn, text: "Betting record".localizable)
        Utils.setButtonAttributedTitle(btn: accountChangeBtn, text: "Account Change Record".localizable)
        Utils.setButtonAttributedTitle(btn: turnoverBtn, text: "Valid bet record".localizable)
        self.title1.text = "Settlement time".localizable
        self.title2.text = "Round No.".localizable
        self.title3.text = "Game".localizable
        self.title4.text = "Bet".localizable
        self.title5.text = "Win or lose".localizable
        self.title6.text = "Details".localizable
        todayBtnTitle = "Today".localizable
    }
    func setUserData() {
        self.walletLabel.text = "Balance".localizable + ": " + (userInfo?.symbol ?? "") + "\((userInfo?.userMoney ?? 0.00).walletAmount)"
       // self.walletLabel.text = "Balance: $10,302.754343443435534545345345555535354353453534534534534543534535353534535"
        self.nameLabel.text = userInfo?.username ?? ""
        self.unTurnOverLabel.text = "Unfinished rolling".localizable + ": " + (userInfo?.symbol ?? "") + "\((userInfo?.remainBet ?? 0.00).walletAmount)"
        userProfileImgView.sd_setImage(with: URL(string: userInfo?.headImgURL ?? ""),
                                       placeholderImage: UIImage(named: "avatar-new"),
                                       options: .continueInBackground, completed: nil)
    }
    func getRecordList(startDate: String, endDate: String) {
        self.eventHandler?.getRecordList(pageSize: 15, currentPage: currentPage, startDate: startDate, endDate: endDate)
    }
    func updateView() {
        self.startDateTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(donePicker))
        self.endDateTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(donePicker))
        let fontSize = (Display.typeIsLike == .iphone5) ? 12.0: 14.0
        self.startDateTF.font = .appFont(family: .medium, size: fontSize)
        self.endDateTF.font = .appFont(family: .medium, size: fontSize)
        todayButton.backgroundColor = .secondary
        
        startDateTF.text = DateUtility.shared.getCurrentDate()
        endDateTF.text = DateUtility.shared.getCurrentDate()
        
        datepicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        
        if #available(iOS 13.4, *) {
            datepicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        startDateTF.inputView = datepicker
        endDateTF.inputView = datepicker
        startDateTF.delegate = self
        endDateTF.delegate = self
        datepicker.minimumDate = Date()
        // Setup Record TableView
        recordTable.delegate = self
        recordTable.dataSource = self
    }
    func setupDropDown() {
        dropDown.anchorView = todayButton
       // dropDown.dataSource = ["Today".localizable, "This week".localizable, "Last week".localizable]
        dropDown.dataSource = ["Today".localizable, "Last 7 days".localizable, "Last 30 days".localizable]
        dropDown.cellConfiguration = { (_, item) in return "\(item)" }
    }
    @objc func updateDate() {
        if activeTFTag == 1 {
            let startDateStr = Utils.getDateStringWithFormate(date: datepicker.date)
            startDateTF.text = startDateStr
            startDate = startDateStr + prefixStartTime
            self.startDateD = datepicker.date
        } else if activeTFTag == 2 {
            let endDateStr = Utils.getDateStringWithFormate(date: datepicker.date)
            endDateTF.text = endDateStr
            endDate = endDateStr + prefixEndTime
            self.endDateD = datepicker.date
        }
    }
    @objc func donePicker(_ sender: UITextField) {
        todayBtnTitle = "Custom".localizable
        self.getDataList()
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func todayButtonAction(_ sender: Any) {
        dropDown.selectionAction = { (index: Int, item: String) in
            self.todayButton.setAttributedTitle(NSAttributedString(string: item,
                                                                   attributes: [NSAttributedString.Key.font: UIFont.appFont(family: .medium, size: 12)]), for: .normal)
            self.setStartEndDate(index: index)
        }
        dropDown.width = 140
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
    }
    func setStartEndDate(index: Int) {
        switch index {
        case 0:
            todayBtnTitle = "Today".localizable
            let startDateStr = Utils.getDateStringWithFormate(date: Date())
            self.startDate = startDateStr + prefixStartTime
            self.endDate = startDateStr + prefixEndTime
            self.startDateTF.text = startDateStr
            self.endDateTF.text = startDateStr
            self.startDateD = Date()
            self.endDateD = Date()
        case 1:
            todayBtnTitle = "Last 7 days".localizable
            if let sDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) {
                self.startDateD = sDate
                let startDateStr = Utils.getDateStringWithFormate(date: sDate)
                self.startDateTF.text = startDateStr
                self.startDate = startDateStr + prefixStartTime
            }
            self.endDateD = Date()
            let endDateStr = Utils.getDateStringWithFormate(date: Date())
            self.endDateTF.text = endDateStr
            self.endDate = endDateStr + prefixEndTime
        case 2:
            todayBtnTitle = "Last 30 days".localizable
            if let sDate = Calendar.current.date(byAdding: .day, value: -29, to: Date()) {
                self.startDateD = sDate
                self.startDateTF.text = Utils.getDateStringWithFormate(date: sDate)
                self.startDate = (Utils.getDateStringWithFormateUTC(date: sDate)) + prefixStartTime
            }
                let eDate = Date()
                self.endDateD = eDate
                let endDateStr = Utils.getDateStringWithFormate(date: eDate)
                self.endDateTF.text = endDateStr
                self.endDate = endDateStr + prefixEndTime
        default:
            self.startDateD = Date()
            let startDateStr = Utils.getDateStringWithFormate(date: Date())
            self.startDate = startDateStr + prefixStartTime
            self.endDate = startDateStr + prefixEndTime
        }
       // self.getRecordList(startDate: startDate, endDate: endDate)
        self.getDataList()
    }
    // MARK: Record Button Action
    @IBAction func bettingRecordButtonAction() {
        self.pageResultArr.removeAll()
        selectedIndex = 0
        currentPage = 1
        changeRecordButtonUI()
        self.getRecordList(startDate: startDate, endDate: endDate)
    }
    @IBAction func accountChangeButtonAction() {
        self.moneyChangeArr.removeAll()
        selectedIndex = 1
        currentPage = 1
        changeRecordButtonUI()
        self.eventHandler?.getChangeMoneyList(pageSize: 15, currentPage: self.currentPage, startDate: self.startDate, endDate: self.endDate)
    }
    @IBAction func turnoverButtonAction() {
        self.washCodeArr.removeAll()
        selectedIndex = 2
        currentPage = 1
        changeRecordButtonUI()
        self.footer2.text = ""
        self.eventHandler?.getWashCodeList(pageSize: 15, currentPage: self.currentPage, startDate: self.startDate, endDate: self.endDate)
    }
    func changeRecordButtonUI() {
        dropDown.selectRow(0)
        todayButton.setAttributedTitle(NSAttributedString(string: todayBtnTitle,
                                                          attributes: [NSAttributedString.Key.font: UIFont.appFont(family: .medium, size: 12)]),
                                       for: .normal)
        if selectedIndex == 0 {
            // Active Button
            bettingRecordBtn.backgroundColor = .secondary
            // InActive Button
            accountChangeBtn.backgroundColor = .secondaryLight
            turnoverBtn.backgroundColor = .secondaryLight
        } else if selectedIndex == 1 {
            // Active Button
            accountChangeBtn.backgroundColor = .secondary
            // InActive Button
            bettingRecordBtn.backgroundColor = .secondaryLight
            turnoverBtn.backgroundColor = .secondaryLight
        } else {
            // Active Button
            turnoverBtn.backgroundColor = .secondary
            // InActive Button
            accountChangeBtn.backgroundColor = .secondaryLight
            bettingRecordBtn.backgroundColor = .secondaryLight
        }
        
        // Change Record Table UI
        changeRecordTableUI()
    }
    func changeRecordTableUI() {
        if selectedIndex == 0 {
            // Show Betting Record
            title1.isHidden = false
            title2.isHidden = false
            title3.isHidden = false
            title4.isHidden = false
            title5.isHidden = false
            title6.isHidden = false
            /*
             title1.text = "Settlement Time"
             title2.text = "Match No."
             title3.text = "Game"
             title4.text = "Bet"
             title5.text = "Win or Lose"
             title6.text = "Details"
             */
            self.title1.text = "Settlement time".localizable
            self.title2.text = "Round No.".localizable
            self.title3.text = "Game".localizable
            self.title4.text = "Bet".localizable
            self.title5.text = "Win or lose".localizable
            self.title6.text = "Details".localizable
            
            bottomView.isHidden = false
            footer1.isHidden = false
            footer2.isHidden = false
            footer3.isHidden = false
            footer4.isHidden = false
            footer5.isHidden = false
            footer6.isHidden = false
            footer1.text = "Total".localizable
            footer2.text = ""
            footer3.text = ""
            footer4.text = "" // Change according to API
            footer5.text = ""
            footer5.textColor = .winColor
            footer6.text = ""
            
        } else if selectedIndex == 1 {
            // Show Account Change Record
            title1.isHidden = false
            title2.isHidden = false
            title3.isHidden = false
            title4.isHidden = false
            title5.isHidden = false
            title6.isHidden = true
            title1.text = "Time".localizable
            title2.text = "Type".localizable
            title3.text = "Pre-transaction balance".localizable
            title4.text = "Remaining balance".localizable
            title5.text = "Quota".localizable
            bottomView.isHidden = true
        } else {
            // Turnover Record
            title1.isHidden = false
            title2.isHidden = false
            title3.isHidden = true
            title4.isHidden = true
            title5.isHidden = true
            title6.isHidden = true
            title1.text = "Collection time".localizable
            title2.text = "Claim amount".localizable
            bottomView.isHidden = false
            footer1.isHidden = false
            footer2.isHidden = true
            footer3.isHidden = true
            footer4.isHidden = false
            footer5.isHidden = true
            footer6.isHidden = true
            footer1.text = "Total".localizable
            footer4.text = ""
        }
        DispatchQueue.main.async {
            self.recordTable.reloadData()
        }
    }
    @IBAction func copyBtnClicked(btn: UIButton) {
        self.copyBtn.isSelected = true
        UIPasteboard.general.string = nameLabel!.text
    }
    func getDataList() {
        if self.selectedIndex == 0 {
            bettingRecordButtonAction()
        } else if self.selectedIndex == 1 {
            accountChangeButtonAction()
        } else if self.selectedIndex == 2 {
            turnoverButtonAction()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height {
            if currentPage < totalPage {
                self.currentPage += 1
                if self.selectedIndex == 0 {
                    self.getRecordList(startDate: startDate, endDate: endDate)
                } else if self.selectedIndex == 1 {
                    self.eventHandler?.getChangeMoneyList(pageSize: 15, currentPage: self.currentPage, startDate: self.startDate, endDate: self.endDate)
                } else if self.selectedIndex == 2 {
                    self.eventHandler?.getWashCodeList(pageSize: 15, currentPage: self.currentPage, startDate: self.startDate, endDate: self.endDate)
                }
            }
        }
    }
}
// MARK: TableView Delegate & Datasource
extension RecordsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 {
            return self.pageResultArr.count
        } else if self.selectedIndex == 1 {
            return self.moneyChangeArr.count
        } else if self.selectedIndex == 2 {
            return self.washCodeArr.count
        } else {
            return self.pageResultArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTVCell {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .tableColor1
            } else {
                cell.backgroundColor = .tableColor2
            }
            cell.updateView(selectedIndex: selectedIndex)
            if self.selectedIndex == 0 {
                cell.data = self.pageResultArr[indexPath.row]
            } else if self.selectedIndex == 1 {
                cell.moneyChangedata = self.moneyChangeArr[indexPath.row]
            } else if self.selectedIndex == 2 {
                cell.washCodedata = self.washCodeArr[indexPath.row]
            }
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}
