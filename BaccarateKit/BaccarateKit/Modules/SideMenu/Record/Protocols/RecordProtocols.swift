//
//  RecordsProtocols.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//
import Foundation
import Alamofire
protocol RecordUI {
    func recordListSucess (_ data: RecordListResponse)
    func moneyChangeListSucess (_ data: MoneyChangeListResponse)
    func washCodeListSucess (_ data: WashCodeResponse)
    func recordDetailSucess (_ data: RecordDetailsResponse)
    func foundError (_ error: BackendError)
}
protocol RecordUIInterface {
    func getRecordList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    func getChangeMoneyList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    func getWashCodeList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    func getRecordDetail(data: PageResultData)
}
protocol RecordVCDelegate: AnyObject {
    func showRecordDetail(data: PageResultData)
}

extension RecordUI {
    func recordListSucess (_ data: RecordListResponse) {
        
    }
    func moneyChangeListSucess (_ data: MoneyChangeListResponse) {
        
    }
    func recordDetailSucess (_ data: RecordListResponse) {
        
    }
    func washCodeListSucess (_ data: WashCodeResponse) {
        
    }
    func recordDetailSucess (_ data: RecordDetailsResponse) {
        
    }
}
