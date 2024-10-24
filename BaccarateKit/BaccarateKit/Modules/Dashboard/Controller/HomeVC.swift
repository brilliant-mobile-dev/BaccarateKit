//
//  HomeVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 4/9/23.
import UIKit
import MarqueeLabel
import SpreadsheetView
import SocketRocket
import SideMenu
import IQKeyboardManagerSwift
import Network

public class HomeVC: UIViewController {
    @IBOutlet weak var gameCollecView: UICollectionView!
    var selectedIndexGame: Int =  0
    var previousIndexGame: Int =  0
    @IBOutlet weak var placeCollecView: UICollectionView!
    var selectedIndexPlace: Int =  0
    var previousIndexPlace: Int =  0
    @IBOutlet weak var customerServiceBtn: UIBarButtonItem!
    var countdownSocket: Timer!
    var totalwaitingSocketTime = 0
    var walletLabel: UILabel?
    var dispatchGroup = DispatchGroup()
    var webSocket: SRWebSocket!
    @IBOutlet weak var onlineNumber: UILabel!
    @IBOutlet weak var noticeLabel: MarqueeLabel!
    @IBOutlet weak var roomTable: UITableView!
    @IBOutlet weak var bGViewForTable: UIImageView!
    @IBOutlet weak var backgroundView: ViewDesign!
    var eventHandler: DashboardUIInterface?
    var roomList = [CasinoTableData]()
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIView()
    var annoucementArr: [NoticeInfo]?
    var refreshControl = UIRefreshControl()
    var userInfo = ConfigurationDataManager.shared.userInfo
    let emptyView = EmptyStateView()
    var isInternetAvailable = true
    let monitor = NWPathMonitor()
    var isGameRoomCellClicked = false
    var gameListArr = [GameData]()
    var placeListArr = [PlaceData]()
    var selectedcategoryID =  101
    var selectedPlaceID =  1
    override public func viewDidLoad() {
        super.viewDidLoad()
        bGViewForTable.isHidden = true
        currentVC = self
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localizable
        roomTable.delegate = self
        roomTable.dataSource = self
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.roomTable.refreshControl = self.refreshControl
        if Datamanager.shared.isUserAuthenticated {
            // Get Room List when user authenticated
            self.eventHandler = DashboardPresenter(ui: self, wireframe: ProjectWireframe())
            self.getAPiCall()
        } else {
            // Show Login VC when user not authenticated
            showLoginVC()
        }
        initializeEmptyView()
        self.placeCollecView.tag = 2
        self.placeCollecView.delegate = self
        self.placeCollecView.dataSource = self
    }
    @objc func showOfflineDeviceUI(notification: Notification) {
       // if !(currentVC is LoginVC) && (Utils.lastVC() != nil) && (Utils.lastVC() is HomeVC) && Datamanager.shared.isUserAuthenticated {
        if !(currentVC is LoginVC) && Datamanager.shared.isUserAuthenticated {
                if NetworkMonitor.shared.isConnected {
                    if self.isInternetAvailable == false {
                        if self.webSocket != nil && self.webSocket.readyState == .CLOSED {
                            self.pingToWebSocket()
                        } else {
                            self.callSocketLobby()
                        }
                    }
                    self.isInternetAvailable = true
                } else {
                    self.isInternetAvailable = false
                }
            }
    }
    func pingToWebSocket() {
        if Datamanager.shared.isUserAuthenticated {
            if self.webSocket != nil && self.webSocket.readyState == .OPEN {
                do {
                    try self.webSocket.sendPing(nil)
                } catch { }
            } else if self.webSocket != nil && self.webSocket.readyState == .CLOSED {
                self.callSocketLobby()
            }
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        isGameRoomCellClicked = false
        super.viewWillAppear(animated)
        roomList.removeAll()
        self.roomTable.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        currentVC = self
        self.pingToWebSocket()
        self.handleEnterForeground()
    }
    func initializeEmptyView() {
        backgroundView.addSubview(emptyView)
        emptyView.tryAgainButton.addTarget(self, action: #selector(self.tryAgainButtonAction), for: .touchUpInside)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor)
        ])
        emptyView.titleLbl.textColor = .white
    }
    @objc func tryAgainButtonAction(sender: UIButton) {
        self.getAPiCall()
    }
    @objc func refreshData() {
        self.getAPiCall()
        self.refreshControl.endRefreshing()
    }
    func callSocketLobby() {
        if Datamanager.shared.isUserAuthenticated {
            self.closeWebSocketConnection()
            let urlForLobby  = Constants.SOCKETURLLOBBY.endpoint.appendingPathComponent(Datamanager.shared.accessToken)
            print("urlForLobby in HomeVC ==>", urlForLobby)
            webSocket = SRWebSocket(url: urlForLobby)
            webSocket.delegate = self
            webSocket.open()
        }
    }
    func getAPiCall() {
        dispatchGroup = DispatchGroup()
        // Get Game CategoryL ist
        dispatchGroup.enter()
        eventHandler?.getGameCategoryList()
        // GetUserInfo
        dispatchGroup.enter()
        eventHandler?.getUserInfo()
        // GetGetNotificationList
        dispatchGroup.enter()
        eventHandler?.getNoticeList()
        // GetGetNotificationList
        dispatchGroup.enter()
        eventHandler?.getOnlineNumber()
        if ConfigurationDataManager.shared.cachelanguageSource == "local" {
            let eventHandlerLogin = LoginPresenter(ui: self, wireframe: ProjectWireframe())
            dispatchGroup.enter()
            eventHandlerLogin.getSourceLanguageData()
        }
    }
    func showLoginVC() {
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            destVC.modalPresentationStyle = .overFullScreen
            destVC.delegate = self
            present(destVC, animated: true)
        }
    }
    func createCustomBarButton(userInfo: UserInfo) {
        // Create Custom User Profile Bar Button
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = userProfileView(userInfo: userInfo, color: .primary).view
        self.walletLabel = userProfileView(userInfo: userInfo, color: .primary).walletLabel
        // Tap Gesture to open Record VC On Profile Tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentRecordVC))
        leftBarButton.customView?.addGestureRecognizer(tapGesture)
        navigationItem.leftBarButtonItems = [leftBarButton]
    }
    func gotoGameRoomVC(data: CasinoTableData) {
        if isGameRoomCellClicked == false {
            isGameRoomCellClicked = true
            monitor.cancel()
            self.endSocketTimer()
            if webSocket != nil && webSocket.readyState == .OPEN {
            }
            let destVC = ServiceLocator.sharedInstance.provideGameRooViewController()
            destVC.casinoData = data
            destVC.roomList = self.roomList
            destVC.previousVCDelegate = self
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    @objc func presentRecordVC() {
        let navVC = storyboard?.instantiateViewController(withIdentifier: "recordsNav") as? UINavigationController
        navVC?.isModalInPresentation = true
        present(navVC!, animated: true)
    }
    @IBAction func sideMenuButtonAction(_ sender: Any) {
        blurEffectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
       // blurEffectView.backgroundColor = .clear
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let menu = storyboard?.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuNavigationController
        menu!.presentationStyle = .menuSlideIn
        menu!.menuWidth = (view.bounds.width / 2) + 30
        menu!.sideMenuDelegate = self
        let destVC = menu!.viewControllers.first as? SideMenuVC
        destVC?.delegate = self
        present(menu!, animated: true)
    }
    func handleEnterForeground() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is HomeVC) && Datamanager.shared.isUserAuthenticated {
                AudioManager.soundQueue.removeAll()
                self.closeWebSocketConnection()
            }
        }
    }
    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is HomeVC) && Datamanager.shared.isUserAuthenticated {
                AudioManager.soundQueue.removeAll()
                self.getAPiCall()
            }
        }
    }
    func closeWebSocketConnection() {
        if webSocket != nil && webSocket.readyState == .OPEN {
            webSocket.close()
            webSocket.delegate = nil
            webSocket = nil
        }
    }
    public override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: Sidemenu Delegate
