//
//  RoomTableInfoData.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 7/9/23.
//
import Foundation

// MARK: - Welcome
struct GameRoomTableData: Codable {
    let datas: TableRoomData
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - Datas
struct TableRoomData: Codable {
    let tableID, placeID, gameID: Int?
    let tableColor: Int?
    let tableColorNew: String?
    let tableNo: String?
    let liveURL: String?
    var freeStatus, userFreeStatus: Bool?
    var tableResultType: Int?
    let status: Int?
    let name: String?
    let tableLimit: Double?
    let bacGameLimitPlanContent: [String: Double]?
    let autoQuitNum: Int?
    let bacOddsVo: BacOddsVo?
    var playTypeNameVos: [PlayTypeNameVo]?
    var gameTableStatusVo: GameTableStatusVo?
    var gameTableResultVos: [GameTableResultVo]?
    var gameTableInfoStatisticsVo: GameTableInfoStatisticsVo?

    enum CodingKeys: String, CodingKey {
        case tableID = "tableId"
        case placeID = "placeId"
        case gameID = "gameId"
        case tableColor, tableNo, tableColorNew
        case liveURL = "liveUrl"
        case freeStatus,
             userFreeStatus,
             status,
             name,
             tableLimit,
             bacGameLimitPlanContent,
             autoQuitNum,
             bacOddsVo,
             playTypeNameVos,
             gameTableStatusVo,
             gameTableResultVos,
             gameTableInfoStatisticsVo,
             tableResultType
    }
}
// MARK: - BacOddsVo
struct BacOddsVo: Codable {
    let banker: Double?
    let bankerFree, player, tie, bankerPair: Double?
    let playerPair: Double?
}

enum BootNo: String, Codable {
    case the23090705 = "230907-05"
}
// MARK: - PlayTypeNameVo
struct PlayTypeNameVo: Codable {
    let code, name: String
}
// MARK: - Welcome
struct TableGroupRes: Codable {
    let datas: TableGroupData?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - Datas
struct TableGroupData: Codable {
    let groupID: Int?
    let groupNo, seatNo: String?
    let groupUsers: [String: GroupUser]?

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupNo, seatNo, groupUsers
    }
}

// MARK: - GroupUser
struct GroupUser: Codable {
    let userID: Int
    let seatNo, symbol, nickname, username: String?
    let groupID: Int?
    let money: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case seatNo, symbol, nickname, username
        case groupID = "groupId"
        case money, currency
    }
}

// MARK: - Welcome
struct BetInfoResponse: Codable {
    var datas: BetInfoData?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - Datas
struct BetInfoData: Codable {
    var bacBetPotVo: BacBetPotVo?
    let betRecordVos: [BetRecordVo]?
}

// MARK: - BacBetPotVo
struct BacBetPotVo: Codable {
    let placeID, gameID: Int?
    let tableNo, bootNo, roundNo: String?
    var betPotDetailVos: [BetPotDetailVo]?

    enum CodingKeys: String, CodingKey {
        case placeID = "placeId"
        case gameID = "gameId"
        case tableNo, bootNo, roundNo, betPotDetailVos
    }
}
// MARK: - BetRecordVo
struct BetRecordVo: Codable {
    let userID: Int?
    let symbol, seatNo: String?
    let betDetails: BetDetails?
    let username: String?
    let betRecordVoSelf: Bool?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case symbol, seatNo, betDetails, username
        case betRecordVoSelf = "self"
        case currency
    }
}

// MARK: - BetDetails
struct BetDetails: Codable {
    let player: Int? // Player
    let banker: Int? // Banker
    let playerPair: Int? // Player Pair
    let tie: Int? // Tie
    let bankerPair: Int? // Banker Pair
    enum CodingKeys: String, CodingKey {
        case player = "1" // Player
        case banker = "4"
        case playerPair = "5"
        case tie = "7" // Tie
        case bankerPair = "8"
        
    }
}
