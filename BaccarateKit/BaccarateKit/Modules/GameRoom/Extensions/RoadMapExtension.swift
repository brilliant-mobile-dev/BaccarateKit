//
//  RoadMapExtensions.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
// swiftlint:disable all
import Foundation
import SpreadsheetView
extension GameRoomVC {
    func initiateSpreadSheet() {
        spreadsheetViewBigMap.dataSource = self
        spreadsheetViewBigMap.delegate = self
        spreadsheetViewBigMap.register(UINib(nibName: String(describing: SlotCell.self),
                                             bundle: nil),
                                       forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetViewBreadPlate.dataSource = self
        spreadsheetViewBreadPlate.delegate = self
        spreadsheetViewBreadPlate.register(UINib(nibName: String(describing: SlotCell.self),
                                                 bundle: nil),
                                           forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetViewBigEye.dataSource = self
        spreadsheetViewBigEye.delegate = self
        spreadsheetViewBigEye.register(UINib(nibName: String(describing: SlotCell.self),
                                             bundle: nil),
                                       forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetViewSmallEye.dataSource = self
        spreadsheetViewSmallEye.delegate = self
        spreadsheetViewSmallEye.register(UINib(nibName: String(describing: SlotCell.self),
                                               bundle: nil),
                                         forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetViewCockRoachEye.dataSource = self
        spreadsheetViewCockRoachEye.delegate = self
        spreadsheetViewCockRoachEye.register(UINib(nibName: String(describing: SlotCell.self),
                                                   bundle: nil),
                                             forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetViewBigMap.intercellSpacing = CGSize(width: 1, height: 1)
        spreadsheetViewBreadPlate.intercellSpacing = CGSize(width: 1, height: 1)
        spreadsheetViewBigEye.intercellSpacing = CGSize(width: 1, height: 1)
        spreadsheetViewSmallEye.intercellSpacing = CGSize(width: 1, height: 1)
        spreadsheetViewCockRoachEye.intercellSpacing = CGSize(width: 1, height: 1)
        self.spreadsheetViewBigMap.isUserInteractionEnabled = false
        self.spreadsheetViewBreadPlate.isUserInteractionEnabled = false
        self.spreadsheetViewBigEye.isUserInteractionEnabled = false
        self.spreadsheetViewSmallEye.isUserInteractionEnabled = false
        self.spreadsheetViewCockRoachEye.isUserInteractionEnabled = false
        spreadsheetViewBigMap.gridStyle =  .solid(width: 1, color: .gridLineColor)
        spreadsheetViewBreadPlate.gridStyle =  .solid(width: 1, color: .gridLineColor)
        spreadsheetViewBigEye.gridStyle =  .solid(width: 1, color: .gridLineColor)
        spreadsheetViewSmallEye.gridStyle =  .solid(width: 1, color: .gridLineColor)
        spreadsheetViewCockRoachEye.gridStyle =  .solid(width: 1, color: .gridLineColor)
    }
    func manageHeight() {
        self.roadMapHeight.constant = mapHeight + 1
        let widthOfContainer = Utils.screenWidth - safeAreaLead - safeAreaTrail - 1
        self.breadPlatMapWidth.constant = (widthOfContainer * 40)/100.0
        self.bigEyeHeight.constant = (mapHeight * 35)/100.0 // Height for BigEye, SmallEye, CoackRoach
        bigMapHeight.constant = mapHeight - self.bigEyeHeight.constant
        self.cellHeightBP = (roadMapHeight.constant)/6.0 - 1.2
        self.cellHeightBI = (bigMapHeight.constant)/6.0 - 1.2
        self.cellHeightBE = (bigEyeHeight.constant)/6.0 - 1.2
        self.widthOfMapContainer = widthOfContainer
        let bigMapWidth = widthOfContainer - self.breadPlatMapWidth.constant
        let bigEyeWidth = bigMapWidth/3
        initialCellColumnCountBP = Int(self.breadPlatMapWidth.constant/cellHeightBP) + 3
        initialCellColumnCountBI = Int(bigMapWidth/cellHeightBI) + 3
        initialCellColumnCountBE = Int(bigEyeWidth/cellHeightBE) + 3
    }
}
func findDuplicate(list: [String]) -> [String] {
    var duplicates = Set<String>()
    for element in list where list.firstIndex(of: element) != list.lastIndex(of: element) {
        // if list.firstIndex(of: element) != list.lastIndex(of: element) {
        duplicates.insert(element)
        //  }
    }
    return duplicates.sorted()
}
// MARK: - SpreadSheet Scroll When Sheet Full
extension GameRoomVC {
    func reloadAllSpreadSheet() {
        self.spreadsheetViewBigMap.reloadData()
        self.spreadsheetViewBigEye.reloadData()
        self.spreadsheetViewSmallEye.reloadData()
        self.spreadsheetViewBreadPlate.reloadData()
        self.spreadsheetViewCockRoachEye.reloadData()
    }
    func manageScroll(type: ScrollType) {
        self.setScrollBigRoadMap(type: type)
        self.setScrollBigEye(type: type)
        self.setScrollSmallEye(type: type)
        self.setScrollCockRoach(type: type)
        self.setScrollBreadPlate(type: type)
    }
    func setScrollBigRoadMap(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumn + 1)
        self.spreadsheetViewBigMap.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    func setScrollBigEye(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumnBE + 1)
        self.spreadsheetViewBigEye.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    func setScrollSmallEye(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumnSE + 1)
        self.spreadsheetViewSmallEye.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    func setScrollCockRoach(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumnCR + 1)
        self.spreadsheetViewCockRoachEye.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    func setScrollBreadPlate(type: ScrollType) {
        let indexPath = IndexPath(row: 0, column: mapObj.currentColumnBP + 1)
        self.spreadsheetViewBreadPlate.scrollToItem(at: indexPath, at: .right, animated: true)
    }
}
// MARK: - Clear Nodes From SpreadSheet (Reset RoadMap)
extension GameRoomVC {
    func clearBigRoadMap() {
        mapObj.currentIndex -= 1
        let obj = mapObj.bigMapArr[mapObj.currentIndex]
        mapObj.currentRow = obj.row ?? mapObj.currentRow
        mapObj.currentColumn = obj.column ?? mapObj.currentColumn
        if (obj.row ?? 0) == 5 {
            mapObj.currentRow = 6
            mapObj.currentColumn -= 1
        }
        mapObj.bigMapArr.remove(at: mapObj.currentIndex)
        //  spreadsheetView1.reloadData()
        if (mapObj.currentIndex - 1) > 0 {
            let node = mapObj.bigMapArr[mapObj.currentIndex - 1]
            mapObj.currentRow = node.nextnode?.row ?? mapObj.currentRow
            mapObj.currentColumn = node.nextnode?.column ?? mapObj.currentColumn
            mapObj.currentPlayer = node.nextnode?.player ?? mapObj.currentPlayer
            mapObj.currentIndex =  node.nextnode?.index ?? mapObj.currentIndex
            mapObj.previousColumn = node.nextnode?.previousColumn ?? mapObj.previousColumn
        }
    }
    func clearBigEyeRoad() {
        mapObj.currentIndexBE -= 1
        let obj = mapObj.bigEyeArr[mapObj.currentIndexBE]
        mapObj.currentRowBE = obj.row ?? mapObj.currentRowBE
        mapObj.currentColumnBE = obj.column ?? mapObj.currentColumnBE
        mapObj.bigEyeArr.remove(at: mapObj.currentIndexBE)
        if (mapObj.currentIndexBE - 1) > 0 {
            let node = mapObj.bigEyeArr[mapObj.currentIndexBE - 1]
            mapObj.currentRowBE = node.nextnode?.row ?? mapObj.currentRowBE
            mapObj.currentColumnBE = node.nextnode?.column ?? mapObj.currentColumnBE
            mapObj.currentPatternBE = node.nextnode?.player ?? mapObj.currentPatternBE
            mapObj.currentIndexBE =  node.nextnode?.index ?? mapObj.currentIndexBE
            // swiftlint:disable:next line_length
            mapObj.previousDoubleDragonStatusBE =  node.nextnode?.previousDoubleDragonStatus ?? mapObj.previousDoubleDragonStatusBE
            // swiftlint:disable:next line_length
            mapObj.previousSingleDragonStatusBE =  node.nextnode?.previousSingleDragonStatus ?? mapObj.previousSingleDragonStatusBE
            // swiftlint:disable:next line_length
            mapObj.previousColumnBE = node.nextnode?.previousColumn ?? mapObj.previousColumnBE
        }
    }
    func clearSmallEyeRoad() {
        mapObj.currentIndexSE -= 1
        let obj = mapObj.smallEyeArr[mapObj.currentIndexSE]
        mapObj.currentRowSE = obj.row ?? mapObj.currentRowSE
        mapObj.currentColumnSE = obj.column ?? mapObj.currentColumnSE
        mapObj.smallEyeArr.remove(at: mapObj.currentIndexSE)
        if (mapObj.currentIndexSE - 1) > 0 {
            let node = mapObj.smallEyeArr[mapObj.currentIndexSE - 1]
            mapObj.currentRowSE = node.nextnode?.row ?? mapObj.currentRowSE
            mapObj.currentColumnSE = node.nextnode?.column ?? mapObj.currentColumnSE
            mapObj.currentPatternSE = node.nextnode?.player ?? mapObj.currentPatternSE
            mapObj.currentIndexSE =  node.nextnode?.index ?? mapObj.currentIndexSE
            // swiftlint:disable:next line_length
            mapObj.previousDoubleDragonStatusSE =  node.nextnode?.previousDoubleDragonStatus ?? mapObj.previousDoubleDragonStatusSE
            // swiftlint:disable:next line_length
            mapObj.previousSingleDragonStatusSE =  node.nextnode?.previousSingleDragonStatus ?? mapObj.previousSingleDragonStatusSE
            mapObj.previousColumnSE = node.nextnode?.previousColumn ?? mapObj.previousColumnSE
        }
    }
    func clearCockRoachRoad() {
        mapObj.currentIndexCR -= 1
        let obj = mapObj.cockRoachEyeArr[mapObj.currentIndexCR]
        mapObj.currentRowCR = obj.row ?? mapObj.currentRowCR
        mapObj.currentColumnCR = obj.column ?? mapObj.currentColumnCR
        mapObj.cockRoachEyeArr.remove(at: mapObj.currentIndexCR)
        if (mapObj.currentIndexCR - 1) > 0 {
            let node = mapObj.cockRoachEyeArr[mapObj.currentIndexCR - 1]
            mapObj.currentRowCR = node.nextnode?.row ?? mapObj.currentRowCR
            mapObj.currentColumnCR = node.nextnode?.column ?? mapObj.currentColumnCR
            mapObj.currentPatternCR = node.nextnode?.player ?? mapObj.currentPatternCR
            mapObj.currentIndexCR =  node.nextnode?.index ?? mapObj.currentIndexCR
            // swiftlint:disable:next line_length
            mapObj.previousDoubleDragonStatusCR =  node.nextnode?.previousDoubleDragonStatus ?? mapObj.previousDoubleDragonStatusCR
            // swiftlint:disable:next line_length
            mapObj.previousSingleDragonStatusCR =  node.nextnode?.previousSingleDragonStatus ?? mapObj.previousSingleDragonStatusCR
            mapObj.previousColumnCR = node.nextnode?.previousColumn ?? mapObj.previousColumnCR
        }
    }
    func clearBreadPlateRoad() {
        mapObj.currentIndexBP -= 1
        let obj = mapObj.breadPlateArr[mapObj.currentIndexBP]
        mapObj.currentRowBP = obj.row ?? mapObj.currentRowBP
        mapObj.currentColumnBP = obj.column ?? mapObj.currentColumnBP
        mapObj.breadPlateArr.remove(at: mapObj.currentIndexBP)
    }
    // swiftlint:disable:next function_body_length
    func resetRoadMaps() {
        self.bankerPreditBigIcon.image = UIImage(named: "empty")
        self.playerPreditBigIcon.image = UIImage(named: "empty")
        self.bankerPreditSmalIcon.image = UIImage(named: "empty")
        self.playerPreditSmalIcon.image = UIImage(named: "empty")
        self.bankerPreditCRoachIcon.image = UIImage(named: "empty")
        self.playerPreditCRoachIcon.image = UIImage(named: "empty")
        self.mapObj.resetData()
        // reset for BigRoad
        tieOn = false
    }
}
// MARK: - Check Start Entry For Road Maps
extension GameRoomVC {
    func checkEntryForBigEye(node: BigRoadMapData) -> Bool {
        let objArrB2 = mapObj.bigMapArr.filter({$0.column == bigEyeStartColumn && $0.row == 1})
        let objArrC1 = mapObj.bigMapArr.filter({$0.column == c2 && $0.row == 0})
        if node.column ?? 0 == bigEyeStartColumn && node.row ?? 0 == 1 {
            return true
        } else if node.column ?? 0 == c2 && node.row ?? 0 == 0 {
            return true
        } else if node.column ?? 0 == bigEyeStartColumn && node.row ?? 0 > 0 && objArrB2.count > 0 {
            return true
        } else if node.column ?? 0 > bigEyeStartColumn  && objArrB2.count > 0 {
            return true
        } else if objArrB2.count == 0 && objArrC1.count > 0 {
            return true
        } else {
            return false
        }
    }
    func checkEntryForSmallEye(node: BigRoadMapData) -> Bool {
        let objArrC2 = mapObj.bigMapArr.filter({$0.column == c2 && $0.row == 1})
        let objArrD1 = mapObj.bigMapArr.filter({$0.column == d1 && $0.row == 0})
        if node.column ?? 0 == c2 && node.row ?? 0 == 1 {
            return true
        } else if node.column ?? 0 == d1 && node.row ?? 0 == 0 {
            return true
        } else if node.column ?? 0 == c2 && node.row ?? 0 > 0 && objArrC2.count > 0 {
            return true
        } else if node.column ?? 0 > c2  && objArrC2.count > 0 {
            return true
        } else if objArrC2.count == 0 && objArrD1.count > 0 {
            return true
        } else {
            return false
        }
    }
    func checkEntryForCockRoach(node: BigRoadMapData) -> Bool {
        let objArrE2 = mapObj.bigMapArr.filter({$0.column == d1 && $0.row == 1})
        let objArrF1 = mapObj.bigMapArr.filter({$0.column == e2 && $0.row == 0})
        if node.column ?? 0 == d1 && node.row ?? 0 == 1 {
            return true
        } else if node.column ?? 0 == e2 && node.row ?? 0 == 0 {
            return true
        } else if node.column ?? 0 == d1 && node.row ?? 0 > 0 && objArrE2.count > 0 {
            return true
        } else if node.column ?? 0 > d1 && objArrE2.count > 0 {
            return true
        } else if objArrE2.count == 0 && objArrF1.count > 0 {
            return true
        } else {
            return false
        }
    }
}
// MARK: - Call For RoadMaps
extension GameRoomVC {
    func callBigEyeRoadMap(node: BigRoadMapData, isForPrediction: Bool) {
        if checkEntryForBigEye(node: node) == true {
            let obj = mapObj.drawBigEyeRoad(row: mapObj.currentRowBE,
                                            column: mapObj.currentColumnBE,
                                            currentPattern: mapObj.currentPatternBE ?? "",
                                          node: node,
                                          isForPrediction: isForPrediction)
            let objBB = BigRoadMapData()
            objBB.player =  obj.pattern
            objBB.name =   obj.pattern
            objBB.row =  obj.nextRow
            objBB.column =  obj.nextColumn
            objBB.index =  mapObj.currentIndexBE
            mapObj.currentColumnBE = obj.nextColumn ?? mapObj.currentColumnBE
            mapObj.currentPatternBE = obj.pattern
            if obj.nextRow != nil && obj.nextRow! < 5 {
                mapObj.currentRowBE = obj.nextRow! + 1
            } else if obj.nextRow != nil && obj.nextRow! == 5 {
                mapObj.currentRowBE = obj.nextRow! + 1
            } else {
            }
            // ..... create next node
            let objNextNode = NextNode()
            objNextNode.row = mapObj.currentRowBE
            objNextNode.column = mapObj.currentColumnBE
            objNextNode.index = mapObj.currentIndexBE + 1
            objNextNode.player = mapObj.currentPatternBE
            objNextNode.previousSingleDragonStatus = mapObj.previousSingleDragonStatusBE
            objNextNode.previousDoubleDragonStatus = mapObj.previousDoubleDragonStatusBE
            objNextNode.previousColumn = mapObj.previousColumnBE
            objBB.nextnode = objNextNode
            // ...........
            mapObj.bigEyeArr.append(objBB)
            mapObj.currentIndexBE += 1
        }
    }
    func callSmallEyeRoadMap(node: BigRoadMapData, isForPrediction: Bool) {
        if checkEntryForSmallEye(node: node) == true {
            let obj = mapObj.drawSmallEyeRoad(row: mapObj.currentRowSE,
                                              column: mapObj.currentColumnSE,
                                              currentPattern: mapObj.currentPatternSE ?? "",
                                            node: node,
                                            isForPrediction: isForPrediction)
            let objBB = BigRoadMapData()
            objBB.player =  obj.pattern
            objBB.name =   obj.pattern
            objBB.row =  obj.nextRow
            objBB.column =  obj.nextColumn
            objBB.index =  mapObj.currentIndexSE
            mapObj.currentColumnSE = obj.nextColumn ?? mapObj.currentColumnSE
            mapObj.currentPatternSE = obj.pattern
            if obj.nextRow != nil && obj.nextRow! < 5 {
                mapObj.currentRowSE = obj.nextRow! + 1
            } else if obj.nextRow != nil && obj.nextRow! == 5 {
                mapObj.currentRowSE = obj.nextRow! + 1
            } else {
            }
            // ..... create next node
            let objNextNode = NextNode()
            objNextNode.row = mapObj.currentRowSE
            objNextNode.column = mapObj.currentColumnSE
            objNextNode.index = mapObj.currentIndexSE + 1
            objNextNode.player = mapObj.currentPatternSE
            objNextNode.previousSingleDragonStatus = mapObj.previousSingleDragonStatusSE
            objNextNode.previousDoubleDragonStatus = mapObj.previousDoubleDragonStatusSE
            objNextNode.previousColumn = mapObj.previousColumnSE
            objBB.nextnode = objNextNode
            // ...........
            mapObj.smallEyeArr.append(objBB)
            mapObj.currentIndexSE += 1
        }
    }
    func callCockRoachRoadMap(node: BigRoadMapData, isForPrediction: Bool) {
        if checkEntryForCockRoach(node: node) == true {
            let obj = mapObj.drawCockRoachRoad(row: mapObj.currentRowCR,
                                               column: mapObj.currentColumnCR,
                                               currentPattern: mapObj.currentPatternCR ?? "",
                                             node: node,
                                             isForPrediction: isForPrediction)
            let objBB = BigRoadMapData()
            objBB.player =  obj.pattern
            objBB.name =   obj.pattern
            objBB.row =  obj.nextRow
            objBB.column =  obj.nextColumn
            objBB.index =  mapObj.currentIndexCR
            mapObj.currentColumnCR = obj.nextColumn ?? mapObj.currentColumnCR
            mapObj.currentPatternCR = obj.pattern
            if obj.nextRow != nil && obj.nextRow! < 5 {
                mapObj.currentRowCR = obj.nextRow! + 1
            } else if obj.nextRow != nil && obj.nextRow! == 5 {
                mapObj.currentRowCR = obj.nextRow! + 1
            } else {
            }
            // ..... create next node
            let objNextNode = NextNode()
            objNextNode.row = mapObj.currentRowCR
            objNextNode.column = mapObj.currentColumnCR
            objNextNode.index = mapObj.currentIndexCR + 1
            objNextNode.player = mapObj.currentPatternCR
            objNextNode.previousSingleDragonStatus = mapObj.previousSingleDragonStatusCR
            objNextNode.previousDoubleDragonStatus = mapObj.previousDoubleDragonStatusCR
            objNextNode.previousColumn = mapObj.previousColumnCR
            objBB.nextnode = objNextNode
            // ...........
            mapObj.cockRoachEyeArr.append(objBB)
            mapObj.currentIndexCR += 1
        }
    }
    func callBreadPlatMap(player: String, breadPlateIcon: String, isForPrediction: Bool, item: GameTableResultVo) {
        let obj = mapObj.drawBreadPlat(row: mapObj.currentRowBP,
                                       column: mapObj.currentColumnBP,
                                     player: player,
                                     currentPlayer: mapObj.currentPlayer ?? "")
        let objBB = BigRoadMapData()
        objBB.player =  player
        objBB.name = breadPlateIcon
        objBB.row =  obj.nextRow
        objBB.column =  obj.nextColumn
        objBB.index =  mapObj.currentIndexBP
        objBB.roundNum = item.roundNo
        mapObj.breadPlateArr.append(objBB)
        if isForPrediction == false {
            mapObj.currentRowBP = obj.nextRow! + 1
            mapObj.currentColumnBP = obj.nextColumn!
            mapObj.currentIndexBP += 1
        }
    }
}
