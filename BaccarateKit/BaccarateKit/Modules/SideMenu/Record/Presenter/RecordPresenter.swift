//
//  RecordPresenter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 12/9/23.
//

import Foundation
struct RecordPresenter: RecordUIInterface {
    fileprivate var ui: RecordUI?
    fileprivate var wireframe: ProjectWireframe?
    
    init(ui: RecordUI? = nil, wireframe: ProjectWireframe? = nil) {
        self.ui = ui
        self.wireframe = wireframe
    }
    func getRecordList(pageSize: Int, currentPage: Int, startDate: String, endDate: String) {
        RestApi.fetchData(urlRequest: RecordApiRouter.getRecordList(pageSize: pageSize,
                                                                    currentPage: currentPage,
                                                                    startDate: startDate,
                                                                    endDate: endDate)) { (data: RecordListResponse) in
            if data.respCode == 0 {
                self.ui?.recordListSucess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getChangeMoneyList(pageSize: Int,
                            currentPage: Int,
                            startDate: String,
                            endDate: String) {
        RestApi.fetchData(urlRequest: RecordApiRouter.getMoneyChangeList(pageSize: pageSize,
                                                                         currentPage: currentPage,
                                                                         startDate: startDate,
                                                                         endDate: endDate)) { (data: MoneyChangeListResponse) in
            if data.respCode == 0 {
                self.ui?.moneyChangeListSucess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getWashCodeList(pageSize: Int, currentPage: Int, startDate: String, endDate: String) {
        RestApi.fetchData(urlRequest: RecordApiRouter.getWashCodeList(pageSize: pageSize,
                                                                      currentPage: currentPage,
                                                                      startDate: startDate,
                                                                      endDate: endDate)) { (data: WashCodeResponse) in
            if data.respCode == 0 {
                self.ui?.washCodeListSucess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getRecordDetail(data: PageResultData) {
        RestApi.fetchData(urlRequest: RecordApiRouter.getRecordDetail(data: data)) { (data: RecordDetailsResponse) in
            if data.respCode == 0 {
                self.ui?.recordDetailSucess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg ?? ""))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    
}
