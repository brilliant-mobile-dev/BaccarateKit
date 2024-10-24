//
//  DashboardProtocols.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import Foundation

protocol DashboardUI {
    func sucess (_ dashboardData: DashboardData)
    func userSuccess(_ userData: UserData)
    func noticeSuccess(_ noticeData: NoticeData)
    func getOnlineSuccess(_ onlineData: OnlineData)
    func customerServiceSuccess(_ userData: CustomerServiceResponse)
    func placeListSuccess(_ placeData: PlaceResponse)
    func gameCategoryListSuccess(_ gameListData: GameResponse)
    func foundError (_ error: BackendError)
}
protocol DashboardUIInterface {
    func getGameRoomList(gameId: Int, placeId: Int)
    func getUserInfo()
    func getNoticeList()
    func getOnlineNumber()
    func getCustomerList()
    func getPlaceList(gameID: Int)
    func getGameCategoryList()
}

extension DashboardUI {
    func sucess (_ dashboardData: DashboardData) {
        
    }
    func userSuccess(_ userData: UserData) {
        
    }
    func noticeSuccess(_ noticeData: NoticeData) {
        
    }
    func getOnlineSuccess(_ onlineData: OnlineData) {
        
    }
    func foundError (_ error: BackendError) {
        
    }
    func customerServiceSuccess(_ userData: CustomerServiceResponse) {
        
    }
    func placeListSuccess(_ userData: PlaceResponse) {
        
    }
    func gameCategoryListSuccess(_ gameListData: GameResponse) {
        
    }
}
protocol RefreshPreviousVCDelegate: AnyObject {
    func handlePreviousVCData()
}
