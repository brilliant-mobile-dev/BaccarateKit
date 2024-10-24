//
//  DashboardModel.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import Foundation
// MARK: - Dashboard Data - Game List
struct DashboardData: Codable {
    let datas: [CasinoTableData]?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - DataElement
class CasinoTableData: Codable {
    var bigMapArrInner = [BigRoadMapData]()
    let tableID, placeID, gameID: Int?
    let tableColor: Int?
    let tableColorNew: String?
    let tableNo: String?
    let liveURL: String?
    let freeStatus: Bool?
    let status: Int?
    let name, lobbyTableLimit: String?
    let dealerInfoAPIVo: DealerInfoAPIVo?
    var gameTableStatusVo: GameTableStatusVo?
    var gameTableResultVos: [GameTableResultVo]?
    var gameTableInfoStatisticsVo: GameTableInfoStatisticsVo?
    var mapData: MapPlayerDatas?
    var casinoTimer: CasinoTimer?
    enum CodingKeys: String, CodingKey {
        case tableID = "tableId"
        case placeID = "placeId"
        case gameID = "gameId"
        case tableColor, tableNo, tableColorNew
        case liveURL = "liveUrl"
        case freeStatus, status, name, lobbyTableLimit
        case dealerInfoAPIVo = "dealerInfoApiVo"
        case gameTableStatusVo, gameTableResultVos, gameTableInfoStatisticsVo
    }
}
struct MapPlayerDatas {
    var previousColumn = -1
    var currentColumn = 0
    var currentRow  = 0
    var currentIndex  = 0
    var currentPlayer: String?
    var previousPlayer: String?
    var currentMaxRow: Int?
    var previousMaxRow: Int?
    var bigMapArr = [BigRoadMapData]()
}
// MARK: - DealerInfoAPIVo
struct DealerInfoAPIVo: Codable {
    let dealerID: Int?
    let dealerNo, dealerName: String?
    let dealerPhoto: String?

    enum CodingKeys: String, CodingKey {
        case dealerID = "dealerId"
        case dealerNo, dealerName, dealerPhoto
    }
}

// MARK: - GameTableInfoStatisticsVo
class GameTableInfoStatisticsVo: Codable {
    var roundNum, bankerNum, playerNum, tieNum: Int?
    var bankerPairNum, playerPairNum: Int?
    init(roundNum: Int, tieNum: Int, playerPairNum: Int, bankerNum: Int, playerNum: Int, bankerPairNum: Int) {
         self.roundNum = roundNum
         self.tieNum = tieNum
         self.playerPairNum = playerPairNum
         self.bankerNum = bankerNum
         self.playerNum = playerNum
         self.bankerPairNum = bankerPairNum
     }
}

// MARK: - GameTableResultVo
class GameTableResultVo: Codable {
    var bootNo, roundNo, result: String?
}

// MARK: - GameTableStatusVo
class GameTableStatusVo: Codable {
    var bootNo, roundNo: String?
    var betSecond, calcSecond, remainSecond, status, roundNum: Int?
}
// MARK: - UserData
struct UserData: Codable {
    let datas: UserInfo?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let userID: Int
    let username: String?
    let headImgURL: String?
    let playerType: Int?
    let isTourists: Bool?
    let currency, symbol: String?
    var userMoney: Double?
    let remainBet: Double?
    var washCodeMoney: Double?
    var chips: String?
    let customerSwitch: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case username
        case headImgURL = "headImgUrl"
        case playerType, isTourists, currency, symbol, userMoney, remainBet, washCodeMoney, chips, customerSwitch
    }
}

