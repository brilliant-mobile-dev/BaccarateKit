//
//  SwitchCellExtension.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 20/9/23.
//
// swiftlint:disable superfluous_disable_command cyclomatic_complexity type_body_length file_length type_name large_tuple
import Foundation
import SpreadsheetView
extension SwitchRoomCVCell: SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return self.cellHeight
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return self.cellHeight
    }
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return ((mapObj.bigMapArr.count + 20) < 60) ? 60 : (mapObj.bigMapArr.count + 40)
    }
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 6
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SlotCell.self),
                                                       for: indexPath) as? SlotCell
        cell?.tag = indexPath.column
        cell?.titleLbl.text = ""
        // cell.imgIcon.image = UIImage(named: "empty")
        cell?.setData(dataArr: mapObj.bigMapArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
        return cell!
    }
}

extension SwitchRoomCVCell {
    func manageScrollReload(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumn + 1)
        self.spreadSheet.scrollToItem(at: indexPath, at: .right, animated: false)
    }
}
extension SwitchRoomCVCell {
    func startTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
        if totalBetTime < 5 {
            self.statusLabel.textColor =  UIColor.red
        } else {
            self.statusLabel.textColor =  UIColor.tieColor
        }
        if self.totalBetTime == 20 {
            self.totalBetTime = 19
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTime),
                                              userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.statusLabel.textColor =  UIColor.tieColor
        self.statusLabel.text = "\(Utils.timeFormatted(totalBetTime))" + ""
        self.casinoTabledata?.gameTableStatusVo?.remainSecond = totalBetTime
        if totalBetTime != 0 {
            totalBetTime -= 1
            if totalBetTime < 5 {
                self.statusLabel.textColor =  UIColor.red
            } else {
                self.statusLabel.textColor =  UIColor.tieColor
            }
            //  self.statusLabel.isHidden = false
        } else {
            if self.casinoTabledata?.status ?? 0 == 1 {
                //  showCardContainerView(type: "open", cardNum: "")
            }
            endTimer()
            self.statusLabel.textColor =  UIColor.white
            self.statusLabel.text = ""
            self.casinoTabledata?.gameTableStatusVo?.remainSecond = 0
           // self.setStatus()
            if let statusCode = self.casinoTabledata?.gameTableStatusVo?.status {
                self.statusLabel.font = .appFont(family: .regular, size: 14)
                self.statusLabel.textColor =  .statusColor
                self.statusLabel.text = Utils.getStatus(statusCode: statusCode)
             }
        }
    }
    func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    func setStatus() {
        self.statusLabel.font = .appFont(family: .regular, size: 14)
        if self.casinoTabledata?.status != nil && self.casinoTabledata?.status == 0 {
            self.statusLabel.textColor =  .statusColor
            statusLabel.text = "Under maintenance".localizable
        } else {
            switch self.casinoTabledata?.gameTableStatusVo?.status {
            case 0:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Shuffling".localizable
                self.casinoTabledata?.gameTableResultVos?.removeAll()
                self.spreadSheet.reloadData()
                self.endTimer()
            case 1:
                self.statusLabel.isHidden = false
                self.statusLabel.font = .appFont(family: .bold, size: 14)
                if self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 0 > 0 {
                    // Show Status
                   
                    if self.casinoTabledata?.gameTableStatusVo?.remainSecond != nil {
                        self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 20
                    } else {
                        statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20)"
                        self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20
                    }
                    self.totalBetTime = CasinoTimer.shared.getTimerValueByIndex(indexOfCasino: self.tag)
                    self.statusLabel.text = "\(Utils.timeFormatted(totalBetTime))"
                    self.startTimer()
                } else {
                    statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20)"
                    self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20
                    self.totalBetTime = CasinoTimer.shared.getTimerValueByIndex(indexOfCasino: self.tag)
                    self.statusLabel.text = "\(Utils.timeFormatted(totalBetTime))"
                    self.startTimer()
                }
            case 2:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Opening".localizable
            case 4:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Settlement".localizable
                self.endTimer()
            case -1:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Settlement".localizable
                self.endTimer()
            default:
                statusLabel.text = ""
            }
        }
    }
}
/*
extension SwitchRoomCVCell {
    func manageScrollReload(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: self.currentColumn + 1)
        self.spreadSheet.scrollToItem(at: indexPath, at: .right, animated: false)
    }
}
extension SwitchRoomCVCell {
    func startTimer() {
        if totalBetTime < 5 {
            self.statusLabel.textColor =  UIColor.red
        } else {
            self.statusLabel.textColor =  UIColor.tieColor
        }
        if self.totalBetTime == 20 {
            self.totalBetTime = 19
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTime),
                                              userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.statusLabel.textColor =  UIColor.tieColor
        self.statusLabel.text = "\(Utils.timeFormatted(totalBetTime))" + ""
        self.casinoTabledata?.gameTableStatusVo?.remainSecond = totalBetTime
        if totalBetTime != 0 {
            totalBetTime -= 1
            if totalBetTime < 5 {
                self.statusLabel.textColor =  UIColor.red
            } else {
                self.statusLabel.textColor =  UIColor.tieColor
            }
            //  self.statusLabel.isHidden = false
        } else {
            if self.casinoTabledata?.status ?? 0 == 1 {
                //  showCardContainerView(type: "open", cardNum: "")
            }
            endTimer()
            self.statusLabel.textColor =  UIColor.white
            self.statusLabel.text = ""
            self.casinoTabledata?.gameTableStatusVo?.remainSecond = 0
           // self.setStatus()
            if let statusCode = self.casinoTabledata?.gameTableStatusVo?.status {
                self.statusLabel.font = .appFont(family: .regular, size: 14)
                self.statusLabel.textColor =  .statusColor
                self.statusLabel.text = Utils.getStatus(statusCode: statusCode)
             }
        }
    }
    func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
        }
    }
    func setStatus() {
        self.statusLabel.font = .appFont(family: .regular, size: 14)
        if self.casinoTabledata?.status != nil && self.casinoTabledata?.status == 0 {
            self.statusLabel.textColor =  .statusColor
            statusLabel.text = "Under maintenance".localizable
        } else {
            switch self.casinoTabledata?.gameTableStatusVo?.status {
            case 0:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Shuffling".localizable
                self.endTimer()
//            case 1:
//                self.statusLabel.isHidden = false
//                self.statusLabel.font = .appFont(family: .bold, size: 14)
//                if self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 0 > 0 {
//                    // Show Status
//                    statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 20)"
//                    self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 20
//                    self.startTimer()
//                }
            case 1:
                self.statusLabel.isHidden = false
                self.statusLabel.font = .appFont(family: .bold, size: 14)
                if self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 0 > 0 {
                    // Show Status
                    statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 20)"
                    if self.casinoTabledata?.gameTableStatusVo?.remainSecond != nil {
                        self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.remainSecond ?? 20
                    } else {
                        statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20)"
                        self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20
                    }
                    self.startTimer()
                } else {
                    statusLabel.text = "\(self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20)"
                    self.totalBetTime = self.casinoTabledata?.gameTableStatusVo?.betSecond ?? 20
                    self.startTimer()
                }
            case 2:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Opening".localizable
            case 4:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Settlement".localizable
                self.endTimer()
            case -1:
                self.statusLabel.textColor =  .statusColor
                statusLabel.text = "Settlement".localizable
                self.endTimer()
            default:
                statusLabel.text = ""
            }
        }
    }
}
*/