extension HomeVC: SideMenuNavigationControllerDelegate, SideMenuDelegate {
    public func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        blurEffectView.removeFromSuperview()
    }
    func menuSelectedAt(index: Int) {
        switch index {
        case 0:
            // Shuffle
            showSufflePopUp()
        case 1:
            // Records
            presentRecordVC()
        case 2:
            // Ranking
            openRankingVC()
        case 3:
            // Rules
            openRulesVC()
            openRulesVC()
            //    break
        case 4:
            // Sound
            showSoundPopUp()
        case 5:
            // Select Language
            showLanguagePopUp()
        case 6:
            // Security
            showSecurityPopUp()
        case 7:
            // Sign Out
            showAppQRVCPopUp()
        case 8:
            // Sign Out
            showLogoutPopUp()
        default:
            break
        }
    }
    func openRankingVC() {
        let navVC = UINavigationController()
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "RankingVC") as? RankingVC {
            navVC.viewControllers = [destVC]
            present(navVC, animated: true)
        }
    }
    func openRulesVC() {
        let navVC = UINavigationController()
        let destVC = ServiceLocator.sharedInstance.provideRollingRulesVC()
        navVC.viewControllers = [destVC]
        present(navVC, animated: true)
    }
    func showSufflePopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "ShuffleVC") as? ShuffleVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.validDelegate = self
            popupVC.delegateLogout = self
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    func showSoundPopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "SoundVC") as? SoundVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    @IBAction func showCustomerService(_ sender: Any) {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "CustomerServiceVC") as? CustomerServiceVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    func showLanguagePopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as? LanguageVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            popupVC.delegateLanguage = self
            present(popupVC, animated: true)
        }
    }
    func showSecurityPopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "SecurityVC") as? SecurityVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.delegate = self
            popupVC.delegateLogout = self
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    func showAppQRVCPopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "AppQRVC") as? AppQRVC {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
           // popupVC.delegate = self
           // popupVC.delegateLogout = self
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    func showLogoutPopUp() {
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as? LogoutVC {
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            let presentationVC = popupVC.popoverPresentationController
            presentationVC?.permittedArrowDirections = .any
            present(popupVC, animated: true)
        }
    }
    @IBAction func showAnnouncementPopUp() {
        if let arr = self.annoucementArr {
            let navVC = UINavigationController()
            if let destVC = storyboard?.instantiateViewController(withIdentifier: "AnnouncementVC") as? AnnouncementVC {
                destVC.annoucementArr = arr
                navVC.viewControllers = [destVC]
                present(navVC, animated: true)
            }
        }
    }
}
// MARK: Room Table Delegate & Datasource Methods
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return casinoCellHeight
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return roomList.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RoomTVCell {
            cell.tag = indexPath.section
            cell.casinoTabledata = roomList[indexPath.section]
            let mapData = cell.updateView(data: roomList[indexPath.section])
            roomList[indexPath.section].mapData = mapData
            return cell
        }
        return UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Goto Game Room ViewController
        let data = roomList[indexPath.section]
        if data.status != nil && data.status == 0 {
            self.showAlert(withTitle: "Alert".localizable, message: "Under maintenance".localizable)
            return
        }
        if NetworkMonitor.shared.isConnected {
            gotoGameRoomVC(data: data)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: "The Internet connection appears to be offline.")
        }
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}
// MARK: // MARK: CollectionView Delegate for GameList
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            self.selectedIndexGame = indexPath.row
            let indexToScrollTo = IndexPath(item: indexPath.row, section: indexPath.section)
            if previousIndexGame < self.selectedIndexGame {
                self.gameCollecView.scrollToItem(at: indexToScrollTo, at: .left, animated: true)
            } else if previousIndexGame > self.selectedIndexGame {
                self.gameCollecView.scrollToItem(at: indexToScrollTo, at: .right, animated: true)
            }
            self.gameCollecView.reloadData()
            previousIndexGame = indexPath.row
            // ..
                self.selectedcategoryID = self.gameListArr[ self.selectedIndexGame].gameID ?? 101
            print("self.selectedcategoryID ==>", self.selectedcategoryID)
            gameIdG = "\(self.selectedcategoryID)"
            dispatchGroup.enter()
            eventHandler?.getPlaceList(gameID: self.selectedcategoryID)
            // ...
        } else {
            print("self.selectedPlaceID collection  ==>", self.selectedPlaceID)
            self.selectedIndexPlace = indexPath.row
            let indexToScrollTo = IndexPath(item: indexPath.row, section: indexPath.section)
            if previousIndexPlace < self.selectedIndexPlace {
                self.placeCollecView.scrollToItem(at: indexToScrollTo, at: .left, animated: true)
            } else if previousIndexPlace > self.selectedIndexPlace {
                self.placeCollecView.scrollToItem(at: indexToScrollTo, at: .right, animated: true)
            }
            self.placeCollecView.reloadData()
            previousIndexPlace = indexPath.row
            //.....
            // GetRoomList
            self.selectedPlaceID = self.placeListArr[self.selectedIndexPlace].placeID ?? 1
            placeIdG = "\(self.selectedPlaceID)"
            dispatchGroup.enter()
            eventHandler?.getGameRoomList(gameId: self.selectedcategoryID, placeId: self.selectedPlaceID)
          //  self.dispatchGroup.leave()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (Utils.screenWidth - 30)/3
        let label = UILabel(frame: CGRect.zero)
        label.text = collectionView.tag == 1 ? gameListArr[indexPath.item].name ?? "" : self.placeListArr[indexPath.row].name ?? ""
        label.sizeToFit()
         if collectionView.tag == 1 {
        
           // return CGSize(width: (label.frame.width) + 30, height: 50)
            return CGSize(width: cellWidth, height: 50)
        } else {
            return CGSize(width: (label.frame.width) + 20, height: 40)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return self.gameListArr.count
        } else {
            return self.placeListArr.count
        }
        
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let identifier = "GameCollecCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GameCollecCell
            let obj = self.gameListArr[indexPath.row]
            if let title = obj.name {
                cell.ttlLabel.text = title
            }
            if self.selectedIndexGame == indexPath.row {
                cell.ttlLabel.textColor = .white
                // UIColor(red: 109.0/255.0, green: 98.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                //  cell.ttlBtn.isSelected = true
                cell.lineView.isHidden = false
            } else {
                cell.ttlLabel.textColor = UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1.0)
                // cell.ttlBtn.isSelected = false
                cell.lineView.isHidden = true
            }
            return cell
        } else {
            let identifier = "PlaceCollecCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PlaceCollecCell
            let obj = self.placeListArr[indexPath.row]
            if let title = obj.name {
                cell.ttlLabel.text = title
            }
            cell.boxView.layer.cornerRadius = 10
            cell.boxView.layer.borderColor =  UIColor.init(hex: "E2B361").cgColor
            cell.boxView.layer.borderWidth = 1
            if self.selectedIndexPlace == indexPath.row {
                cell.ttlLabel.textColor = UIColor.init(hex: "FFFFFF")
                cell.boxView.backgroundColor = UIColor.init(hex: "E2B361")
            } else {
                cell.ttlLabel.textColor = UIColor.init(hex: "AAAAAA")
                cell.boxView.backgroundColor = .clear
            }
            return cell
        }
    }
}
// MARK: Login Dismiss Delegate
extension HomeVC: LoginDismissDelegate, DashboardUI, LogoutDelegate, LoginUI {
    func languageSourceDataSucess (_ data: LanguageSourceResponse) {
        self.dispatchGroup.leave()
    }
    func reLoggedIn() {
        currentVC = self
        // self.eventHandler?.getGameRoomList()
        if Datamanager.shared.isUserAuthenticated {
            self.getAPiCall()
        }
    }
    func loginDismissed() {
        currentVC = self
        if Datamanager.shared.isUserAuthenticated {
            self.eventHandler = DashboardPresenter(ui: self, wireframe: ProjectWireframe())
            self.getAPiCall()
        } else {
            showLoginVC()
        }
    }
    func sucess(_ dashboardData: DashboardData) {
        roomList = dashboardData.datas ??  []
        if roomList.count == 0 {
            roomTable.isHidden = true
            emptyView.showView(type: .general, title: nil)
        } else {
            roomTable.isHidden = false
            CasinoTimer.shared.endTimer()
            CasinoTimer.shared.initialize(casinoArr: self.roomList)
            emptyView.hideView()
        }
        self.dispatchGroup.leave()
        DispatchQueue.main.async {
            self.roomTable.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.webSocket == nil || self.webSocket.readyState == .CLOSED {
                self.callSocketLobby()
            } else {
                self.pingToWebSocket()
            }
        }
        self.startSocketTimer()
        bGViewForTable.isHidden = false
    }
    func userSuccess(_ userData: UserData) {
        if let datas = userData.datas {
            userInfo = datas
            if self.userInfo?.customerSwitch == true {
                self.customerServiceBtn.isEnabled = true
                self.customerServiceBtn.tintColor = .white
            } else {
                self.customerServiceBtn.isEnabled = false
                self.customerServiceBtn.tintColor = .clear
            }
            createCustomBarButton(userInfo: datas)
        }
        self.dispatchGroup.leave()
    }
    func getOnlineSuccess(_ onlineData: OnlineData) {
        if let data = onlineData.datas {
            onlineNumber.text = "\(data)"
        }
        self.dispatchGroup.leave()
    }
    func noticeSuccess(_ noticeData: NoticeData) {
        self.roomTable.isHidden = false
        if let datas = noticeData.datas {
            self.annoucementArr = datas
            let contentString = datas.map { $0.content ?? ""}.joined(separator: " | ")
            noticeLabel.text = contentString
        }
        self.dispatchGroup.leave()
    }
    func gameCategoryListSuccess(_ gameListData: GameResponse) {
        if let data =  gameListData.datas {
            self.gameListArr = data
            for item in self.gameListArr {
                
                print("item.gameID ==>", item.gameID ?? "")
            }
            if self.gameListArr.count > 0 && self.selectedIndexGame == 0 {
                self.selectedcategoryID = self.gameListArr[0].gameID ?? 101
                gameIdG = "\(self.selectedcategoryID)"
            }
            print("self.selectedcategoryID ==>", self.selectedcategoryID)
            // Get Place List
         //   dispatchGroup.enter()
            self.gameCollecView.reloadData()
            eventHandler?.getPlaceList(gameID: self.selectedcategoryID)
            // self.dispatchGroup.leave()
        }
    }
    func placeListSuccess(_ placeData: PlaceResponse) {
        if let data =  placeData.datas {
            self.placeListArr = data
            for item in self.placeListArr {
                print("item.placeID ==>", item.placeID ?? "")
            }
            if self.placeListArr.count > 0 {
                self.selectedPlaceID = self.placeListArr[0].placeID ?? 1
                placeIdG = "\(self.selectedPlaceID)"
                self.selectedIndexPlace = 0
            }
        }
        print(" self.placeCollecView.reloadData()")
        self.placeCollecView.reloadData()
        // GetRoomList
        dispatchGroup.enter()
        eventHandler?.getGameRoomList(gameId: self.selectedcategoryID, placeId: self.selectedPlaceID)
        self.dispatchGroup.leave()
    }
    func foundError(_ error: BackendError) {
       
       // self.dispatchGroup.leave()
        if error.errorCode == 411178 {
            self.roomTable.isHidden = true
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            self.roomTable.isHidden = true
            emptyView.showView(type: .timeOut, title: nil)
        } else if error.errorCode == 401 {
            self.closeWebSocketConnection()
          //  self.dispatchGroup.leave()
            self.dispatchGroup.suspend()
        } else {
            self.roomTable.isHidden = true
            emptyView.showView(type: .general, title: nil)
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
extension HomeVC: RefreshPreviousVCDelegate {
    func handlePreviousVCData() {
        if let userInfo = ConfigurationDataManager.shared.userInfo {
            self.userInfo = userInfo
            createCustomBarButton(userInfo: userInfo)
        }
        dispatchGroup.enter()
        eventHandler?.getGameRoomList(gameId: self.selectedcategoryID, placeId: self.selectedPlaceID)
    }
}