// MARK: - NoticeData
struct NoticeData: Codable {
    let datas: [NoticeInfo]?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - NoticeInfo
struct NoticeInfo: Codable {
    let content: String?
    let language, title, createTime: String?
}

// MARK: - Online Data
struct OnlineData: Codable {
    let datas: Int?
    let respCode: Int
    let respMsg: String

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}
class ConfigurationDataManager {
    static let shared = ConfigurationDataManager()
    var cachelanguageSource = "local"
    var userInfo: UserInfo?
    var languageDataArr: [LanguageData]?
    var languageSourceDataArr: [LanguageSourceData]?
    var selectedSourceLanguage: LanguageSourceData?
    var selectedLanguage: LanguageData?
    var selectedLanguageCode: String?
    var logoData: LogoData?
}
struct LobbySocketData: Codable {
    let code: Int?
    let data: SocketData?
    let type, respMsg: String?

    enum CodingKeys: String, CodingKey {
        case code, data, type
        case respMsg = "resp_msg"
    }
}

// MARK: - DataClass
// MARK: - OtherPlayerChip
struct OtherPlayerChip: Codable {
    let code: Int
    let data: BetInfo?
    let type, respMsg: String

    enum CodingKeys: String, CodingKey {
        case code, data, type
        case respMsg = "resp_msg"
    }
}

// MARK: - BetInfo
struct BetInfo: Codable {
    var gameID: Int
    var betCode, symbol: String
    var betMoney, groupID, placeID, userID: Int
    var bootNo, currency, roundNo, seatNo: String
    var username, tableNo: String

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case betCode, symbol, betMoney
        case groupID = "groupId"
        case placeID = "placeId"
        case userID = "userId"
        case bootNo, currency, roundNo, seatNo, username, tableNo
    }
}
struct SocketData: Codable {
    let gameID: Int?
    let result, gameName: String?
    let placeID: Int?
    // Data for "type":"bet_pot"",
    let betPotDetailVos: [BetPotDetailVo]?
    let bootNo, roundNo, tableNo: String?
    let bankerNum, roundNum, playerPairNum: Int?
    let point: Int?
    let bankerPairNum, tieNum, playerNum, calcSecond, betSecond: Int?
    let remainSecond: Int?
    let status: Int?
    // Data for "type":"user_enter",
    let symbol: String?
    let money: Double?
    let groupID: Int?
    let nickname, currency, seatNo: String?
    let userID: Int?
    let username: String?
    // Data for "type":"user_enter",
    let location: String?
    let totalPayoffMoney: Double?
    var userMoney: Double?
    var washCodeMoney: Double?
    let banker2, banker1, banker3: String?
    let player1, player2, player3: String?
    let confirmTime, updateTime, createTime: Int?
    let bankerPoint, playerPoint: Int?
    let playerOver, bankerOver: Bool?
    let playerNeedCard, bankerNeedCard: Bool?
    // for entered Player
    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case result, gameName
        case placeID = "placeId"
        case bootNo, roundNo, tableNo
        case bankerNum, roundNum, playerPairNum
        case bankerPairNum, tieNum, playerNum, status, calcSecond, betSecond
        case betPotDetailVos
        // Data for "type":"user_enter",
        case symbol, money
        case groupID = "groupId"
        case nickname, currency, seatNo
        case userID = "userId"
        case username
        case remainSecond
        case totalPayoffMoney
        case userMoney
        case washCodeMoney
        // Data for "type":""type":"add_card",",
        case location
        case point
        case banker2, banker1, banker3
        case player1, player2, player3
        case confirmTime, updateTime, createTime
        case playerPoint, bankerPoint
        case playerOver, bankerOver
        case playerNeedCard, bankerNeedCard
    }
}
// MARK: - BetPotDetailVo
struct BetPotDetailVo: Codable {
    let potMoney, potCount: Int?
    var location, potMoneyDisplay: String?
}

struct PlaceResponse: Codable {
    let datas: [PlaceData]?
    let respCode: Int?
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - DataElement
struct PlaceData: Codable {
    let placeID: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case placeID = "placeId"
        case name
    }
}
// MARK: - GameResponse
struct GameResponse: Codable {
    let datas: [GameData]?
    let respCode: Int?
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - GameData
struct GameData: Codable {
    let gameID: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case name
    }
}
