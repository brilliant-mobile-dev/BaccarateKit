//
//  RankingProtocols.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//
import Foundation

protocol RankingUI {
    func successRichTop10(_ data: RichListResponse)
    func successWinTop10(_ data: RichListResponse)
    func successBetTop10(_ data: RichListResponse)
    func foundError (_ error: BackendError)
}
protocol RankingUIInterface {
    func getRichTop10List()
    func getWinTop10List()
    func getBetTop10List()
}
