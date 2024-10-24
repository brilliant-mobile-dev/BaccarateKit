//
//  SwitchRoomCVCell.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 20/09/23.
//

import UIKit
import SpreadsheetView

class SwitchRoomCVCell: UICollectionViewCell {
    let mapObj = BaccaratRoadMaps()
    var countdownTimer: Timer!
    var totalBetTime = 20
    @IBOutlet weak var statusLabel: RoomListLabel!
    @IBOutlet weak var spreadSheet: SpreadsheetView!
    @IBOutlet weak var tableName: RoomListLabel!
    // Variable for SpreadSheet
    var cellHeight = (switchCellHeight - 30)/6 - 1.2
    var tieOn = false
    var casinoTabledata: CasinoTableData? {
        didSet {
            if let data = casinoTabledata {
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initiateSpreadSheet()
    }
    func resetMapData() {
         // ctieOn = false
        mapObj.previousColumn = -1
        mapObj.currentColumn = 0
        mapObj.currentRow  = 0
        mapObj.currentIndex  = 0
        mapObj.currentPlayer = nil
        mapObj.previousPlayer = nil
        mapObj.currentMaxRow = nil
        mapObj.previousMaxRow = nil
        mapObj.bigMapArr.removeAll()
        self.mapObj.resetData()
        self.spreadSheet.reloadData()
    }
    func initiateSpreadSheet() {
        spreadSheet.dataSource = self
        spreadSheet.delegate = self
        spreadSheet.register(UINib(nibName: String(describing: SlotCell.self),
                                   bundle: nil),
                             forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadSheet.intercellSpacing = CGSize(width: 1, height: 1)
        spreadSheet.isUserInteractionEnabled = false
        spreadSheet.gridStyle = .solid(width: 1, color: .gridLineColor)
    }
    func updateView(data: CasinoTableData) -> MapPlayerDatas {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
        self.drawRoadmapForCell(data: data)
        self.statusLabel.text = ""
        tableName.text = data.name
            self.setStatus()
        return MapPlayerDatas(   // Return Road MapData for next time when cell reload/scroll
           previousColumn: mapObj.previousColumn,
           currentColumn: mapObj.currentColumn,
           currentRow: mapObj.currentRow,
           currentIndex: mapObj.currentIndex,
           currentPlayer: mapObj.currentPlayer,
           previousPlayer: mapObj.previousPlayer,
           currentMaxRow: mapObj.currentMaxRow,
           previousMaxRow: mapObj.previousMaxRow,
           bigMapArr: mapObj.bigMapArr
       )
    }
    func drawRoadmapForCell(data: CasinoTableData) {
        if data.mapData == nil { // if Road Map not draw for this cell
            self.resetMapData()
        self.statusLabel.text = ""
        self.self.spreadSheet.isHidden = true
        let tableResultArr = data.gameTableResultVos ?? [GameTableResultVo]()
        if data.gameTableStatusVo?.status != 0 && (data.status ?? 0) != 0 {
            self.self.spreadSheet.isHidden = false
            for item in tableResultArr {
                let (playerName, iconName, _) = Utils.getIconName(result: item.result ?? "")
                if !playerName.isEmpty && playerName != "T" { // Handle Road Map non - Tie
                    let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow, column: mapObj.currentColumn, player: playerName, currentPlayer: mapObj.currentPlayer ?? "", isForPrediction: false)
                    let objBB = BigRoadMapData()
                    objBB.player =  playerName
                    objBB.name = iconName
                    objBB.row =  obj.nextRow
                    objBB.column =  obj.nextColumn
                    objBB.index =  mapObj.currentIndex
                    mapObj.currentColumn = obj.nextColumn ?? mapObj.currentColumn
                    mapObj.currentPlayer = playerName
                    if obj.nextRow != nil && obj.nextRow! < 5 {
                        mapObj.currentRow = obj.nextRow! + 1
                    } else if obj.nextRow != nil && obj.nextRow! == 5 {
                        mapObj.currentRow = obj.nextRow! + 1
                    } else {
                        
                    }
                    // create next node
                    let objNextNode = NextNode()
                    objNextNode.row = mapObj.currentRow
                    objNextNode.column = mapObj.currentColumn
                    objNextNode.index = mapObj.currentIndex + 1
                    objNextNode.player = mapObj.currentPlayer
                    objNextNode.previousColumn = mapObj.previousColumn
                    objBB.nextnode = objNextNode
                    mapObj.bigMapArr.append(objBB)
                    mapObj.currentIndex += 1
                    self.tieOn = false
                    self.spreadSheet.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.manageScrollReload(type: .add)
                    }
                    
                } else { // Handle Road Map for Tie
                    if mapObj.bigMapArr.count == 0 {
                    } else {
                        if !((mapObj.bigMapArr.last?.name ?? "").contains("T")) {
                            mapObj.bigMapArr.last?.name = (mapObj.bigMapArr.last?.name ?? "") + "T"
                            // Add "T" word in image name & name now become like playerBT, bakerPT and these image will show for only 1 Tie
                        }
                        mapObj.bigMapArr.last?.tieCount = (mapObj.bigMapArr.last?.tieCount  ?? 0) + 1
                        // Show Tie count number inside the circle like 2, 3.... etc
                        self.spreadSheet.reloadData()
                    }
                }
            }
        } else {
            self.spreadSheet.isHidden = false
            self.mapObj.resetData()
            self.spreadSheet.reloadData()
        }
    } else { // // if Road Map is already draw for this cell
            if data.gameTableStatusVo?.status != 0 && (data.status ?? 0) != 0 {
                mapObj.previousColumn =  data.mapData?.previousColumn ?? -1
                mapObj.currentColumn = data.mapData?.currentColumn ?? 0
                mapObj.currentRow  = data.mapData?.currentRow ?? 0
                mapObj.currentIndex  = data.mapData?.currentIndex ?? 0
                mapObj.currentPlayer = data.mapData?.currentPlayer
                mapObj.previousPlayer = data.mapData?.previousPlayer
                mapObj.currentMaxRow = data.mapData?.currentMaxRow
                mapObj.previousMaxRow = data.mapData?.previousMaxRow
                mapObj.bigMapArr = data.mapData?.bigMapArr ?? [BigRoadMapData]()
                self.spreadSheet.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                   self.manageScrollReload(type: .add)
                }
            } else {
                self.self.spreadSheet.isHidden = false
                self.mapObj.resetData()
                self.spreadSheet.reloadData()
            }
            
        }
    }
}
