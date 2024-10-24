//
//  RankingPresenter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//

import Foundation
struct RankingPresenter: RankingUIInterface {
    fileprivate var ui: RankingUI?
    fileprivate var wireframe: ProjectWireframe?
    
    init(ui: RankingUI? = nil, wireframe: ProjectWireframe? = nil) {
        self.ui = ui
        self.wireframe = wireframe
    }
    func getRichTop10List() {
        RestApi.fetchData(urlRequest: RankingAPiRouter.getRichTop10List) { (data: RichListResponse) in
            if data.respCode == 0 {
                self.ui?.successRichTop10(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    func getWinTop10List() {
        RestApi.fetchData(urlRequest: RankingAPiRouter.getWinTop10List) { (data: RichListResponse) in
            if data.respCode == 0 {
                self.ui?.successWinTop10(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
    
    func getBetTop10List() {
        RestApi.fetchData(urlRequest: RankingAPiRouter.getBetTop10List) { (data: RichListResponse) in
            if data.respCode == 0 {
                self.ui?.successBetTop10(data)
            } else {
                self.ui?.foundError(BackendError(errorCode: -1, errorDescription: data.respMsg))
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }

    }
}
