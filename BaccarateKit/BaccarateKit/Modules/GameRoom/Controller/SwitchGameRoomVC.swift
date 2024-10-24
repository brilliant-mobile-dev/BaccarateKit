//
//  SwitchGameRoomVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 20/09/23.
//

// swiftlint:disable superfluous_disable_command cyclomatic_complexity type_body_length file_length type_name
import UIKit
import SocketRocket
protocol TableSwitchDelegate: AnyObject {
    func updateGameRoom(casinoData: CasinoTableData)
}
class SwitchGameRoomVC: UIViewController {
    var countdownSocket: Timer!
    var totalwaitingSocketTime = 0
    var switchDelegate: TableSwitchDelegate?
    var casinoCurrentData: CasinoTableData?
    var webSocket: SRWebSocket!
    var roomList = [CasinoTableData]()
    @IBOutlet weak var switchTable: UICollectionView!
    var eventHandler: DashboardUIInterface?
    let emptyView = EmptyStateView()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        self.eventHandler = DashboardPresenter(ui: self, wireframe: ProjectWireframe())
        eventHandler?.getGameCategoryList()
        initializeEmptyView()
     //   self.switchTable.backgroundView = UIImageView(image: UIImage(named: "sideMenuBG"))
        self.switchTable.backgroundColor = UIColor(hex: "612805")
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
        self.eventHandler?.getGameCategoryList()
    }
    func callSocketLobby() {
        self.closeWebSocketConnection()
        let urlForLobby  = Constants.SOCKETURLLOBBY.endpoint.appendingPathComponent(Datamanager.shared.accessToken)
        print("urlForLobby in SwitchVC ==>", urlForLobby)
        webSocket = SRWebSocket(url: urlForLobby)
        webSocket.delegate = self
        webSocket.open()
    }
    override func viewWillDisappear(_ animated: Bool) {
       // print("Switch viewWillDisappear called")

    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Switch viewDidDisappear called")
        self.closeWebSocketConnection()
        self.endSocketTimer()
    }
    func closeWebSocketConnection() {
        print("closeWebSocketConnection called")
        if webSocket != nil && webSocket.readyState == .OPEN {
            webSocket.close()
            webSocket.delegate = nil
            webSocket = nil
        }
    }
    
}
// MARK: Switch Table Delegate & Datasource Methods

