//
//  DashboardPresenter.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import Foundation

struct DashboardPresenter: DashboardUIInterface {
    
    fileprivate var ui: DashboardUI?
    fileprivate var wireframe: ProjectWireframe?
    
    init(ui: DashboardUI? = nil, wireframe: ProjectWireframe? = nil) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func getGameRoomList(gameId: Int, placeId: Int) {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getGameRoomList(gameId: gameId, placeId: placeId)) { (dashboardData: DashboardData) in
            gameIdG = "\(gameId)"
            placeIdG = "\(placeId)"
            if dashboardData.respCode == 0 {
                self.ui?.sucess(dashboardData)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: dashboardData.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    
    func getUserInfo() {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getUserInfo) { (userData: UserData) in
            if userData.respCode == 0 {
                ConfigurationDataManager.shared.userInfo = userData.datas
                self.ui?.userSuccess(userData)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: userData.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getNoticeList() {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getNoticeInfo) { (noticeData: NoticeData) in
            if noticeData.respCode == 0 {
                self.ui?.noticeSuccess(noticeData)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: noticeData.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getOnlineNumber() {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getOnlineNumber) { (onlineData: OnlineData) in
            if onlineData.respCode == 0 {
                self.ui?.getOnlineSuccess(onlineData)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: onlineData.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    func getCustomerList() {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getCustomerList) { (data: CustomerServiceResponse) in
            if data.respCode == 0 {
                self.ui?.customerServiceSuccess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg ?? ""))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    func getPlaceList(gameID: Int) {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getPlaceList(gameID: gameID)) { (data: PlaceResponse) in
            if data.respCode == 0 {
                self.ui?.placeListSuccess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg ?? ""))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    func getGameCategoryList() {
        RestApi.fetchData(urlRequest: DashboardAPIRouter.getGameList) { (data: GameResponse) in
            if data.respCode == 0 {
                self.ui?.gameCategoryListSuccess(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg ?? ""))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
}
