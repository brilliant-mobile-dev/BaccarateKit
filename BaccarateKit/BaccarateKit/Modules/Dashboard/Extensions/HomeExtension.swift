//
//  HomeExtension.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//

import Foundation
import SocketRocket
// swiftlint:disable superfluous_disable_command cyclomatic_complexity function_body_length
extension HomeVC: SRWebSocketDelegate {
    public func webSocket(_ webSocket: SRWebSocket, didReceivePingWith data: Data?) {
        totalwaitingSocketTime = 0
    }
    public func webSocket(_ webSocket: SRWebSocket, didReceivePong pongData: Data?) {
    }
    public func webSocketDidOpen(_ webSocket: SRWebSocket) {
        totalwaitingSocketTime = 0
    }
    public func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if NetworkMonitor.shared.isConnected {
            self.callSocketLobby()
        }
    }
    public func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
    }
    public func webSocket(_ webSocket: SRWebSocket, didReceiveMessageWith string: String) {
        print("didReceiveMessageWith ==>", string)
        totalwaitingSocketTime = 0
        do {
            let cryptoData = Data(string.utf8)
            let decoder = JSONDecoder()
            let data = try decoder.decode(LobbySocketData.self, from: cryptoData)
            let gameObj: GameResult = GameResult(rawValue: data.type ?? "") ?? .noData
            switch gameObj {
            case .tableInfo:
             //   print("before tableInfo roomList.reloadItems for \(data.data?.tableNo ?? "")")
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
                        let sectionIndex = IndexSet(integer: index)
                        DispatchQueue.main.async {
                            self.roomTable.reloadSections(sectionIndex, with: .none)
                        //    print("After tableInfo roomList.reloadItems for \(data.data?.tableNo ?? "")")
                        }
                    }
                }
            case .roundResult:
                if let currentTabelData = self.roomList.filter({$0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
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
                    currentTabelData.gameTableResultVos?.removeAll(where: {$0.bootNo != data.data?.bootNo })
                    if let index = self.roomList.firstIndex(where: {$0.tableNo == data.data?.tableNo}) {
                     //   print("before switchTable.reloadItems for \(data.data?.tableNo ?? "")")
                        CasinoTimer.shared.updateCasinoDataByIndex(casinoData: currentTabelData, indexOfCasino: index)
                        if !(self.roomList[index].mapData == nil && newEntry == false) {
                            let mapData = RoadMaps().generateSingleEntryRoadMap(item: obj, mapData: self.roomList[index].mapData)
                            self.roomList[index].mapData = mapData
                            DispatchQueue.main.async {
                                self.roomTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
                             //   print("After switchTable.reloadItems for \(data.data?.tableNo ?? "")")
                            }
                        }
                    }
                }
            case .roundNum:
                if let currentTabelData = self.roomList.filter({$0.tableNo ?? "" == data.data?.tableNo ?? ""}).first {
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
                        let sectionIndex = IndexSet(integer: index)
                        DispatchQueue.main.async {
                            self.roomTable.reloadSections(sectionIndex, with: .none)
                        }
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
                let totalPayoffMoney = data.data?.totalPayoffMoney ?? 0
                if totalPayoffMoney > 0 {
                    let price = totalPayoffMoney.afterDecimal2DigitNoZero
                    //
                    SuccessPopupManager.shared.showSuccessPopup(on: self, header: "Receive payout".localizable, price: (userInfo?.symbol ?? "$").appending("\(price)"))
                }
            case .money:
                if self.userInfo?.userID == data.data?.userID {
                    ConfigurationDataManager.shared.userInfo?.userMoney = data.data?.userMoney ?? self.userInfo?.userMoney
                    ConfigurationDataManager.shared.userInfo?.washCodeMoney = data.data?.washCodeMoney ?? self.userInfo?.washCodeMoney
                    self.userInfo = ConfigurationDataManager.shared.userInfo
                    if let userData = self.userInfo {
                        createCustomBarButton(userInfo: userData)
                    }
                }
            case .noData:
                break
            case .userEntered:
                break
            case .userLeave:
                break
            case .reset:
                break
            case .updateResult:
                print("string in home vc ==>", string)
                self.updateResultData(data: data)
                
            }
        } catch _ {
            if let dic = Utils.convertStringToDictionary(text: string) {
                if let onlineNum = dic["data"] as? Int {
                    self.onlineNumber.text = "\(onlineNum)"
                }
            }
        }
    }
}
extension HomeVC: LanguageSelectionDelegate, ValidBetDelegate {
    func validBetUpdate(washCodeMoney: Double, message: String) {
        let userMoney = (self.userInfo?.userMoney ?? 0)
        self.userInfo?.userMoney = userMoney + washCodeMoney
        self.userInfo?.washCodeMoney = 0.0
        ConfigurationDataManager.shared.userInfo = self.userInfo
        if userInfo != nil {
            self.createCustomBarButton(userInfo: self.userInfo!)
        }
        let price = washCodeMoney.afterDecimal2DigitNoZero
        SuccessPopupManager.shared.showSuccessPopup(on: self, header: message, price: (userInfo?.symbol ?? "$").appending("\(price)"))
    }
    
    func languageSelected(languageData: LanguageData) {
        currentVC = self
        if Datamanager.shared.isUserAuthenticated {
            // Get Room List when user authenticated
            self.eventHandler = DashboardPresenter(ui: self, wireframe: ProjectWireframe())
            self.getAPiCall()
        } else {
            // Show Login VC when user not authenticated
            showLoginVC()
        }
    }
}
extension HomeVC: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none // 3
    }
}
extension HomeVC {
    // Socket Waiting Timer
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
                self.roomList[index].gameTableResultVos![indexRound].result = data.data?.result ?? ""
                self.roomList[index].gameTableResultVos![indexRound].roundNo = data.data?.roundNo
                self.roomList[index].gameTableResultVos![indexRound].bootNo = data.data?.bootNo ?? ""
            }
            // .....
            self.roomList[index].mapData = nil
            CasinoTimer.shared.updateCasinoDataByIndex(casinoData: self.roomList[index], indexOfCasino: index)
            let sectionIndex = IndexSet(integer: index)
            DispatchQueue.main.async {
                self.roomTable.reloadSections(sectionIndex, with: .none)
            }
        }
    }
    func startSocketTimer() {
        if countdownSocket != nil {
            countdownSocket.invalidate()
            countdownSocket = nil
        }
        countdownSocket = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSocketTime), userInfo: nil, repeats: true)
    }
    @objc func updateSocketTime() {
        if Datamanager.shared.isUserAuthenticated {
            totalwaitingSocketTime += 1
            if totalwaitingSocketTime > 29 {
                totalwaitingSocketTime = 0
                self.callSocketLobby()
            }
        } else {
            self.endSocketTimer()
        }
    }
    func endSocketTimer() {
        if countdownSocket != nil {
            countdownSocket.invalidate()
            totalwaitingSocketTime = 0
        }
    }
}

