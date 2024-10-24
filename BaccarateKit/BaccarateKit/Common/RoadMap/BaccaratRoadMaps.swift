//
//  BaccaratRoadMaps.swift
//  BaccaratLiveStream
//
//  Created by Mohd Farmood on 9/7/24.
// swiftlint:disable superfluous_disable_command type_body_length file_length cyclomatic_complexity function_body_length
import Foundation
import SpreadsheetView
class BaccaratRoadMaps {
    var bigMapArr = [BigRoadMapData]()
    var bigEyeArr = [BigRoadMapData]()
    var smallEyeArr = [BigRoadMapData]()
    var cockRoachEyeArr = [BigRoadMapData]()
    var breadPlateArr = [BigRoadMapData]()
    // Big Road map
    var previousColumn = -1
    var currentColumn = 0
    var currentRow  = 0
    var currentIndex  = 0
    var currentPlayer: String?
    var previousPlayer: String?
    var currentMaxRow: Int?
    var previousMaxRow: Int?
    var safeAreaLead = 0.0
    var safeAreaTrail = 0.0
    // ... Variable for BigEyeRoad Map
    var previousDoubleDragonStatusBE = false
    var previousSingleDragonStatusBE = false
    var previousColumnBE = -1
    var currentColumnBE = 0
    var currentRowBE  = 0
    var currentIndexBE  = 0
    var currentPatternBE: String?
    // ... Variable for SmallEyeRoad Map
    var previousDoubleDragonStatusSE = false
    var previousSingleDragonStatusSE = false
    var previousColumnSE = -1
    var currentColumnSE = 0
    var currentRowSE  = 0
    var currentIndexSE  = 0
    var currentPatternSE: String?
    // ... Variable for CockRoach Road Map
    var previousDoubleDragonStatusCR = false
    var previousSingleDragonStatusCR = false
    var previousColumnCR = -1
    var currentColumnCR = 0
    var currentRowCR  = 0
    var currentIndexCR  = 0
    var currentPatternCR: String?
    // .. Varibale for BreadPlate
    var currentColumnBP = 0
    var currentRowBP  = 0
    var currentIndexBP  = 0
    // MARK: - Draw Big Road Map
    // MARK: - Draw Big Road Map
    func resetData() {
        self.bigMapArr = [BigRoadMapData]()
        self.bigEyeArr = [BigRoadMapData]()
        self.smallEyeArr = [BigRoadMapData]()
        self.cockRoachEyeArr = [BigRoadMapData]()
        self.breadPlateArr = [BigRoadMapData]()
        // Big Road map
        self.previousColumn = -1
        self.currentColumn = 0
        self.currentRow  = 0
        self.currentIndex  = 0
        self.currentPlayer = nil
        self.previousPlayer = nil
        self.currentMaxRow = nil
        self.previousMaxRow = nil
        self.safeAreaLead = 0.0
        self.safeAreaTrail = 0.0
        // ... Variable for BigEyeRoad Map
        self.previousDoubleDragonStatusBE = false
        self.previousSingleDragonStatusBE = false
        self.previousColumnBE = -1
        self.currentColumnBE = 0
        self.currentRowBE  = 0
        self.currentIndexBE  = 0
        self.currentPatternBE = nil
        // ... Variable for SmallEyeRoad Map
        self.previousDoubleDragonStatusSE = false
        self.previousSingleDragonStatusSE = false
        self.previousColumnSE = -1
        self.currentColumnSE = 0
        self.currentRowSE  = 0
        self.currentIndexSE  = 0
        self.currentPatternSE = nil
        // ... Variable for CockRoach Road Map
        self.previousDoubleDragonStatusCR = false
        self.previousSingleDragonStatusCR = false
        self.previousColumnCR = -1
        self.currentColumnCR = 0
        self.currentRowCR  = 0
        self.currentIndexCR  = 0
        self.currentPatternCR = nil
        // .. Varibale for BreadPlate
        self.currentColumnBP = 0
        self.currentRowBP  = 0
        self.currentIndexBP  = 0
    }
    // swiftlint:disable:next line_length cyclomatic_complexity large_tuple function_body_length
    func drawBigRoadMap(row: Int, column: Int, player: String, currentPlayer: String, isForPrediction: Bool) ->(checkEntry: Bool, nextRow: Int?, nextColumn: Int?) {
        let valueArr = self.bigMapArr.filter({$0.row == row && $0.column == column})
        if row < 6 {
            if currentPlayer == "T" {  // If current Tapped is Tie
                for index in stride(from: currentIndex - 1, through: 0, by: -1) {
                    // Travese from current index to till first found Row = 0
                    let obj = self.bigMapArr[index]
                    if obj.player != nil && obj.player != "T" && obj.player != player {
                        if previousColumn != -1 {
                            let clmValue = previousColumn
                            return (self.checkPrevDataData(checkEntry: false, nextRow: 0, nextColumn: clmValue, isForPrediction: isForPrediction))
                        }
                        return (checkEntry: false, nextRow: 0, nextColumn: column + 1)
                    }
                    let valueRow0 = self.bigMapArr.filter({$0.row == 0})
                    if valueRow0.count > 0 {
                        break
                    }
                }
            }
            if valueArr.count > 0 {
                if currentPlayer != player && currentPlayer != "T"{
                    if previousColumn != -1 {
                        let clmValue = previousColumn
                        return (self.checkPrevDataData(checkEntry: false, nextRow: 0, nextColumn: clmValue, isForPrediction: isForPrediction))
                    }
                    return (checkEntry: false, nextRow: 0, nextColumn: column + 1)
                } else {
                    if (previousColumn == -1 && (row - 1) != 0) && isForPrediction == false {
                        previousColumn = column + 1
                    }
                    return (checkEntry: false, nextRow: row - 1, nextColumn: column + 1)
                }
            } else {
                if currentPlayer != player   && !(currentPlayer.isEmpty) && currentPlayer != "T"{
                    if previousColumn != -1 {
                        let clmValue = previousColumn
                        return (self.checkPrevDataData(checkEntry: false, nextRow: 0, nextColumn: clmValue, isForPrediction: isForPrediction))
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: column + 1)
                } else {
                    if previousColumn != -1 {
                        return (checkEntry: true, nextRow: row - 1, nextColumn: column + 1)
                    }
                    return (checkEntry: true, nextRow: row, nextColumn: column)
                }
            }
        } else {
            if currentPlayer != player && currentPlayer != "T" {
                if previousColumn != -1 {
                    let clmValue = previousColumn
                    return (self.checkPrevDataData(checkEntry: false, nextRow: 0, nextColumn: clmValue, isForPrediction: isForPrediction))
                }
                return (checkEntry: false, nextRow: 0, nextColumn: column + 1)
            } else if currentPlayer == "T" {
                for index in stride(from: currentIndex - 1, through: 0, by: -1) {
                    let obj = self.bigMapArr[index]
                    if obj.player != nil && obj.player != "T" && obj.player != player {
                        if previousColumn != -1 {
                            let clmValue = previousColumn
                            return (self.checkPrevDataData(checkEntry: false, nextRow: 0, nextColumn: clmValue, isForPrediction: isForPrediction))
                        }
                        return (checkEntry: false, nextRow: 0, nextColumn: column + 1)
                    }
                    if obj.row == 0 {
                        break
                    }
                }
            } else {
                // if previousColumn == -1 {
                if previousColumn == -1 && (row - 1) != 0 && isForPrediction == false {
                    previousColumn = column + 1
                }
                return (checkEntry: false, nextRow: 5, nextColumn: column + 1)
            }
            return (checkEntry: false, nextRow: 0, nextColumn: column + 1)
        }
    }
    // MARK: - Draw Big Eye Road Map
    // swiftlint:disable:next line_length cyclomatic_complexity large_tuple function_body_length
    func drawBigEyeRoad(row: Int, column: Int, currentPattern: String, node: BigRoadMapData, isForPrediction: Bool) -> (checkEntry: Bool, nextRow: Int?, nextColumn: Int?, pattern: String) {
        let valueArr = self.bigEyeArr.filter({$0.row == row && $0.column == column})
        let patternValue = (node.row == 0) ? self.row0Rule(type: .bigEye, node: node):
        self.rowNon0Rule(type: .bigEye, node: node)
        if row == 6 {
            if currentPattern == patternValue {
                if previousColumnBE == -1 && isForPrediction == false {
                    self.previousColumnBE = column + 1
                }
                return (checkEntry: true, nextRow: 5, nextColumn: column + 1, pattern: patternValue)
            } else {
                if previousColumnBE != -1 {
                    let clmValue = previousColumnBE
                    previousColumnBE = (isForPrediction == false) ?  -1 : previousColumnBE
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
        } else {
            if currentPattern != patternValue && !(currentPattern.isEmpty) {
                if previousColumnBE != -1 {
                    let clmValue = previousColumnBE
                    previousColumnBE = (isForPrediction == false) ? -1 : previousColumnBE
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
            if valueArr.count > 0 {
                if currentPattern != patternValue && !(currentPattern.isEmpty) {
                    if previousColumnBE != -1 {
                        let clmValue = previousColumnBE
                        previousColumnBE = (isForPrediction == false) ? -1 : previousColumnBE
                        return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
                } else {
                    if previousColumnBE == -1 {
                        previousColumnBE = (isForPrediction == false) ? column + 1 : previousColumnBE
                    }
                    return (checkEntry: false, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
                }
            }
            if previousColumnBE != -1 {
                return (checkEntry: true, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
            }
            return (checkEntry: true, nextRow: row, nextColumn: column, pattern: patternValue)
        }
    }
    // MARK: - Draw Small Eye Road Map
    // swiftlint:disable:next line_length cyclomatic_complexity large_tuple function_body_length
    func drawSmallEyeRoad(row: Int, column: Int, currentPattern: String, node: BigRoadMapData, isForPrediction: Bool) -> (checkEntry: Bool, nextRow: Int?, nextColumn: Int?, pattern: String) {
        let valueArr = self.smallEyeArr.filter({$0.row == row && $0.column == column})
        let patternValue = (node.row == 0) ? self.row0Rule(type: .smallEye, node: node):
        self.rowNon0Rule(type: .smallEye, node: node)
        if row == 6 {
            if currentPattern == patternValue {
                if previousColumnSE == -1 {
                    if isForPrediction == false {
                        self.previousColumnSE = column + 1
                    }
                }
                return (checkEntry: true, nextRow: 5, nextColumn: column + 1, pattern: patternValue)
            } else {
                if previousColumnSE != -1 {
                    let clmValue = previousColumnSE
                    if isForPrediction == false {
                        previousColumnSE = -1
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
        } else {
            if currentPattern != patternValue && !(currentPattern.isEmpty) {
                if previousColumnSE != -1 {
                    let clmValue = previousColumnSE
                    if isForPrediction == false {
                        previousColumnSE = -1
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
            if valueArr.count > 0 {
                if currentPattern != patternValue && !(currentPattern.isEmpty) {
                    if previousColumnSE != -1 {
                        let clmValue = previousColumnSE
                        previousColumnSE = (isForPrediction == false) ? -1 : previousColumnSE
                        return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
                } else {
                    if previousColumnSE == -1 {
                        previousColumnSE = (isForPrediction == false) ? column + 1 : previousColumnSE
                    }
                    return (checkEntry: false, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
                }
            }
            if previousColumnSE != -1 {
                return (checkEntry: true, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
            }
            return (checkEntry: true, nextRow: row, nextColumn: column, pattern: patternValue)
        }
    }
    // MARK: - Draw CockRoach Eye Road Map
    // swiftlint:disable:next line_length cyclomatic_complexity large_tuple function_body_length
    func drawCockRoachRoad(row: Int, column: Int, currentPattern: String, node: BigRoadMapData, isForPrediction: Bool) ->(checkEntry: Bool, nextRow: Int?, nextColumn: Int?, pattern: String) {
        let valueArr = self.cockRoachEyeArr.filter({$0.row == row && $0.column == column})
        let patternValue = (node.row == 0) ? self.row0Rule(type: .coackRoach, node: node):
        self.rowNon0Rule(type: .coackRoach, node: node)
        if row == 6 {
            if currentPattern == patternValue {
                if previousColumnCR == -1 {
                    self.previousColumnCR = (isForPrediction == false) ? column + 1 : self.previousColumnCR
                }
                return (checkEntry: true, nextRow: 5, nextColumn: column + 1, pattern: patternValue)
            } else {
                if previousColumnCR != -1 {
                    let clmValue = previousColumnCR
                    previousColumnCR = (isForPrediction == false) ? -1 : previousColumnCR
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
        } else {
            if currentPattern != patternValue && !(currentPattern.isEmpty) {
                if previousColumnCR != -1 {
                    let clmValue = previousColumnCR
                    previousColumnCR = (isForPrediction == false) ? -1 : previousColumnCR
                    return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                }
                return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
            }
            if valueArr.count > 0 {
                if currentPattern != patternValue && !(currentPattern.isEmpty) {
                    if previousColumnCR != -1 {
                        let clmValue = previousColumnCR
                        previousColumnCR = (isForPrediction == false) ? -1 : previousColumnCR
                        return (checkEntry: true, nextRow: 0, nextColumn: clmValue, pattern: patternValue)
                    }
                    return (checkEntry: true, nextRow: 0, nextColumn: column + 1, pattern: patternValue)
                } else {
                    if previousColumnCR == -1 {
                        previousColumnCR = (isForPrediction == false) ? column + 1 : previousColumnCR
                    }
                    return (checkEntry: false, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
                }
            }
            if previousColumnCR != -1 {
                return (checkEntry: true, nextRow: row - 1, nextColumn: column + 1, pattern: patternValue)
            }
            return (checkEntry: true, nextRow: row, nextColumn: column, pattern: patternValue)
        }
    }
    private func checkPrevDataData(checkEntry: Bool,
                                   nextRow: Int,
                                   nextColumn: Int,
                                   isForPrediction: Bool) -> (checkEntry: Bool,
                                                              nextRow: Int?,
                                                              nextColumn: Int?) {
        let clmValue = previousColumn
        if isForPrediction == false {
            previousColumn = -1
        }
        for index in stride(from: clmValue - 1, through: 0, by: -1) {
            let value = self.bigMapArr.filter({$0.row == 0 && $0.column == index})
            if value.count > 0 {
                return (checkEntry: false, nextRow: 0, nextColumn: index + 1)
            }
        }
        return (checkEntry: false, nextRow: 0, nextColumn: clmValue)
    }
    func drawBreadPlat(row: Int,
                       column: Int,
                       player: String,
                       currentPlayer: String) -> (checkEntry: Bool,
                                                  nextRow: Int?,
                                                  nextColumn: Int?) {
        if row == 6 {
            return (checkEntry: true, nextRow: 0, nextColumn: column + 1)
        } else {
            return (checkEntry: true, nextRow: row, nextColumn: column)
        }
    }
    private func row0Rule(type: RoadMapype, node: BigRoadMapData) -> String {
        var patternMatchValue = ""
        var patternMismatchValue = ""
        var isPatternMatch = false
        let currentColumn = node.column ?? 0
        var traverseColumn1 = (node.column ?? 0) - 1
        var traverseColumn2 = (node.column ?? 0) - 3
        switch type {
        case .bigEye:
            patternMatchValue = "red"
            patternMismatchValue = "blue"
            traverseColumn1  = currentColumn - 1
            traverseColumn2 = currentColumn - 2
        case.smallEye:
            patternMatchValue = "redSmall"
            patternMismatchValue = "blueSmall"
            traverseColumn1  = currentColumn - 1
            traverseColumn2 = currentColumn - 3
        case .coackRoach:
            patternMatchValue = "redLine"
            patternMismatchValue = "blueLine"
            traverseColumn1  = currentColumn - 1
            traverseColumn2 = currentColumn - 4
        case .bigRoad:
            break
        }
        var lenght1 = 0
        var lenght2 = 0
        let node1Arr = bigMapArr.filter({$0.column == traverseColumn1 && $0.row == 0})
        if node1Arr.count > 0 {
            lenght1 = self.getLengthOfColumnNode(indexD: (node1Arr[0].index ?? 0), node: node1Arr[0])
        }
        let node2Arr = bigMapArr.filter({$0.column == traverseColumn2 && $0.row == 0})
        if node2Arr.count > 0 {
            lenght2 = self.getLengthOfColumnNode(indexD: (node2Arr[0].index ?? 0), node: node2Arr[0])
        }
        if lenght1 == lenght2 {
            isPatternMatch = true
        } else {
            isPatternMatch = false
        }
        return  (isPatternMatch ? patternMatchValue : patternMismatchValue)
    }
    private func rowNon0Rule(type: RoadMapype, node: BigRoadMapData) -> String {
        var patternMatchValue = ""
        var patternMismatchValue = ""
        var isPatternMatch = false
        var playerArrCurrent = [BigRoadMapData]()
        var playerArrPrev = [String]()
        for index in stride(from: node.index ?? 0, through: 0, by: -1) { // Travese from current index to till first found Row = 0
            let obj = self.bigMapArr[index]
            playerArrCurrent.append(obj)
            if obj.row == 0 {
                break
            }
            
        }
        var traverseColumn = 0
        let currentColumn = playerArrCurrent.last?.column ?? 0
        switch type {
        case .bigEye:
            patternMatchValue = "red"
            patternMismatchValue = "blue"
            traverseColumn  = currentColumn - 1
        case .smallEye:
            patternMatchValue = "redSmall"
            patternMismatchValue = "blueSmall"
            traverseColumn  = currentColumn - 2
        case .coackRoach:
            patternMatchValue = "redLine"
            patternMismatchValue = "blueLine"
            traverseColumn  = currentColumn - 3
        case .bigRoad:
            break
        }
        let preRow0Node = self.bigMapArr.first(where: {$0.row == 0 && $0.column == traverseColumn})
        var lenght = 0
        for index in stride(from: preRow0Node?.index ?? 0, through: self.bigMapArr.last?.index ?? 0, by: +1) {
            let obj = self.bigMapArr[index]
            if obj.row == 0 && lenght > 0 {
                break
            } else {
                playerArrPrev.append(obj.player ?? "")
            }
            lenght += 1
        }
        for index in playerArrCurrent.indices {
            let isIndexValid = playerArrPrev.indices.contains(index)
            if isIndexValid == false {
                playerArrPrev.append("")
            }
        }
        let comprisonIndex = (playerArrCurrent.count - 1)
        if comprisonIndex > 0 {
            if playerArrPrev[comprisonIndex] == playerArrPrev[comprisonIndex - 1] {
                isPatternMatch = true
            } else {
                isPatternMatch = false
            }
        }
        return  (isPatternMatch ? patternMatchValue : patternMismatchValue)
    }
    private func getLengthOfColumnNode(indexD: Int, node: BigRoadMapData? = nil) -> Int {
        var lenght = 0
        for index in stride(from: indexD, through: self.bigMapArr.last?.index ?? 0, by: +1) {
            let obj = self.bigMapArr[index]
            if obj.row == 0 && lenght != 0 {
                break
            } else {
                lenght += 1
            }
        }
        return lenght
    }
}
