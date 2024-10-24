//
//  RankingModels.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//

import Foundation

// MARK: - RichList Model
struct RichListResponse: Codable {
    let datas: [RichListData]?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - DataElement
struct RichListData: Codable {
    let sortNo: Int?
    let username: String?
    let money: Double?
}