extension SwitchGameRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.roomList.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                         for: indexPath) as? SwitchRoomCVCell {
            cell.tag = indexPath.row
            cell.casinoTabledata = roomList[indexPath.row]
            let mapData = cell.updateView(data: roomList[indexPath.row])
            roomList[indexPath.row].mapData = mapData
            var color = UIColor.loseColor
            if roomList[indexPath.row].tableNo == self.casinoCurrentData?.tableNo {
                color = UIColor(hex: "14F400")
            } else {
                color = UIColor(hex: "A3C2F2")
            }
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 2.0
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Utils.screenWidth/2
        let height = Utils.screenHeight/6
        switchCellHeight = height
        return CGSize(width: width - 30, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = roomList[indexPath.row]
        AudioManager.soundQueue.removeAll()
        if data.status != nil && data.status == 0 {
            self.showAlert(withTitle: "Alert".localizable, message: "Under maintenance".localizable)
            return
        }
        if self.casinoCurrentData?.tableNo == data.tableNo {
            self.dismiss(animated: true)
        } else {
            self.switchDelegate?.updateGameRoom(casinoData: data)
            self.dismiss(animated: true)
        }
    }
}
extension SwitchGameRoomVC: DashboardUI {
    func sucess(_ dashboardData: DashboardData) {
        switchTable.isHidden = false
        roomList = dashboardData.datas ??  [CasinoTableData]()
        callSocketLobby()
        if roomList.count == 0 {
            emptyView.showView(type: .general, title: nil)
        } else {
            emptyView.hideView()
            CasinoTimer.shared.endTimer()
            CasinoTimer.shared.initialize(casinoArr: self.roomList)
        }
        DispatchQueue.main.async {
            self.switchTable.reloadData()
        }
        self.startSocketTimer()
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
          // self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            switchTable.isHidden = true
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            switchTable.isHidden = true
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: "Alert".localizable)
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
extension SwitchGameRoomVC: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket, didReceivePingWith data: Data?) {
        print("didReceivePingWith")
        totalwaitingSocketTime = 0
    }
    func webSocket(_ webSocket: SRWebSocket, didReceivePong pongData: Data?) {
        print("didReceivePong")
    }
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        totalwaitingSocketTime = 0
    }
    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if NetworkMonitor.shared.isConnected {
            self.callSocketLobby()
        }
    }
    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
    }
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func webSocket(_ webSocket: SRWebSocket, didReceiveMessageWith string: String) {
        totalwaitingSocketTime = 0
        print("Message string ==>", string)
        do {
            let cryptoData = Data(string.utf8)
            let decoder = JSONDecoder()
            let data = try decoder.decode(LobbySocketData.self, from: cryptoData)
            let gameObj: GameResult = GameResult(rawValue: data.type ?? "") ?? .noData
            switch gameObj {
            case .tableInfo:
                if let currentTabelData = self.roomList.filter({$0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
                    if currentTabelData.gameTableStatusVo == nil {
                        currentTabelData.gameTableStatusVo = GameTableStatusVo()
                    }
                    currentTabelData.gameTableStatusVo?.betSecond = data.data?.betSecond ?? 20
                    currentTabelData.gameTableStatusVo?.calcSecond = data.data?.calcSecond ?? 20
                    
                    currentTabelData.gameTableStatusVo?.remainSecond = data.data?.remainSecond
                    currentTabelData.gameTableStatusVo?.roundNo = data.data?.roundNo
                    currentTabelData.gameTableStatusVo?.status = data.data?.status
                    if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                    //    let sectionIndex = IndexSet(integer: index)
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: index, section: 0)
                            self.switchTable.reloadItems(at: [indexPath])
                        }
                    }
                }
                /*
            case .tableInfo:
                
                if let currentTabelData = self.roomList.filter({$0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
                    if currentTabelData.gameTableStatusVo == nil {
                        currentTabelData.gameTableStatusVo = GameTableStatusVo()
                    }
                    currentTabelData.gameTableStatusVo?.betSecond = data.data?.betSecond ?? 20
                    currentTabelData.gameTableStatusVo?.calcSecond = data.data?.calcSecond ?? 20
                    
                    currentTabelData.gameTableStatusVo?.remainSecond = data.data?.remainSecond
                    currentTabelData.gameTableStatusVo?.roundNo = data.data?.roundNo
                    currentTabelData.gameTableStatusVo?.status = data.data?.status
                    if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        self.switchTable.reloadItems(at: [indexPath])
                    }
                }
                */
            case .roundResult:
                if let currentTabelData = self.roomList.filter({
                    $0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
                    var newEntry = false
                    let obj = GameTableResultVo()
                    obj.bootNo = data.data?.bootNo
                    obj.roundNo = data.data?.roundNo
                    obj.result = data.data?.result
                    if currentTabelData.gameTableResultVos == nil {
                        newEntry = true
                        currentTabelData.gameTableResultVos = [GameTableResultVo]()
                    }
                    currentTabelData.gameTableResultVos?.append(obj)
                    if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
                        print("before switchTable.reloadItems for \(data.data?.tableNo ?? "")")
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                        if !(self.roomList[index].mapData == nil && newEntry == false) {
                            let mapData = RoadMaps().generateSingleEntryRoadMap(item: obj, mapData: self.roomList[index].mapData)
                            self.roomList[index].mapData = mapData
                            let indexPath = IndexPath(item: index, section: 0)
                            DispatchQueue.main.async {
                                self.switchTable.reloadItems(at: [indexPath])
                                print("switchTable.reloadItems for \(data.data?.tableNo ?? "")")
                            }
                        }
                    }
                    /*
                    {
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                        if !(self.roomList[index].mapData == nil && newEntry == false) {
                            let mapData = RoadMaps().generateSingleEntryRoadMap(item: obj, mapData:self.roomList[index].mapData)
                            let indexPath = IndexPath(item: index, section: 0)
                            self.switchTable.reloadItems(at: [indexPath])
                        }
                    }
                    */
                }
            case .roundNum:
                if let currentTabelData = self.roomList.filter({
                    $0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
                    if currentTabelData.gameTableInfoStatisticsVo == nil {
            currentTabelData.gameTableInfoStatisticsVo = GameTableInfoStatisticsVo(roundNum: 0,
                                                                                   tieNum: 0,
                                                                                   playerPairNum: 0,
                                                                                   bankerNum: 0,
                                                                                   playerNum: 0,
                                                                                   bankerPairNum: 0)
                    }
                    currentTabelData.gameTableInfoStatisticsVo?.roundNum = data.data?.roundNum
                    currentTabelData.gameTableInfoStatisticsVo?.playerNum = data.data?.playerNum
                    currentTabelData.gameTableInfoStatisticsVo?.bankerNum = data.data?.bankerNum
                    currentTabelData.gameTableInfoStatisticsVo?.playerPairNum = data.data?.playerPairNum
                    currentTabelData.gameTableInfoStatisticsVo?.bankerPairNum = data.data?.bankerPairNum
                    currentTabelData.gameTableInfoStatisticsVo?.tieNum = data.data?.tieNum
                    if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        self.switchTable.reloadItems(at: [indexPath])
                    }
                }
            case .addCard:
                break
            case .card:
                break
            case .betPot:
                break
            case .betInfo:
                break
            case .payoff:
                break
            case .money:
                break
            case .noData:
                break
            case .userEntered:
                break
            case .userLeave:
                break
            case .reset:
                break
            case .updateResult:
                self.updateResultData(data: data)
            }
        } catch _ {
        }
    }
}
extension SwitchGameRoomVC: LoginDismissDelegate {
    func updateResultData(data: LobbySocketData) {
        if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
            if self.roomList[index].gameTableInfoStatisticsVo == nil {
                self.roomList[index].gameTableInfoStatisticsVo = GameTableInfoStatisticsVo(roundNum: 0,
                                                                                           tieNum: 0,
                                                                                           playerPairNum: 0,
                                                                                           bankerNum: 0,
                                                                                           playerNum: 0,
                                                                                           bankerPairNum: 0)
            }
            // .....
            if let roundNum = data.data?.roundNum {
                self.roomList[index].gameTableInfoStatisticsVo?.roundNum = roundNum
            }
            if let playerNum = data.data?.playerNum {
                self.roomList[index].gameTableInfoStatisticsVo?.playerNum = playerNum
            }
            if let bankerNum = data.data?.bankerNum {
                self.roomList[index].gameTableInfoStatisticsVo?.bankerNum = bankerNum
            }
            if let playerPairNum = data.data?.playerPairNum {
                self.roomList[index].gameTableInfoStatisticsVo?.playerPairNum = playerPairNum
            }
            if let bankerPairNum = data.data?.bankerPairNum {
                self.roomList[index].gameTableInfoStatisticsVo?.bankerPairNum = bankerPairNum
            }
            if let tieNum = data.data?.tieNum {
                self.roomList[index].gameTableInfoStatisticsVo?.tieNum = tieNum
            }
            if let indexRound = self.roomList[index].gameTableResultVos?.firstIndex(where: {$0.roundNo == data.data?.roundNo}) {
                print("update result data in switch")
                self.roomList[index].gameTableResultVos![indexRound].result = data.data?.result ?? ""
                self.roomList[index].gameTableResultVos![indexRound].roundNo = data.data?.roundNo
                self.roomList[index].gameTableResultVos![indexRound].bootNo = data.data?.bootNo ?? ""
            }
            // .....
            self.roomList[index].mapData = nil
            CasinoTimer.shared.updateCasinoDataByIndex(casinoData: self.roomList[index], indexOfCasino: index)
//            let sectionIndex = IndexSet(integer: index)
//            DispatchQueue.main.async {
//                self.switchTable.reloadSections(sectionIndex, with: .none)
//            }
            DispatchQueue.main.async {
                print("updateResultData data in switch")
                let indexPath = IndexPath(item: index, section: 0)
                self.switchTable.reloadItems(at: [indexPath])
            }
        }
    }
    func loginDismissed() {
        self.eventHandler?.getGameCategoryList()
    }
    // Socket Waiting Timer
    func startSocketTimer() {
        if countdownSocket != nil {
            countdownSocket.invalidate()
            countdownSocket = nil
        }
        countdownSocket = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSocketTime), userInfo: nil, repeats: true)
    }
    /*
    @objc func updateSocketTime() {
        if Datamanager.shared.isUserAuthenticated {
            totalwaitingSocketTime += 1
            print("totalwaitingSocketTime ==>", totalwaitingSocketTime)
            if totalwaitingSocketTime > 29 {
                totalwaitingSocketTime = 0
                self.callSocketLobby()
            }
        } else {
            self.endSocketTimer()
        }
    }
    */
    @objc func updateSocketTime() {
        totalwaitingSocketTime += 1
        print("updateSocketTime totalwaitingSocketTime ==>", totalwaitingSocketTime)
        if totalwaitingSocketTime > 20 {
            self.pingToWebSocket()
        }
        if totalwaitingSocketTime == 30 || totalwaitingSocketTime == 40 || totalwaitingSocketTime == 50 || totalwaitingSocketTime == 60 {
            self.callSocketLobby()
        }
    }
    
    func pingToWebSocket() {
        if Datamanager.shared.isUserAuthenticated {
            if self.webSocket != nil && self.webSocket.readyState == .OPEN {
                do {
                    print("pingToWebSocket readyState == .OPEN")
                    try self.webSocket.sendPing(nil)
                } catch { }
            } else if self.webSocket != nil && roomList.count > 0 && self.webSocket.readyState == .CLOSED {
                print("callSocketLobby readyState == .CLOSED")
                self.callSocketLobby()
            } else if self.webSocket != nil && roomList.count > 0 && self.webSocket.readyState == .CLOSING {
                print("callSocketLobby readyState == .CLOSING")
                self.callSocketLobby()
            } else if self.webSocket != nil && roomList.count > 0 && self.webSocket.readyState == .CONNECTING {
                do {
                    print("callSocketLobby readyState == .CONNECTING")
                    try self.webSocket.sendPing(nil)
                } catch { }
            }
        }
    }
    func endSocketTimer() {
        print("endSocketTimer called")
        if countdownSocket != nil {
            countdownSocket.invalidate()
            totalwaitingSocketTime = 0
        }
    }
}
// swiftlint:enable superfluous_disable_command cyclomatic_complexity type_body_length file_length type_name
