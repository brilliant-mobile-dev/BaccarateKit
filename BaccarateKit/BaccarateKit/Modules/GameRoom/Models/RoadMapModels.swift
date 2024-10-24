//
//  RoadMapModels.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//

import Foundation
class BigRoadMapData {
    var player: String?
    var name: String?
    var row: Int?
    var column: Int?
    var index: Int?
    var nextnode: NextNode?
    var tieCount = 0
    var isAnimate = false
    var roundNum: String?
    var columnEntry: Int?
}
class NextNode {
    var row: Int?
    var column: Int?
    var player: String?
    var index: Int?
    var previousDoubleDragonStatus = false
    var previousSingleDragonStatus = false
    var previousColumn = -1
}

enum ScrollType {
    case delete
    case add
}
class PredictionNode {
    var breadPlateNode: BigRoadMapData?
    var bigRoadNode: BigRoadMapData?
    var bigEyeNode: BigRoadMapData?
    var smallEyeNode: BigRoadMapData?
    var cockRoachNode: BigRoadMapData?
    var breadPlateNodeP: BigRoadMapData?
    var bigRoadNodeP: BigRoadMapData?
    var bigEyeNodeP: BigRoadMapData?
    var smallEyeNodeP: BigRoadMapData?
    var cockRoachNodeP: BigRoadMapData?
}
