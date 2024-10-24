//
//  CasinoTimer.swift
//  BaccaratLiveStream
//
//  Created by Mohd Farmood on 1/7/24.
//

import Foundation
class CasinoTimer {
    static let shared = CasinoTimer()
    var timerArray = [Int]()
    var index: Int?
    var countdownTimer: Timer!
    func initialize(casinoArr: [CasinoTableData]) {
        timerArray = [Int]()
        print("casinoArr.count ==>", casinoArr.count)
        for item in casinoArr {
            if item.gameTableStatusVo?.remainSecond != nil && item.gameTableStatusVo?.remainSecond ?? 0 > 0 {
                    timerArray.append(item.gameTableStatusVo?.remainSecond ?? 0)
            } else {
                
                    timerArray.append(item.gameTableStatusVo?.betSecond ?? 0)
            }
        }
        for timer in timerArray {
            print("timer ==>", timer)
        }
        startTimer()
    }
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTime),
                                              userInfo: nil, repeats: true)
        
    }
    @objc func updateTime() {
         var indexTimer = 0
        for var timervalue in timerArray {
            timervalue -= 1
            if timervalue != 0 && timervalue > 0 {
                timerArray[indexTimer] = timervalue
            } else {
                timerArray[indexTimer] = 0
            }
            indexTimer += 1
            
        }
    }
    func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    func getTimerValueByIndex(indexOfCasino: Int) -> Int {
        print("timerArray[\(indexOfCasino)] ==>", timerArray[indexOfCasino])
    //    if timerArray.count > indexOfCasino {
            return timerArray[indexOfCasino]
//        } else {
//            return 0
//        }
    }
    func updateCasinoDataByIndex(casinoData: CasinoTableData, indexOfCasino: Int) {
        
        if casinoData.gameTableStatusVo?.remainSecond != nil && casinoData.gameTableStatusVo?.remainSecond ?? 0 > 0 {
          //  if timerArray.count > indexOfCasino {
                timerArray[indexOfCasino] = casinoData.gameTableStatusVo?.remainSecond ?? 0
           // }
        } else {
         //   if timerArray.count > indexOfCasino {
                timerArray[indexOfCasino] = casinoData.gameTableStatusVo?.betSecond ?? 0
          //  }
        }
    }
}
