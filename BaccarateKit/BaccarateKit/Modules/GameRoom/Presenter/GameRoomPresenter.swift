//
//  GameRoomPresenter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 6/9/23.
//
import Foundation
// swiftlint:disable superfluous_disable_command identifier_name
struct GameRoomPresenter: GameRoomUIInterface {
    fileprivate var ui: GameRoomUI?
    fileprivate var wireframe: ProjectWireframe?
    init(ui: GameRoomUI? = nil, wireframe: ProjectWireframe? = nil) {
        self.ui = ui
        self.wireframe = wireframe
    }
    func getTableInfoData(data: CasinoTableData) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.getTableInfoData(data: data)) { (data: GameRoomTableData) in
            if data.respCode == 0 {
                self.ui?.sucess(data)
            } else {
                self.ui?.foundErrorGetData(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundErrorGetData(backendError)
        }
    }
    func getTableGroupData(data: CasinoTableData) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.getTableGroupData(data: data)) { (data: TableGroupRes) in
            if data.respCode == 0 {
                self.ui?.sucessGroupData(data)
            } else {
                self.ui?.foundErrorGetData(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundErrorGetData(backendError)
        }

    }
    func getBetInfoData(groupNo: String) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.getTableBetInfo(groupNo: groupNo)) { (data: BetInfoResponse) in
            if data.respCode == 0 {
                self.ui?.sucessGetBetInfoData(data)
            } else {
                self.ui?.foundErrorGetData(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundErrorGetData(backendError)
        }
    }
    func leaveTableGroup(groupNo: String) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.leaveTableGroup(groupNo: groupNo)) { (data: ResponeData) in
            if data.respCode == 0 {
                self.ui?.sucessLeaveGroup(data)
            } else {
             self.ui?.foundErrorLeaveGroup(BackendError(errorCode: -1, errorDescription: data.respMsg ?? ""))
            }
        } failure: { backendError in
            self.ui?.foundErrorLeaveGroup(backendError)
        }
    }
    func setFreeStatus(groupNo: String, freeStatus: String) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.setFreeStatus(groupNo: groupNo,
                                                                      freeStatus: freeStatus)) { (data: LoginData) in
            if data.respCode ==  0 {
                self.ui?.setFreeStatusSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func setBetData(betData: BetData) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.setBetData(betData: betData)) { (data: ResponeData) in
            if data.respCode ==  0 {
                self.ui?.sucessSetBetData(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func saveChips(chipsList: String) {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.saveChips(chipsList: chipsList)) { (data: ResponeData) in
            if data.respCode ==  0 {
                self.ui?.sucessSaveChips(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getRuleImage() {
        RestApi.fetchData(urlRequest: GameRoomApiRouter.getRuleImage) { (data: ResponeData) in
            if data.respCode ==  0 {
                self.ui?.imageRuleSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
}
