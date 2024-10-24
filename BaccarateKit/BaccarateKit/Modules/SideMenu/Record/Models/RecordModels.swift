//
//  RecordModels.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 12/9/23.
//

import Foundation
// MARK: - RecordListResponse
struct RecordListResponse: Codable {
    let datas: RecordListData?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

struct RecordListData: Codable {
    let betTotal: BetTotal?
    let pageResult: PageResult?
    let subBetTotal: BetTotal?
}

struct BetTotal: Codable {
    let betMoney, validBetMoney, winLossMoney: Double?
}

struct PageResult: Codable {
    let count, currPage: Int?
    let data: [PageResultData]?
    let pageSize, totalPage: Int?
}
struct PageResultData: Codable {
    let betMoney, betValidMoney: Double?
    let bootNo, calcTime: String?
    let gameID: Int?
    let gameName, roundNo, tableNo: String?
    let winLossMoney: Double?

    enum CodingKeys: String, CodingKey {
        case betMoney, betValidMoney, bootNo, calcTime
        case gameID = "gameId"
        case gameName, roundNo, tableNo, winLossMoney
    }
}
// MARK: - MoneyChangeListResponse
struct MoneyChangeListResponse: Codable {
    let datas: MoneyChange?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}
struct MoneyChange: Codable {
    let currPage, pageSize, totalPage, count: Int?
    let data: [MoneyChangeData]?
}
struct MoneyChangeData: Codable {
    let currency: String?
    let money: Double?
    let beforeMoney, afterMoney: Double?
    let remark: String?
    let orderType: Int?
    let orderTypeName, createTime: String?
}
// MARK: - WashCodeResponse
struct WashCodeResponse: Codable {
    let datas: WashCode?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

struct WashCode: Codable {
    let pageResult: WashPageResult?
    let total: Double?
}

struct WashPageResult: Codable {
    let currPage, pageSize, totalPage, count: Int?
    let data: [WashCodeData]?
}
struct WashCodeData: Codable {
    let money: Double?
    let takeTime: String?
}

// MARK: - Record Detail Model Response
struct RecordDetailsResponse: Codable {
    let datas: [RecordDetailsData]?
    let respCode: Int
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - DataElement
struct RecordDetailsData: Codable {
    let playName, calcTime: String
    let betMoney, betValidMoney, winLossMoney: Double
}
