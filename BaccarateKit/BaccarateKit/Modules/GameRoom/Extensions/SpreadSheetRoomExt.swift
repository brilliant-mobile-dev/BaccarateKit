//
//  SpreadSheetRoomExt.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 4/10/23.
//
// swiftlint:disable superfluous_disable_command cyclomatic_complexity type_body_length file_length type_name
import Foundation
import SpreadsheetView
import QuartzCore
extension GameRoomVC: SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if spreadsheetView == self.spreadsheetViewBreadPlate {
            return self.cellHeightBP
        } else if spreadsheetView == self.spreadsheetViewBigMap {
            return self.cellHeightBI
        } else {
            return self.cellHeightBE
        }
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if spreadsheetView == self.spreadsheetViewBreadPlate {
            return self.cellHeightBP
        } else if spreadsheetView == self.spreadsheetViewBigMap {
            return self.cellHeightBI
        } else {
            return self.cellHeightBE
        }
    }
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return (getTotalColumn(spreadsheetView: spreadsheetView) + 12)
    }
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 6
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SlotCell.self),
                                                          for: indexPath) as? SlotCell {
            cell.tag = indexPath.column
            cell.titleLbl.text = ""
            switch spreadsheetView {
            case self.spreadsheetViewBigMap:
                cell.setData(dataArr: mapObj.bigMapArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
            case self.spreadsheetViewBreadPlate:
                cell.setData(dataArr: mapObj.breadPlateArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
            case self.spreadsheetViewBigEye:
                cell.setData(dataArr: mapObj.bigEyeArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
            case self.spreadsheetViewSmallEye:
                cell.setData(dataArr: mapObj.smallEyeArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
            case self.spreadsheetViewCockRoachEye:
                cell.setData(dataArr: mapObj.cockRoachEyeArr, indexPath: indexPath, spreadsheetView: spreadsheetView)
            default:
                cell.imgIcon.image = UIImage(named: "empty")
            }
            return cell
        }
        return SlotCell()
    }
    // swiftlint:disable:next function_body_length
    func setLastPredictDataForBanker() {
        let playerName = "B"
        let iconName = "bankers"
        let breadPlateIcon = "bankerW"
        // .. for BigRoadmap
        let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow,
                                        column: mapObj.currentColumn,
                                      player: playerName,
                                        currentPlayer: mapObj.currentPlayer ?? "",
                                      isForPrediction: true)
        let objBB = BigRoadMapData()
        objBB.player =  playerName
        objBB.name = iconName
        objBB.row =  obj.nextRow
        objBB.column =  obj.nextColumn
        objBB.index =   mapObj.currentIndex
        objBB.isAnimate = true
        mapObj.bigMapArr.append(objBB)
        predictNode.bigRoadNode = objBB // added next predited node for BigMap
        // ... For BreadPlat Map
        let objBPC = mapObj.drawBreadPlat(row:  mapObj.currentRowBP,
                                          column:  mapObj.currentColumnBP,
                                        player: playerName,
                                        currentPlayer: mapObj.currentPlayer ?? "")
        let objBP = BigRoadMapData()
        objBP.player =  playerName
        objBP.name = breadPlateIcon
        objBP.row =  objBPC.nextRow
        objBP.column =  objBPC.nextColumn
        objBP.index =   mapObj.currentIndexBP
        objBP.isAnimate = true
        mapObj.breadPlateArr.append(objBP)
        predictNode.breadPlateNode = objBP // added next predited node for BreadPlate Map
        // .. for BigRoad Map
        if checkEntryForBigEye(node: objBB) == true {
            let objBEC = mapObj.drawBigEyeRoad(row:  mapObj.currentRowBE,
                                               column:  mapObj.currentColumnBE,
                                               currentPattern:  mapObj.currentPatternBE ?? "",
                                             node: objBB, isForPrediction: true)
            let objBE = BigRoadMapData()
            objBE.player =  objBEC.pattern
            objBE.name =   objBEC.pattern
            objBE.row =  objBEC.nextRow
            objBE.column =  objBEC.nextColumn
            objBE.index =   mapObj.currentIndexBE
            objBE.isAnimate = true
            mapObj.bigEyeArr.append(objBE)
            predictNode.bigEyeNode = objBE  // added next predited node for BigEye Map
        }
        // ..For Small Eye Road Map
        if checkEntryForSmallEye(node: objBB) == true {
            let obj = mapObj.drawSmallEyeRoad(row:  mapObj.currentRowSE,
                                              column:  mapObj.currentColumnSE,
                                              currentPattern:  mapObj.currentPatternSE ?? "",
                                            node: objBB, isForPrediction: true)
            let objSE = BigRoadMapData()
            objSE.player =  obj.pattern
            objSE.name =   obj.pattern
            objSE.row =  obj.nextRow
            objSE.column =  obj.nextColumn
            objSE.index =   mapObj.currentIndexSE
            objSE.isAnimate = true
            mapObj.smallEyeArr.append(objSE)
            predictNode.smallEyeNode = objSE  // added next predited node for SmallEye Map
        }
        if checkEntryForCockRoach(node: objBB) == true {
            let obj = mapObj.drawCockRoachRoad(row:  mapObj.currentRowCR,
                                               column:  mapObj.currentColumnCR,
                                               currentPattern:  mapObj.currentPatternCR ?? "",
                                             node: objBB, isForPrediction: true)
            let objCR = BigRoadMapData()
            objCR.player =  obj.pattern
            objCR.name =   obj.pattern
            objCR.row =  obj.nextRow
            objCR.column =  obj.nextColumn
            objCR.index =   mapObj.currentIndexCR
            objCR.isAnimate = true
            mapObj.cockRoachEyeArr.append(objCR)
            predictNode.cockRoachNode = objCR  // added next predited node for CockRoach Map
        }
        self.removeAllPredictValueFromMap()
        self.setPredictImage()
    }
    // swiftlint:disable:next function_body_length
    func setLastPredictDataForPlayer() {
        let playerName = "P"
        let iconName = "players"
        let breadPlateIcon = "playerW"
        // .. for BigRoadmap
        let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow,
                                        column: mapObj.currentColumn,
                                      player: playerName,
                                        currentPlayer: mapObj.currentPlayer ?? "",
                                      isForPrediction: true)
        let objBB = BigRoadMapData()
        objBB.player =  playerName
        objBB.name = iconName
        objBB.row =  obj.nextRow
        objBB.column =  obj.nextColumn
        objBB.index =  mapObj.currentIndex
        objBB.isAnimate = true
        mapObj.bigMapArr.append(objBB)
        predictNode.bigRoadNodeP = objBB // added next predited node for BigMap
        // ... For BreadPlat Map
        let objBPC = mapObj.drawBreadPlat(row: mapObj.currentRowBP,
                                          column: mapObj.currentColumnBP,
                                        player: playerName,
                                        currentPlayer: mapObj.currentPlayer ?? "")
        let objBP = BigRoadMapData()
        objBP.player =  playerName
        objBP.name = breadPlateIcon
        objBP.row =  objBPC.nextRow
        objBP.column =  objBPC.nextColumn
        objBP.index =  mapObj.currentIndexBP
        objBP.isAnimate = true
        mapObj.breadPlateArr.append(objBP)
        predictNode.breadPlateNodeP = objBP // added next predited node for BreadPlate Map
        // .. for BigRoad Map
        if checkEntryForBigEye(node: objBB) == true {
            let objBEC = mapObj.drawBigEyeRoad(row: mapObj.currentRowBE,
                                               column: mapObj.currentColumnBE,
                                               currentPattern: mapObj.currentPatternBE ?? "",
                                             node: objBB, isForPrediction: true)
            let objBE = BigRoadMapData()
            objBE.player =  objBEC.pattern
            objBE.name =   objBEC.pattern
            objBE.row =  objBEC.nextRow
            objBE.column =  objBEC.nextColumn
            objBE.index =  mapObj.currentIndexBE
            objBE.isAnimate = true
            mapObj.bigEyeArr.append(objBE)
            predictNode.bigEyeNodeP = objBE  // added next predited node for BigEye Map
        }
        // ..For Small Eye Road Map
        if checkEntryForSmallEye(node: objBB) == true {
            let obj = mapObj.drawSmallEyeRoad(row: mapObj.currentRowSE,
                                              column: mapObj.currentColumnSE,
                                              currentPattern: mapObj.currentPatternSE ?? "",
                                            node: objBB,
                                            isForPrediction: true)
            let objSE = BigRoadMapData()
            objSE.player =  obj.pattern
            objSE.name =   obj.pattern
            objSE.row =  obj.nextRow
            objSE.column =  obj.nextColumn
            objSE.index =  mapObj.currentIndexSE
            objSE.isAnimate = true
            mapObj.smallEyeArr.append(objSE)
            predictNode.smallEyeNodeP = objSE  // added next predited node for SmallEye Map
        }
        if checkEntryForCockRoach(node: objBB) == true {
            let obj = mapObj.drawCockRoachRoad(row: mapObj.currentRowCR,
                                               column: mapObj.currentColumnCR,
                                               currentPattern: mapObj.currentPatternCR ?? "",
                                             node: objBB,
                                             isForPrediction: true)
            let objCR = BigRoadMapData()
            objCR.player =  obj.pattern
            objCR.name =   obj.pattern
            objCR.row =  obj.nextRow
            objCR.column =  obj.nextColumn
            objCR.index =  mapObj.currentIndexCR
            objCR.isAnimate = true
            mapObj.cockRoachEyeArr.append(objCR)
            predictNode.cockRoachNodeP = objCR  // added next predited node for CockRoach Map
        }
        self.removeAllPredictValueFromMap()
        //  self.setPredicImage()
    }
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func setRoomMapData(data: [GameTableResultVo]) {
        self.resetRoadMaps()
        for item in data {
            let (playerName, iconName, breadPlateIcon) = Utils.getIconName(result: item.result ?? "")
            if !playerName.isEmpty {
                if !playerName.isEmpty && playerName != "T" {
                    let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow,
                                                    column: mapObj.currentColumn,
                                                  player: playerName,
                                                    currentPlayer: mapObj.currentPlayer ?? "",
                                                  isForPrediction: false)
                    let objBB = BigRoadMapData()
                    objBB.player =  playerName
                    objBB.name = iconName
                    objBB.row =  obj.nextRow
                    objBB.column =  obj.nextColumn
                    objBB.index =  mapObj.currentIndex
                    // ...
                    mapObj.currentColumn = obj.nextColumn ?? mapObj.currentColumn
                    mapObj.currentPlayer = playerName
                    if obj.nextRow != nil && obj.nextRow! < 5 {
                        mapObj.currentRow = obj.nextRow! + 1
                    } else if obj.nextRow != nil && obj.nextRow! == 5 {
                        mapObj.currentRow = obj.nextRow! + 1
                    } else {
                    }
                    // ..... create next node
                    let objNextNode = NextNode()
                    objNextNode.row = mapObj.currentRow
                    objNextNode.column = mapObj.currentColumn
                    objNextNode.index = mapObj.currentIndex + 1
                    objNextNode.player = mapObj.currentPlayer
                    objNextNode.previousColumn = mapObj.previousColumn
                    objBB.nextnode = objNextNode
                    // ...........
                    mapObj.bigMapArr.append(objBB)
                    mapObj.currentIndex += 1
                    // ...
                    var playerName = ""
                    if playerName == "P" {
                        playerName = "player"
                    } else if playerName == "B" {
                        playerName = "banker"
                    } else if playerName == "T" {
                        playerName = "tie"
                    }
                    self.callBreadPlatMap(player: playerName, breadPlateIcon: breadPlateIcon, isForPrediction: false, item: item)
                    self.callBigEyeRoadMap(node: objBB, isForPrediction: false)
                    self.callSmallEyeRoadMap(node: objBB, isForPrediction: false)
                    self.callCockRoachRoadMap(node: objBB, isForPrediction: false)
                    self.tieOn = false
                } else {
                    if mapObj.bigMapArr.count == 0 {
                        self.callBreadPlatMap(player: playerName,
                                              breadPlateIcon: breadPlateIcon,
                                              isForPrediction: false, item: item)
                    } else {
                        if !((mapObj.bigMapArr.last?.name ?? "").contains("T")) {
                            mapObj.bigMapArr.last?.name = (mapObj.bigMapArr.last?.name ?? "") + "T"
                        }
                        mapObj.bigMapArr.last?.tieCount = (mapObj.bigMapArr.last?.tieCount  ?? 0) + 1
                        self.spreadsheetViewBigMap.reloadData()
                        let objBB = BigRoadMapData()
                        objBB.player =  playerName
                        objBB.name = iconName
                        objBB.index =  mapObj.currentIndex
                        // ...
                        self.callBreadPlatMap(player: playerName,
                                              breadPlateIcon: breadPlateIcon,
                                              isForPrediction: false, item: item)
                    }
                }
            }
        }
        if mapObj.breadPlateArr.count > 0 {
            self.reloadAllSpreadSheet()
            self.manageScroll(type: .add)
            self.setLastPredictDataForBanker()
            self.setLastPredictDataForPlayer()
        }
    }
    func removeAllPredictValueFromMap() {
        if let index = mapObj.bigMapArr.firstIndex(where: {$0.isAnimate == true}) {
            mapObj.bigMapArr.remove(at: index)
        }
        if let index = mapObj.breadPlateArr.firstIndex(where: {$0.isAnimate == true}) {
            mapObj.breadPlateArr.remove(at: index)
        }
        if let index = mapObj.bigEyeArr.firstIndex(where: {$0.isAnimate == true}) {
            mapObj.bigEyeArr.remove(at: index)
        }
        if let index = mapObj.smallEyeArr.firstIndex(where: {$0.isAnimate == true}) {
            mapObj.smallEyeArr.remove(at: index)
            
        }
        if let index = mapObj.cockRoachEyeArr.firstIndex(where: {$0.isAnimate == true}) {
            mapObj.cockRoachEyeArr.remove(at: index)
        }
    }
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func setSingleEntryData(item: GameTableResultVo) {
        if !mapObj.breadPlateArr.contains(where: { $0.roundNum == item.roundNo }) {
        let (playerName, iconName, breadPlateIcon) = Utils.getIconName(result: item.result ?? "")
        if !playerName.isEmpty {
            if !playerName.isEmpty && playerName != "T" {
                let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow,
                                                column: mapObj.currentColumn,
                                              player: playerName,
                                                currentPlayer: mapObj.currentPlayer ?? "",
                                              isForPrediction: false)
                let objBB = BigRoadMapData()
                objBB.player =  playerName
                objBB.name = iconName
                objBB.row =  obj.nextRow
                objBB.column =  obj.nextColumn
                objBB.index =  mapObj.currentIndex
                objBB.roundNum = item.roundNo
                // ...
                mapObj.currentColumn = obj.nextColumn ?? mapObj.currentColumn
                mapObj.currentPlayer = playerName
                if obj.nextRow != nil && obj.nextRow! < 5 {
                    mapObj.currentRow = obj.nextRow! + 1
                } else if obj.nextRow != nil && obj.nextRow! == 5 {
                    mapObj.currentRow = obj.nextRow! + 1
                } else {
                }
                
                // ..... create next node
                let objNextNode = NextNode()
                objNextNode.row = mapObj.currentRow
                objNextNode.column = mapObj.currentColumn
                objNextNode.index = mapObj.currentIndex + 1
                objNextNode.player = mapObj.currentPlayer
                objNextNode.previousColumn = mapObj.previousColumn
                objBB.nextnode = objNextNode
                // ...........
                mapObj.bigMapArr.append(objBB)
                mapObj.currentIndex += 1
                // ...
                var playerName = ""
                if playerName == "P" {
                    playerName = "player"
                } else if playerName == "B" {
                    playerName = "banker"
                } else if playerName == "T" {
                    playerName = "tie"
                }
                self.callBreadPlatMap(player: playerName, breadPlateIcon: breadPlateIcon, isForPrediction: false, item: item)
                self.callBigEyeRoadMap(node: objBB, isForPrediction: false)
                self.callSmallEyeRoadMap(node: objBB, isForPrediction: false)
                self.callCockRoachRoadMap(node: objBB, isForPrediction: false)
                self.tieOn = false
            } else {
                if mapObj.bigMapArr.count == 0 {
                    //  self.bigMapArr.insert(objBB, at: self.currentIndex)
                    self.callBreadPlatMap(player: playerName, breadPlateIcon: breadPlateIcon, isForPrediction: false, item: item)
                } else {
                    if !((mapObj.bigMapArr.last?.name ?? "").contains("T")) {
                        mapObj.bigMapArr.last?.name = (mapObj.bigMapArr.last?.name ?? "") + "T"
                    }
                    mapObj.bigMapArr.last?.tieCount = (mapObj.bigMapArr.last?.tieCount  ?? 0) + 1
                    self.spreadsheetViewBigMap.reloadData()
                    /*
                    let obj = mapObj.drawBigRoadMap(row: mapObj.currentRow,
                                                    column: mapObj.currentColumn,
                                                  player: playerName,
                                                    currentPlayer: mapObj.currentPlayer ?? "",
                                                  isForPrediction: false)
                    let objBB = BigRoadMapData()
                    objBB.player =  playerName
                    objBB.name = iconName
                    objBB.row =  obj.nextRow
                    objBB.column =  obj.nextColumn
                    objBB.index =  mapObj.currentIndex
                    */
                    // ..
                    self.callBreadPlatMap(player: playerName, breadPlateIcon: breadPlateIcon, isForPrediction: false, item: item)
                }
            }
        }
        if mapObj.breadPlateArr.count > 0 {
            self.reloadAllSpreadSheet()
            self.manageScroll(type: .add)
            self.setLastPredictDataForBanker()
            self.setLastPredictDataForPlayer()
        }
    }
    }
    func getTotalColumn(spreadsheetView: SpreadsheetView) -> Int {
        switch spreadsheetView {
        case self.spreadsheetViewBigMap:
            // swiftlint:disable:next line_length
            return (mapObj.currentColumn < self.initialCellColumnCountBI) ? self.initialCellColumnCountBI : (mapObj.bigMapArr.count + 10)
        case self.spreadsheetViewBreadPlate:
            // swiftlint:disable:next line_length
            return (mapObj.currentColumnBP < self.initialCellColumnCountBP) ? self.initialCellColumnCountBP : (mapObj.breadPlateArr.count + 10)
        case self.spreadsheetViewBigEye:
            // swiftlint:disable:next line_length
            return (mapObj.currentColumnBE < self.initialCellColumnCountBE) ? self.initialCellColumnCountBE : (mapObj.bigEyeArr.count + 10)
        case self.spreadsheetViewSmallEye:
            // swiftlint:disable:next line_length
            return (mapObj.currentColumnSE < self.initialCellColumnCountBE) ? self.initialCellColumnCountBE: (mapObj.smallEyeArr.count + 10)
        case self.spreadsheetViewCockRoachEye:
            // swiftlint:disable:next line_length
            return (mapObj.currentColumnCR < self.initialCellColumnCountBE) ? self.initialCellColumnCountBE : (mapObj.cockRoachEyeArr.count + 10)
        default:
            return 60
        }
    }
}
extension CALayer {
    @IBInspectable var borderUIColor: UIColor? {
        get {
            guard let borderColor = borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}
