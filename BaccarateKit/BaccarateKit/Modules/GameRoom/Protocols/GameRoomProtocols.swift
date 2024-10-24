//
//  GameRoomProtocols.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 7/9/23.
// BetInfoResponse
import Foundation

protocol GameRoomUI {
    func sucess (_ gameRoomTableData: GameRoomTableData)
    func sucessGroupData (_ gameRoomTableData: TableGroupRes)
    func sucessLeaveGroup (_ gameRoomTableData: ResponeData)
    func sucessGetBetInfoData (_ data: BetInfoResponse)
    func foundError (_ error: BackendError)
    func foundErrorLeaveGroup (_ error: BackendError)
    func foundErrorGetData (_ error: BackendError)
    func setFreeStatusSucess (_ data: LoginData)
    func sucessSetBetData (_ data: ResponeData)
    func sucessSaveChips (_ data: ResponeData)
    func imageRuleSucess (_ data: ResponeData)
}
protocol GameRoomUIInterface {
    func getTableInfoData(data: CasinoTableData)
    func getTableGroupData(data: CasinoTableData)
    func leaveTableGroup(groupNo: String)
    func getBetInfoData(groupNo: String)
    func setFreeStatus(groupNo: String, freeStatus: String)
    func setBetData(betData: BetData)
    func saveChips(chipsList: String)
    func getRuleImage()
}

extension GameRoomUI {
    func foundError (_ error: BackendError) {

    }
    func foundErrorLeaveGroup (_ error: BackendError) {

    }
    func sucessLeaveGroup (_ gameRoomTableData: ResponeData) {
        
    }
    func setFreeStatusSucess(_ data: LoginData) {
        
    }
    func sucess(_ gameRoomTableData: GameRoomTableData) {
        
    }
    
    func sucessGroupData(_ gameRoomTableData: TableGroupRes) {
        
    }
    
    func sucessGetBetInfoData(_ data: BetInfoResponse) {
        
    }
    func sucessSetBetData (_ data: ResponeData) {
        
    }
    func sucessSaveChips (_ data: ResponeData) {
        
    }
    func imageRuleSucess (_ data: ResponeData) {
        
    }
   func foundErrorGetData (_ error: BackendError) {
        
    }
}
// SoundVC Protocol
protocol SoundDelegate: AnyObject {
    func updatedSound()
}
