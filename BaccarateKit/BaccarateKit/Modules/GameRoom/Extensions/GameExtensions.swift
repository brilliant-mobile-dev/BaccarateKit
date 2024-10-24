
// swiftlint:disable superfluous_disable_command type_body_length file_length cyclomatic_complexity function_body_length
import Foundation
import SocketRocket
extension GameRoomVC: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket, didReceivePingWith data: Data?) {
        totalwaitingSocketTime = 0
    }
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        totalwaitingSocketTime = 0
    }
    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if NetworkMonitor.shared.isConnected {
            if let data = self.groupData {
                self.callSocketRoom(data: data)
            }
        }
    }
    func webSocket(_ webSocket: SRWebSocket,
                   didReceiveMessageWith string: String) {
        print("didReceiveMessageWith ==>", string)
        if (Utils.lastVC() != nil) && !(Utils.lastVC() is GameRoomVC) {
            webSocket.close()
            return
        }
        totalwaitingSocketTime = 0
        do {
            let cryptoData = Data(string.utf8)
            let decoder = JSONDecoder()
            let data = try decoder.decode(LobbySocketData.self, from: cryptoData)
            let gameObj: GameResult = GameResult(rawValue: data.type ?? "") ?? .noData
            switch gameObj {
            case .tableInfo:
                if self.yourGameRound == self.tableInfoData?.autoQuitNum ?? 0 && self.yourGameRound != 0 {
                    if let presentedViewController = self.presentedViewController {
                        presentedViewController.dismiss(animated: false) {
                        }
                    }
                    let alertController = UIAlertController(title: "",
                                                            message: "You have not placed any bets for a long time and have withdrawn from the game".localizable,
                                                            preferredStyle: .alert)
                    self.present(alertController, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            alertController.dismiss(animated: true) {
                                self.backBtnClicked()
                            }
                        }
                    }
                    return
                }
                if self.tableInfoData?.gameTableStatusVo == nil {
                    self.tableInfoData?.gameTableStatusVo = GameTableStatusVo()
                }
                self.tableInfoData?.gameTableStatusVo?.betSecond = data.data?.betSecond
                self.tableInfoData?.gameTableStatusVo?.calcSecond = data.data?.calcSecond
                self.tableInfoData?.gameTableStatusVo?.roundNo = data.data?.roundNo
                if let bootNum = data.data?.bootNo {
                    self.tableInfoData?.gameTableStatusVo?.bootNo = bootNum
                }
                self.tableInfoData?.gameTableStatusVo?.status = data.data?.status
                self.tableInfoData?.gameTableStatusVo?.remainSecond = data.data?.betSecond
                if let currentTabelData =  self.roomList.filter({
                    $0.tableNo ?? "" == data.data?.tableNo ?? "" }
                ).first {
                    currentTabelData.gameTableStatusVo?.betSecond = data.data?.betSecond ?? 20
                    currentTabelData.gameTableStatusVo?.calcSecond = data.data?.calcSecond ?? 20
                    currentTabelData.gameTableStatusVo?.remainSecond = data.data?.remainSecond ?? 20
                    currentTabelData.gameTableStatusVo?.roundNo = data.data?.roundNo
                    currentTabelData.gameTableStatusVo?.status = data.data?.status
                }
                self.setPlayerBankerMatchCount()
                self.setStatus()
            case .roundResult:
                let obj = GameTableResultVo()
                obj.bootNo = data.data?.bootNo
                obj.roundNo = data.data?.roundNo
                obj.result = data.data?.result
                if let index = self.tableResultVoArr.firstIndex(where: {$0.roundNo == data.data?.roundNo}) {
                } else {
                    self.tableResultVoArr.append(obj)
                    self.tableInfoData?.gameTableResultVos?.append(obj)
                    self.setSingleEntryData(item: obj)
                    self.playerRoundResultSetup(data: data)
                }
            case .roundNum:
                self.yourGameRound += 1
                if self.tableInfoData?.gameTableInfoStatisticsVo == nil {
                    self.tableInfoData?.gameTableInfoStatisticsVo = GameTableInfoStatisticsVo(roundNum: 0,
                                                                                              tieNum: 0,
                                                                                              playerPairNum: 0,
                                                                                              bankerNum: 0,
                                                                                              playerNum: 0,
                                                                                              bankerPairNum: 0)
                }
                self.tableInfoData?.gameTableInfoStatisticsVo?.roundNum = data.data?.roundNum
                self.tableInfoData?.gameTableInfoStatisticsVo?.playerNum = data.data?.playerNum
                self.tableInfoData?.gameTableInfoStatisticsVo?.bankerNum = data.data?.bankerNum
                self.tableInfoData?.gameTableInfoStatisticsVo?.playerPairNum = data.data?.playerPairNum
                self.tableInfoData?.gameTableInfoStatisticsVo?.bankerPairNum = data.data?.bankerPairNum
                self.tableInfoData?.gameTableInfoStatisticsVo?.tieNum = data.data?.tieNum
                self.setPlayerBankerMatchCount()
            case .addCard:
                if data.data?.location ?? "" == "player" {
                    // show player third card
                    self.playerCardImage3.isHidden = false
                    self.playerStackWidth.constant = 158
                    GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .playerDraw, addInQueue: true)
                } else if data.data?.location ?? "" == "banker" {
                    // show banker third card
                    self.bankerCardImage3.isHidden = false
                    self.bankerStackWidth.constant = 158
                    GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .bankerDraw, addInQueue: true)
                }
            case .card:
                self.showCardContainerView(type: data.data?.location ?? "",
                                           cardNum: data.data?.result ?? "",
                                           point: data.data?.point ?? 0)
            case .betPot:
                if let betData = data.data?.betPotDetailVos {
                    self.setBetInfoData(data: betData)
                }
                self.hideCardContainerView()
                
            case .betInfo:
                let betData = try decoder.decode(OtherPlayerChip.self, from: cryptoData)
                if let info = betData.data {
                    GameRoomStack.shared.previousRoundNumber = tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0
                    addChipsForOtherPlayers(info: info, firstTimeDraw: false)
                }
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
                    self.walletLabel?.text = (userInfo?.symbol ?? "") + "\(userInfo?.userMoney?.walletAmount ?? "")"
                }
            case .noData:
                break
            case .userEntered:
                if !(self.gamePlayerArr.contains(where: {$0.userID == data.data?.userID})) {
                    let playerData = PlayerData(symbol: data.data?.symbol,
                                                money: data.data?.money,
                                                groupID: data.data?.groupID,
                                                nickname: data.data?.nickname,
                                                currency: data.data?.currency,
                                                seatNo: data.data?.seatNo,
                                                userID: data.data?.userID,
                                                username: data.data?.username)
                    self.gamePlayerArr.append(playerData)
                    self.showViewForOtherPlayer()
                }
            case .userLeave:
                self.gamePlayerArr.removeAll(where: {$0.userID == data.data?.userID})
                self.showViewForOtherPlayer()
            case .reset:
                hideCardContainerView()
            case .updateResult:
                print(" case .updateResult")
                self.updateResultData(data: data)
            }
            self.checkVideoPlayerStatus()
        } catch _ {
        }
    }
    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
    }
    func webSocket(_ webSocket: SRWebSocket, didReceivePong pongData: Data?) {
    }
}
extension GameRoomVC: UpdateChipsDelegate {
    func stopSocketFromAddChips(error: BackendError?) {
        self.endTimer()
        self.endSocketTimer()
        self.closeWebSocketConnection()
    }
    //  self.selectedCoins
    func updateChips(chips: String) {
        ConfigurationDataManager.shared.userInfo?.chips = chips
        userInfo = ConfigurationDataManager.shared.userInfo
        self.initiateUserCoins()
        if let selectCoin = self.selectedCoins {
            if let index = self.coins.firstIndex(where: {$0.value == selectCoin.value}) {
                self.coinSelectedIndex = index
            } else {
                coinSelectedIndex = 2
            }
        }
    }
}
extension GameRoomVC: TableSwitchDelegate {
    func updateGameRoom(casinoData: CasinoTableData) {
        // self.webSocket.close()
        self.totalBetAmount = 0
        self.repeatAmount = 0
        self.closeWebSocketConnection()
        self.mapObj.resetData()
        // Removing Audio Queue
        AudioManager.soundQueue.removeAll()
        self.spreadsheetViewBreadPlate.reloadData()
        self.spreadsheetViewBigMap.reloadData()
        self.spreadsheetViewBigEye.reloadData()
        self.spreadsheetViewSmallEye.reloadData()
        self.spreadsheetViewCockRoachEye.reloadData()
        self.casinoData = casinoData
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupVideoPlayer()
            if let url = self.casinoData?.liveURL as? String {
                self.startLiveStreaming(url: url)
            }
        }
        self.clearStack(removeConfirmBet: true)
        self.clearUnconfirmBet()
        self.resetGameRoom()
        self.setUpRoom()
        self.setbetIsDrawStatus(status: false)
        self.isRepeatDraw = false
    }
}
extension GameRoomVC: GameRoomUI {
    // getTableBetInfo APi Success Response
    func sucessGetBetInfoData(_ data: BetInfoResponse) {
        GameRoomStack.shared.chipTuple.removeAll()
        if let betData = data.datas?.bacBetPotVo?.betPotDetailVos {
            self.setBetInfoData(data: betData)
        }
        if let betData = data.datas?.betRecordVos {
            // Handle logged in own bet coins here ----->>
            if let betForLoginUser = betData.first(where: { $0.userID ?? 0 == self.userInfo?.userID ?? 0}) {
                self.showOwnChipData(bet: betForLoginUser)
            }
            // Handle otherPlayer coins here ----->>
            for bet in betData where bet.userID ?? 0 != self.userInfo?.userID ?? 0 {
                // DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.showOtherChipData(bet: bet)
                //  }
            }
        }
    }
    // enterTableGroup APi Success Response
    func sucessGroupData(_ gameRoomTableData: TableGroupRes) {
        self.gameRoomView.isHidden = false
        self.emptyView.hideView()
        if let data = gameRoomTableData.datas {
            self.gamePlayerArr.removeAll()
            let groupUsers = data.groupUsers ?? [String: GroupUser]()
            for item in groupUsers {
                let playerData = PlayerData(symbol: item.value.symbol,
                                            money: item.value.money,
                                            groupID: item.value.groupID,
                                            nickname: item.value.nickname,
                                            currency: item.value.currency,
                                            seatNo: item.value.seatNo,
                                            userID: item.value.userID,
                                            username: item.value.username)
                self.gamePlayerArr.append(playerData)
            }
            self.showViewForOtherPlayer()
            self.groupData = data
            self.eventHandler?.getBetInfoData(groupNo: data.groupNo ?? "")
            self.startSocketTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.callSocketRoom(data: data)
            }
        }
    }
    // getGameTableInfo APi success Response
    func sucess(_ gameRoomTableData: GameRoomTableData) {
        self.gameRoomView.isHidden = false
        self.emptyView.hideView()
        self.tableInfoData = gameRoomTableData.datas
        if self.tableInfoData?.tableResultType ?? 0 == 2 {
            self.coinTable.reloadData()
        }
        let commisionText = (self.tableInfoData?.userFreeStatus ?? true == true) ? "Comm. Free".localizable : "Comm.".localizable
        Utils.setCommissionFeeButtonAttributedTitle(btn: self.commFreeButton,
                                                    text: commisionText,
                                                    userFreeStatus: self.tableInfoData?.userFreeStatus ?? false,
                                                    bgImage: self.commBgImagView)
        self.setStatus()
        self.tableResultVoArr = gameRoomTableData.datas.gameTableResultVos ?? [GameTableResultVo]()
        self.setPlayerBankerMatchCount()
        if gameRoomTableData.datas.status != 0 && self.tableResultVoArr.count > 0 {
            self.setRoomMapData(data: self.tableResultVoArr)
        }
        self.eventHandler?.getTableGroupData(data: self.casinoData!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        }
    }
    // Bet APi success response
    func sucessSetBetData (_ data: ResponeData) {
        self.repeatAmount = 0
        self.yourGameRound = 0
        self.gameRoomView.isHidden = false
        self.emptyView.hideView()
        // Store Confirm Bet
        confirmpPairStack.removeAll()
        confirmtiePairStack.removeAll()
        confirmbPairStack.removeAll()
        confirmplayerStack.removeAll()
        confirmbankerStack.removeAll()
        confirmpPairStack = pPairStack
        confirmtiePairStack = tiePairStack
        confirmbPairStack  = bPairStack
        confirmplayerStack = playerStack
        confirmbankerStack = bankerStack
        GameRoomStack.shared.pPairStack = confirmpPairStack
        GameRoomStack.shared.tiePairStack = confirmtiePairStack
        GameRoomStack.shared.bPairStack = confirmbPairStack
        GameRoomStack.shared.playerStack = confirmplayerStack
        GameRoomStack.shared.bankerStack = confirmbankerStack
        
        DispatchQueue.main.async {
            self.cancelButtonHandle(isEnable: false)
            self.confirmButtonHandle(isEnable: false)
            self.repeatButtonHandle(isEnable: true)
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            self.isRepeatActive = true
        }
        
        // Save current round number on bet success
        GameRoomStack.shared.previousRoundNumber = tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0
        
        let userMoneyLeft = self.userInfo?.userMoney ?? 0 - totalBetAmount
        if userMoneyLeft > 0 {
            ConfigurationDataManager.shared.userInfo?.userMoney = userMoneyLeft
            self.userInfo = ConfigurationDataManager.shared.userInfo
            self.walletLabel?.text = (userInfo?.symbol ?? "") + "\(userInfo?.userMoney?.walletAmount ?? "")"
            totalBetAmount = 0.0
        }
        self.setbetIsDrawStatus(status: false)
        statusView.showStatus(data.respMsg ?? "")
        self.isRepeatDraw = true
    }
    func cancelButtonHandle(isEnable: Bool) {
        self.cancelButton.backgroundColor = .clear
        if isEnable {
            self.cancelButton.isUserInteractionEnabled = true
            self.cancelButton.setBackgroundImage(UIImage(named: "cancelEnable"), for: .normal)
            self.cancelButton.setBackgroundImage(UIImage(named: "cancelEnable"), for: .selected)
            self.cancelButton.setBackgroundImage(UIImage(named: "cancelEnable"), for: .highlighted)
        } else {
            self.cancelButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .normal)
            self.cancelButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .selected)
            self.cancelButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .highlighted)
            self.cancelButton.isUserInteractionEnabled = false
        }
    }
    func repeatButtonHandle(isEnable: Bool) {
        self.repeatButton.backgroundColor = .clear
        if isEnable {
            self.repeatButton.setBackgroundImage(UIImage(named: "repeatEnable"), for: .normal)
            self.repeatButton.setBackgroundImage(UIImage(named: "repeatEnable"), for: .selected)
            self.repeatButton.setBackgroundImage(UIImage(named: "repeatEnable"), for: .highlighted)
            self.repeatButton.isUserInteractionEnabled = true
            isRepeatActive = true
        } else {
            self.repeatButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .normal)
            self.repeatButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .selected)
            self.repeatButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .highlighted)
            self.repeatButton.isUserInteractionEnabled = false
            isRepeatActive = false
        }
    }
    func confirmButtonHandle(isEnable: Bool) {
        self.confirmButton.backgroundColor = .clear
        if isEnable {
            self.confirmButton.setBackgroundImage(UIImage(named: "confirmEnable"), for: .normal)
            self.confirmButton.setBackgroundImage(UIImage(named: "confirmEnable"), for: .selected)
            self.confirmButton.setBackgroundImage(UIImage(named: "confirmEnable"), for: .highlighted)
            self.confirmButton.isUserInteractionEnabled = true
        } else {
            self.confirmButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .normal)
            self.confirmButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .selected)
            self.confirmButton.setBackgroundImage(UIImage(named: "btnDisable"), for: .highlighted)
            self.confirmButton.isUserInteractionEnabled = false
        }
    }
    
    // leaveTableGroup APi success response
    func sucessLeaveGroup (_ gameRoomTableData: ResponeData) {
        self.closeWebSocketConnection()
        self.endTimer()
        self.endSocketTimer()
        monitor.cancel()
        self.previousVCDelegate?.handlePreviousVCData()
        AudioManager.soundQueue.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    func foundErrorLeaveGroup(_ error: BackendError) {
        self.closeWebSocketConnection()
        self.endTimer()
        self.endSocketTimer()
        monitor.cancel()
        self.previousVCDelegate?.handlePreviousVCData()
        AudioManager.soundQueue.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    func sucessSaveChips (_ data: ResponeData) {
        statusView.showStatus(data.respMsg ?? "successful bet".localizable)
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
            self.closeWebSocketConnection()
            self.endTimer()
            self.endSocketTimer()
        } else {
            totalBetAmount = 0.0
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
    func foundErrorGetData(_ error: BackendError) {
        self.gameRoomView.isHidden = true
        if error.errorCode == 411178 {
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            emptyView.showView(type: .timeOut, title: nil)
        } else if error.errorCode == 401 {
            self.endTimer()
            self.endSocketTimer()
            self.closeWebSocketConnection()
        } else {
            totalBetAmount = 0.0
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
// MARK: Coin CollectionView Delegate & Datasource Methods
extension GameRoomVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coins.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = self.tableInfoData?.gameTableStatusVo?.status ?? 0
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CoinCVCell {
            if indexPath.row == coinSelectedIndex {
                cell.updateView(isSelected: true, coin: coins[indexPath.row])
                DispatchQueue.main.async {
                    //   collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            } else {
                cell.updateView(isSelected: false, coin: coins[indexPath.row])
            }
            if indexPath.row == 0 {
                cell.coinLabel.text = "Custom".localizable
            } else {
                cell.coinLabel.text = ""
            }
          //  if self.tableInfoData?.tableResultType ?? 0 == 2 {
            if self.tableInfoData?.tableResultType ?? 0 == 2 && (status == 2 || status == 4) {
                cell.coinDisbaleView.isHidden = false
             //   cell.coinDisbaleView.backgroundColor = .red
            } else {
                cell.coinDisbaleView.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let status = self.tableInfoData?.gameTableStatusVo?.status ?? 0
        print("self.tableInfoData?.tableResultType ==>", self.tableInfoData?.tableResultType ?? 0)
        print("status ==>", status)
        if !(self.tableInfoData?.tableResultType ?? 0 == 2 && (status == 2 || status == 4)) {
            if indexPath.row == 0 {
                // Add more coins to the coin list
                addMoreChipSetting()
            } else {
                GameAudioVM.shared.playAudio(audioType: .sound, sound: .selectchip, voice: nil, addInQueue: false)
                coinSelectedIndex = indexPath.row
                DispatchQueue.main.async {
                    self.coinTable.reloadData()
                    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if coinSelectedIndex == indexPath.row {
            return CGSize(width: 75, height: 75)
        }
        return CGSize(width: 60, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let space = collectionView.frame.width / 18
        return space
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let space = collectionView.frame.width / 18
        return space
    }
    func setPlayerBankerMatchCount() {
        let matchNum = ("Round No.".localizable) + ": " + "\(self.tableInfoData?.gameTableStatusVo?.roundNo ?? "")  "
        let betLimit = ("Betting limit".localizable) +
        ": " + "\(casinoData?.lobbyTableLimit ?? "")"
        self.matchNumRoomLbl.text = matchNum
        self.matchBetLimitRoomLbl.text = betLimit
        roundNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0)"
        if self.currentRoundNum > self.tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0 {
            self.resetGameRoom()
        }
        self.currentRoundNum = self.tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0
        playerNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.playerNum ?? 0)"
        playerPairNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.playerPairNum ?? 0)"
        bankerNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.bankerNum ?? 0)"
        bankerPairNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.bankerPairNum ?? 0)"
        tieNumberValueLbl.text = "\(self.tableInfoData?.gameTableInfoStatisticsVo?.tieNum ?? 0)"
        self.pPRoomValueLbl.text =
        " 1:" + "\((self.tableInfoData?.bacOddsVo?.playerPair ?? 0).afterDecimal2DigitNoZero)"
        self.tieRoomValueLbl.text =
        " 1:" + "\((self.tableInfoData?.bacOddsVo?.tie ?? 0).afterDecimal2DigitNoZero)"
        self.bPRoomValueLbl.text = " 1:" + "\((self.tableInfoData?.bacOddsVo?.bankerPair ?? 0).afterDecimal2DigitNoZero)"
        self.pRoomValueLbl.text = " 1:" + "\((self.tableInfoData?.bacOddsVo?.player ?? 0).afterDecimal2DigitNoZero)"
        if self.tableInfoData?.userFreeStatus == true {
            self.bRoomValueLbl.text =
            " 1:" + "\((self.tableInfoData?.bacOddsVo?.bankerFree ?? 0).afterDecimal2DigitNoZero)"
        } else {
            self.bRoomValueLbl.text =
            " 1:" + "\((self.tableInfoData?.bacOddsVo?.banker ?? 0).afterDecimal2DigitNoZero)"
        }
    }
    func setStatus() {
        circularProgressBarView.isHidden = false
        let commisionText = (self.tableInfoData?.userFreeStatus ?? true == true) ? "Comm. Free".localizable : "Comm.".localizable
        if (self.tableInfoData?.gameTableStatusVo?.status ?? 0) != 4 && (self.tableInfoData?.gameTableStatusVo?.status ?? 0) != 2 {
            Utils.setCommissionFeeButtonAttributedTitle(btn: self.commFreeButton,
                                                        text: commisionText,
                                                        userFreeStatus: self.tableInfoData?.userFreeStatus ?? true,
                                                        bgImage: self.commBgImagView)
        } else {
            Utils.setCommissionFeeButtonAttributedTitle(btn: self.commFreeButton, text: commisionText, bgImage: self.commBgImagView)
        }
        switch self.tableInfoData?.gameTableStatusVo?.status {
        case 0:
            self.clearBettingAreaView()
            clearStack(removeConfirmBet: true)
            self.statusLabel.textColor =  UIColor.white
            self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
            statusLabel.text = "Shuffling".localizable
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = false
            self.repeatButtonHandle(isEnable: false)
            // Reset RoadMaps
            self.checkVideoPlayerStatus()
            self.resetGameRoom()
            self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
            if self.countdownTimer == nil || self.countdownTimer.isValid == false {
                self.startSocketTimer()
            }
            
        case 1:
            self.clearBettingAreaView()
            self.endSocketTimer()
            self.statusLabel.isHidden = false
            if self.tableInfoData?.gameTableStatusVo?.remainSecond ?? 0 > 0 {
                statusView.showStatus("Start betting".localizable)
                // Play Start Betting
                GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .placeYourBetStart, addInQueue: true)
                self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
                let remainTotalBetTime = self.tableInfoData?.gameTableStatusVo?.remainSecond ?? 20
                statusLabel.text = "\(Utils.timeFormatted(remainTotalBetTime))" + ""
                self.totalBetTime = self.tableInfoData?.gameTableStatusVo?.remainSecond ?? 20
                self.startTimer()
                self.hideCardContainerView()
                clearStack(removeConfirmBet: true)
                self.circularProgressBarView.circleLayer.strokeColor = UIColor.lightGray.cgColor
            }
        case 2:
            self.clearBettingAreaView()
            self.endTimer()
            self.startSocketTimer()
            // self.endSocketTimer()
            self.statusLabel.textColor =  UIColor.white
            self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
            statusLabel.text = "Opening".localizable
            showMarqueAnimation(selected: .noOne)
            showCardContainerView(type: "", cardNum: "", point: 0)
            // Show Status`
            statusView.showStatus("Stop betting".localizable)
            clearUnconfirmBet()
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .stopBet, addInQueue: true)
            self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
            //  self.circularProgressBarView.circleLayer.strokeColor = UIColor.clear.cgColor
        case 4:
            self.startSocketTimer()
            self.statusLabel.textColor =  UIColor.white
            self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
            statusLabel.text = "Settlement".localizable
            self.endTimer()
            self.removePreviousBetData()
            //   self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
            // self.circularProgressBarView.circleLayer.strokeColor = self.circularProgressBarView.circleLayer.fillColor
            self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
            clearStack(removeConfirmBet: true)
        case -1:
            //  self.endSocketTimer()
            self.startSocketTimer()
            self.statusLabel.textColor =  UIColor.white
            self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
            statusLabel.text = "Settlement".localizable
            self.endTimer()
            self.removePreviousBetData()
            //  self.circularProgressBarView.circleLayer.strokeColor = self.circularProgressBarView.circleLayer.fillColor
            self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
            clearStack(removeConfirmBet: true)
        default:
            self.endSocketTimer()
        }
        self.coinTable.reloadData()
        currentGameStatus = self.tableInfoData?.gameTableStatusVo?.status
    }
    func testSuffle() {
        self.clearBettingAreaView()
        clearStack(removeConfirmBet: true)
        self.statusLabel.textColor =  UIColor.white
        self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
        statusLabel.text = "Shuffling".localizable
        Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
        isRepeatActive = false
        self.repeatButtonHandle(isEnable: false)
        // Reset RoadMaps
        self.checkVideoPlayerStatus()
        self.resetGameRoom()
        self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        self.startSocketTimer()
    }
}
extension GameRoomVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none // 3
    }
}
extension GameRoomVC {
    // Socket Waiting Timer
    func updateResultData(data: LobbySocketData) {
        print("self.tableResultVoArr12 ==>", self.tableResultVoArr.count)
        if let index = self.tableResultVoArr.firstIndex(where: {$0.roundNo == data.data?.roundNo}) {
            print("updateResultData called")
            self.tableResultVoArr[index].result = data.data?.result ?? ""
            self.tableResultVoArr[index].roundNo = data.data?.roundNo
            self.tableResultVoArr[index].bootNo = data.data?.bootNo ?? ""
            self.tableInfoData?.gameTableResultVos?[index].result = data.data?.result ?? ""
            self.tableInfoData?.gameTableResultVos?[index].roundNo = data.data?.roundNo ?? ""
            self.tableInfoData?.gameTableResultVos?[index].bootNo = data.data?.bootNo ?? ""
     //   }
        //   self.setPlayerBankerMatchCount()
        if let roundNum = data.data?.roundNum {
           // self.tableInfoData?.gameTableInfoStatisticsVo?.roundNum = roundNum
        }
        if let playerNum = data.data?.playerNum {
            self.tableInfoData?.gameTableInfoStatisticsVo?.playerNum = playerNum
        }
        if let bankerNum = data.data?.bankerNum {
            self.tableInfoData?.gameTableInfoStatisticsVo?.bankerNum = bankerNum
        }
        if let playerPairNum = data.data?.playerPairNum {
            self.tableInfoData?.gameTableInfoStatisticsVo?.playerPairNum = playerPairNum
        }
        if let bankerPairNum = data.data?.bankerPairNum {
            self.tableInfoData?.gameTableInfoStatisticsVo?.bankerPairNum = bankerPairNum
        }
        if let tieNum = data.data?.tieNum {
            self.tableInfoData?.gameTableInfoStatisticsVo?.tieNum = tieNum
        }
            print("self.tableResultVoArr11 ==>", self.tableResultVoArr.count)
        print("self.mapObj.bigMapArr.count11 ==>", self.mapObj.bigMapArr.count)
        print("self.mapObj.breadPlateArr.count11 ==>", self.mapObj.breadPlateArr.count)
        if data.data?.status != 0 && self.tableResultVoArr.count > 0 {
                self.setRoomMapData(data: self.tableResultVoArr)
        }
        print("self.mapObj.bigMapArr.count ==>", self.mapObj.bigMapArr.count)
        print("self.mapObj.breadPlateArr.count ==>", self.mapObj.breadPlateArr.count)
        self.setPlayerBankerMatchCount()
        print("self.mapObj.bigMapArr.count1 ==>", self.mapObj.bigMapArr.count)
        print("self.mapObj.breadPlateArr.count1 ==>", self.mapObj.breadPlateArr.count)
        if (self.tableInfoData?.gameTableStatusVo?.status ?? 0 == 4 || self.tableInfoData?.gameTableStatusVo?.status ?? 0 == -1) &&
            (self.tableInfoData?.gameTableStatusVo?.roundNo == data.data?.roundNo ?? "") {
            print("playerRoundResultSetup called")
            self.playerRoundResultSetup(data: data)
            let banker1 = data.data?.banker1 ?? ""
            let banker2 = data.data?.banker2 ?? ""
            let banker3 = data.data?.banker3 ?? ""
            let player1 = data.data?.player1 ?? ""
            let player2 = data.data?.player2 ?? ""
            let player3 = data.data?.player3 ?? ""
            self.showCardContainerView(type: "player1",
                                       cardNum: player1,
                                       point: data.data?.playerPoint ?? 0)
            self.showCardContainerView(type: "player2",
                                       cardNum: player2,
                                       point: data.data?.playerPoint ?? 0)
            
            self.showCardContainerView(type: "banker1",
                                       cardNum: banker1,
                                       point: data.data?.bankerPoint ?? 0)
            self.showCardContainerView(type: "banker2",
                                       cardNum: banker2,
                                       point: data.data?.bankerPoint ?? 0)
            if !player3.isEmpty {
                self.showCardContainerView(type: "player3",
                                           cardNum: player3,
                                           point: data.data?.playerPoint ?? 0)
            }
            if !banker3.isEmpty {
                self.showCardContainerView(type: "banker3",
                                           cardNum: banker3,
                                           point: data.data?.bankerPoint ?? 0)
            }
        }
            print("self.mapObj.bigMapArr.count2 ==>", self.mapObj.bigMapArr.count)
            print("self.mapObj.breadPlateArr.count2 ==>", self.mapObj.breadPlateArr.count)
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
        totalwaitingSocketTime += 1
        if totalwaitingSocketTime > 29 {
            self.pingToWebSocket()
        }
        if totalwaitingSocketTime > 90 {
            if self.webSocket != nil && self.groupData != nil && self.webSocket.readyState == .OPEN {
                if self.tableInfoData?.gameTableStatusVo?.status == 0 {
                    //  self.closeWebSocketConnection()
                    self.callSocketRoom(data: self.groupData!)
                }
            }
        }
    }
    func endSocketTimer() {
        if countdownSocket != nil {
            countdownSocket.invalidate()
        }
    }
    
    // Game Timer
    func startTimer() {
        setUpCircularProgressBarView()
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
        if self.totalBetTime == 20 {
            self.totalBetTime = 19
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeGameRoom), userInfo: nil, repeats: true)
    }
    @objc func updateTimeGameRoom() {
        self.statusLabel.textColor =  UIColor.white
        let totalTimeFormated = "\(Utils.timeFormatted(totalBetTime))" + ""
        self.statusLabel.text = totalTimeFormated
        if let currentTabelData =  self.roomList.filter({$0.tableNo ?? "" == self.casinoData?.tableNo ?? ""}).first {
            currentTabelData.gameTableStatusVo?.remainSecond = totalBetTime
        }
        if totalBetTime != 0 {
            totalBetTime -= 1
            if totalBetTime < 5 {
                self.circularProgressBarView.progressLayer.strokeColor = UIColor.red.cgColor
                // self.statusLabel.textColor = UIColor.red
                self.statusLabel.textColor = UIColor.white
                if totalBetTime < 3 {
                    if webSocket != nil && webSocket.readyState == .OPEN {
                        GameAudioVM.shared.playAudio(audioType: .sound, sound: .countdown, voice: nil, addInQueue: false)
                    }
                }
            } else {
                self.circularProgressBarView.progressLayer.strokeColor = UIColor.green.cgColor
                self.statusLabel.textColor =  UIColor.white
            }
            //  self.statusLabel.isHidden = false
        } else {
            if self.tableInfoData?.status ?? 0 == 1 {
            }
            self.endTimer()
            self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
            self.statusLabel.textColor =  UIColor.white
            if let statusCode = self.tableInfoData?.gameTableStatusVo?.status {
                self.statusLabel.text = Utils.getStatus(statusCode: statusCode)
                self.pingToWebSocket()
                self.startSocketTimer()
            }
            self.tableInfoData?.gameTableStatusVo?.remainSecond = 0
        }
    }
    func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
        }
    }
}
extension GameRoomVC {
    func setPredictImage() {
        self.bankerPreditBigIcon.image = UIImage(named: "empty")
        self.playerPreditBigIcon.image = UIImage(named: "empty")
        self.bankerPreditSmalIcon.image = UIImage(named: "empty")
        self.playerPreditSmalIcon.image = UIImage(named: "empty")
        self.bankerPreditCRoachIcon.image = UIImage(named: "empty")
        self.playerPreditCRoachIcon.image = UIImage(named: "empty")
        if let lastNode = self.predictNode.bigEyeNode {
            let imageIcon = lastNode.name ?? "empty"
            self.bankerPreditBigIcon.image = UIImage(named: Utils.getImageIconForPredictForbanker(imageIcon: imageIcon))
            self.playerPreditBigIcon.image = UIImage(named: Utils.getImageIconForPredict(imageIcon: imageIcon))
        }
        if let lastNode = self.predictNode.smallEyeNode {
            let imageIcon = lastNode.name ?? "empty"
            self.bankerPreditSmalIcon.image = UIImage(named: Utils.getImageIconForPredictForbanker(imageIcon: imageIcon))
            self.playerPreditSmalIcon.image = UIImage(named: Utils.getImageIconForPredict(imageIcon: imageIcon))
        }
        if let lastNode = self.predictNode.cockRoachNode {
            let imageIcon = lastNode.name ?? "empty"
            self.bankerPreditCRoachIcon.image = UIImage(named: Utils.getImageIconForPredictForbanker(imageIcon: imageIcon))
            self.playerPreditCRoachIcon.image = UIImage(named: Utils.getImageIconForPredict(imageIcon: imageIcon))
        }
    }
    func resetPredictionImage() {
        if let lastNode = self.predictNode.breadPlateNode, let lastNodeP = self.predictNode.breadPlateNodeP {
            // swiftlint:disable:next line_length
            if let cell = (spreadsheetViewBreadPlate.cellForItem(at: IndexPath(row: lastNode.row ?? 0, column: lastNode.column ?? 0)) as? SlotCell), let cellP = (spreadsheetViewBreadPlate.cellForItem(at: IndexPath(row: lastNodeP.row ?? 0, column: lastNodeP.column ?? 0)) as? SlotCell) {
                cell.imgIcon.layer.removeAllAnimations()
                cellP.imgIcon.layer.removeAllAnimations()
            }
        }
        if let lastNode = self.predictNode.bigRoadNode, let lastNodeP = self.predictNode.bigRoadNodeP {
            // swiftlint:disable:next line_length
            if let cell = (spreadsheetViewBigMap.cellForItem(at: IndexPath(row: lastNode.row ?? 0, column: lastNode.column ?? 0)) as? SlotCell), let cellP = (spreadsheetViewBigMap.cellForItem(at: IndexPath(row: lastNodeP.row ?? 0, column: lastNodeP.column ?? 0)) as? SlotCell) {
                cell.imgIcon.layer.removeAllAnimations()
                cellP.imgIcon.layer.removeAllAnimations()
            }
        }
        if let lastNode = self.predictNode.bigEyeNode, let lastNodeP = self.predictNode.bigEyeNodeP {
            // swiftlint:disable:next line_length
            if let cell = (spreadsheetViewBigEye.cellForItem(at: IndexPath(row: lastNode.row ?? 0, column: lastNode.column ?? 0)) as? SlotCell), let cellP = (spreadsheetViewBigEye.cellForItem(at: IndexPath(row: lastNodeP.row ?? 0, column: lastNodeP.column ?? 0)) as? SlotCell) {
                cell.imgIcon.layer.removeAllAnimations()
                cellP.imgIcon.layer.removeAllAnimations()
            }
        }
        if let lastNode = self.predictNode.smallEyeNode, let lastNodeP = self.predictNode.smallEyeNodeP {
            // swiftlint:disable:next line_length
            if let cell = (spreadsheetViewSmallEye.cellForItem(at: IndexPath(row: lastNode.row ?? 0, column: lastNode.column ?? 0)) as? SlotCell), let cellP = (spreadsheetViewSmallEye.cellForItem(at: IndexPath(row: lastNodeP.row ?? 0, column: lastNodeP.column ?? 0)) as? SlotCell) {
                cell.imgIcon.layer.removeAllAnimations()
                cellP.imgIcon.layer.removeAllAnimations()
            }
        }
        if let lastNode = self.predictNode.cockRoachNode, let lastNodeP = self.predictNode.cockRoachNodeP {
            // swiftlint:disable:next line_length
            if let cell = (spreadsheetViewCockRoachEye.cellForItem(at: IndexPath(row: lastNode.row ?? 0, column: lastNode.column ?? 0)) as? SlotCell), let cellP = (spreadsheetViewCockRoachEye.cellForItem(at: IndexPath(row: lastNodeP.row ?? 0, column: lastNodeP.column ?? 0)) as? SlotCell) {
                cell.imgIcon.layer.removeAllAnimations()
                cellP.imgIcon.layer.removeAllAnimations()
            }
        }
    }
    // swiftlint:disable:next function_body_length
    func setPredictImageAnimation(tag: Int) {
        self.resetPredictionImage()
        let breadPlateNode = (tag == 2) ? self.predictNode.breadPlateNodeP : self.predictNode.breadPlateNode
        let bigRoadNode = (tag == 2) ? self.predictNode.bigRoadNodeP : self.predictNode.bigRoadNode
        let bigEyeNode = (tag == 2) ? self.predictNode.bigEyeNodeP : self.predictNode.bigEyeNode
        let smallEyeNode = (tag == 2) ? self.predictNode.smallEyeNodeP : self.predictNode.smallEyeNode
        let cockRoachNode = (tag == 2) ? self.predictNode.cockRoachNodeP : self.predictNode.cockRoachNode
        if let lastNode = breadPlateNode {
            let clmn = lastNode.column
            let row = lastNode.row
            let imageIcon = lastNode.name ?? "empty"
            let indexPath = IndexPath(row: row ?? 0, column: clmn ?? 0)
            if let cell = spreadsheetViewBreadPlate.cellForItem(at: indexPath) as? SlotCell {
                if imageIcon.contains("player") {
                    cell.titleLbl.text = "P".localizable
                } else if imageIcon.contains("banker") {
                    cell.titleLbl.text = "B".localizable
                }
                ShowImageAnimation.showAnimation(imgView: cell.imgIcon, imageIcon: imageIcon)
            }
        }
        if let lastNode = bigRoadNode {
            let clmn = lastNode.column
            let row = lastNode.row
            let imageIcon = lastNode.name ?? "empty"
            let indexPath = IndexPath(row: row ?? 0, column: clmn ?? 0)
            if let cell = spreadsheetViewBigMap.cellForItem(at: indexPath) as? SlotCell {
                ShowImageAnimation.showAnimation(imgView: cell.imgIcon, imageIcon: imageIcon)
            }
        }
        if let lastNode = bigEyeNode {
            let clmn = lastNode.column
            let row = lastNode.row
            let imageIcon = lastNode.name ?? "empty"
            let indexPath = IndexPath(row: row ?? 0, column: clmn ?? 0)
            if let cell = spreadsheetViewBigEye.cellForItem(at: indexPath) as? SlotCell {
                ShowImageAnimation.showAnimation(imgView: cell.imgIcon, imageIcon: imageIcon)
            }
        }
        if let lastNode = smallEyeNode {
            let clmn = lastNode.column
            let row = lastNode.row
            let imageIcon = lastNode.name ?? "empty"
            let indexPath = IndexPath(row: row ?? 0, column: clmn ?? 0)
            if let cell = spreadsheetViewSmallEye.cellForItem(at: indexPath) as? SlotCell {
                ShowImageAnimation.showAnimation(imgView: cell.imgIcon, imageIcon: imageIcon)
            }
        }
        if let lastNode = cockRoachNode {
            let clmn = lastNode.column
            let row = lastNode.row
            let imageIcon = lastNode.name ?? "empty"
            let indexPath = IndexPath(row: row ?? 0, column: clmn ?? 0)
            if let cell = spreadsheetViewCockRoachEye.cellForItem(at: indexPath) as? SlotCell {
                ShowImageAnimation.showAnimation(imgView: cell.imgIcon, imageIcon: imageIcon)
            }
        }
    }
}
extension GameRoomVC: UpdateUserFreeStatusDelegate, LoginDismissDelegate {
    func stopSocketFromFreeStatus(error: BackendError?) {
        self.endTimer()
        self.endSocketTimer()
        self.closeWebSocketConnection()
    }
    func loginDismissed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupVideoPlayer()
            if let url = self.casinoData?.liveURL as? String {
                self.startLiveStreaming(url: url)
            }
        }
        self.setUpRoom()
    }
    func updateFreeStatus(freeStatus: String) {
        self.tableInfoData?.userFreeStatus = (freeStatus == "true") ? true : false
        let commisionText = (self.tableInfoData?.userFreeStatus ?? true == true) ? "Comm. Free".localizable : "Comm.".localizable
        Utils.setCommissionFeeButtonAttributedTitle(btn: self.commFreeButton,
                                                    text: commisionText,
                                                    userFreeStatus: self.tableInfoData?.userFreeStatus ?? false,
                                                    bgImage: self.commBgImagView)
        self.setPlayerBankerMatchCount()
        statusView.showStatus("Successfully modified".localizable)
    }
}
