//
//  RoadMaps.swift
//  BaccaratLiveStream
//
//  Created by Mohd Farmood on 28/6/24.
//

import Foundation
class RoadMaps {
     let mapObj = BaccaratRoadMaps()
    /*
    var previousColumn = -1
    var currentColumn = 0
    var currentRow  = 0
    var currentIndex  = 0
    var currentPlayer: String?
    var previousPlayer: String?
    var currentMaxRow: Int?
    var previousMaxRow: Int?
    var bigMapArr = [BigRoadMapData]()
    */
    func generateSingleEntryRoadMap(item: GameTableResultVo, mapData: MapPlayerDatas? = nil) -> MapPlayerDatas {
        mapObj.previousColumn = mapData?.previousColumn ?? -1
        mapObj.currentColumn = mapData?.currentColumn ?? 0
        mapObj.currentRow = mapData?.currentRow ?? 0
        mapObj.currentIndex = mapData?.currentIndex ?? 0
        mapObj.currentPlayer = mapData?.currentPlayer
        mapObj.previousPlayer = mapData?.previousPlayer
        mapObj.currentMaxRow = mapData?.currentMaxRow
        mapObj.previousMaxRow = mapData?.previousMaxRow
        mapObj.bigMapArr = mapData?.bigMapArr ?? [BigRoadMapData]()
        let (playerName, iconName, _) = Utils.getIconName(result: item.result ?? "")
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
           // currentColumn = obj.nextColumn ?? currentColumn
           // currentPlayer = playerName
            mapObj.currentColumn = obj.nextColumn ?? mapObj.currentColumn
            mapObj.currentPlayer = playerName
            if obj.nextRow != nil && obj.nextRow! < 5 {
               // self.currentRow = obj.nextRow! + 1
                mapObj.currentRow = obj.nextRow! + 1
            } else if obj.nextRow != nil && obj.nextRow! == 5 {
              //  self.currentRow = obj.nextRow! + 1
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
            mapObj.bigMapArr.append(objBB) // objBB
           // self.bigMapArr.append(objBB) // objBB
         //   self.currentIndex += 1
            mapObj.currentIndex += 1
        } else {
            if mapObj.bigMapArr.count == 0 {
                
                //  self.bigMapArr.insert(objBB, at: self.currentIndex)
            } else {
                if !((mapObj.bigMapArr.last?.name ?? "").contains("T")) {
                    mapObj.bigMapArr.last?.name = (mapObj.bigMapArr.last?.name ?? "") + "T"
                }
                mapObj.bigMapArr.last?.tieCount = (mapObj.bigMapArr.last?.tieCount  ?? 0) + 1
            }
        }
        return MapPlayerDatas(
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
    // MARK: - Check Previous Data Entry & Manage Height , Width
//    private func checkPrevDataData(checkEntry: Bool,
//                                   nextRow: Int,
//                                   nextColumn: Int) -> (checkEntry: Bool,
//                                                        nextRow: Int?,
//                                                        nextColumn: Int?) {
//        let clmValue = previousColumn
//        previousColumn = -1
//        for index in stride(from: clmValue - 1, through: 0, by: -1) {
//            let value = self.bigMapArr.filter({$0.row == 0 && $0.column == index})
//            if value.count > 0 {
//                return (checkEntry: false, nextRow: 0, nextColumn: index + 1)
//            }
//        }
//        return (checkEntry: false, nextRow: 0, nextColumn: clmValue)
//    }
}
