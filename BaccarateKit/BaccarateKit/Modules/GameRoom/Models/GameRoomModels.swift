//
//  GameRoomModels.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 16/09/23.
//

import Foundation
import UIKit

struct CasinoChip: Equatable {
    var image: UIImage!
    var slandingImage: UIImage!
    var value: Int!
    init(image: UIImage!, slandingImage: UIImage!, value: Int!) {
        self.image = image
        self.slandingImage = slandingImage
        self.value = value
    }
    static func == (lhs: CasinoChip, rhs: CasinoChip) -> Bool {
        return lhs.image == rhs.image && lhs.value == rhs.value
    }
}

struct ChipStack: Equatable {
    var chip: CasinoChip
    var chipView: UIImageView // Frame
    var isDraw = false
    init(chip: CasinoChip, chipView: UIImageView) {
        self.chip = chip
        self.chipView = chipView
    }
    static func == (lhs: ChipStack, rhs: ChipStack) -> Bool {
        return lhs.chip == rhs.chip && lhs.chipView == rhs.chipView
    }
}

// Delete once integrating API

public class GameRoomVM {
    public static let shared = GameRoomVM()
    private init() {}
    
    func fetchCasinoChips() -> [CasinoChip] {
        let casinoChips = [
            CasinoChip(image: UIImage(named: "icon_settings_chips_btn"),
                       slandingImage: UIImage(named: "icon_settings_chips_btn"),
                       value: 0),                     // 0
            CasinoChip(image: UIImage(named: "icon_chips_1"),
                       slandingImage: UIImage(named: "icon_chips_s_1"),
                       value: 1),                                // 1
            CasinoChip(image: UIImage(named: "icon_chips_5"),
                       slandingImage: UIImage(named: "icon_chips_s_5"),
                       value: 5),                                // 2
            CasinoChip(image: UIImage(named: "icon_chips_10"),
                       slandingImage: UIImage(named: "icon_chips_s_10"),
                       value: 10),                              // 3
            CasinoChip(image: UIImage(named: "icon_chips_20"),
                       slandingImage: UIImage(named: "icon_chips_s_20"),
                       value: 20),                              // 4
            CasinoChip(image: UIImage(named: "icon_chips_50"),
                       slandingImage: UIImage(named: "icon_chips_s_50"),
                       value: 50),                              // 5
            CasinoChip(image: UIImage(named: "icon_chips_100"),
                       slandingImage: UIImage(named: "icon_chips_s_100"),
                       value: 100)                             // 6
        ]
        return casinoChips
    }
    // swiftlint:disable:next function_body_length
    
    func fetchAllChips() -> [CasinoChip] {
        let casinoChips = [
            CasinoChip(image: UIImage(named: "icon_chips_1"),
                       slandingImage: UIImage(named: "icon_chips_s_1"),
                       value: 1),                                // 1
            CasinoChip(image: UIImage(named: "icon_chips_2"),
                       slandingImage: UIImage(named: "icon_chips_s_2"),
                       value: 2),                                // 2
            CasinoChip(image: UIImage(named: "icon_chips_5"),
                       slandingImage: UIImage(named: "icon_chips_s_5"),
                       value: 5),                                // 5
            CasinoChip(image: UIImage(named: "icon_chips_10"),
                       slandingImage: UIImage(named: "icon_chips_s_10"),
                       value: 10),                              // 10
            CasinoChip(image: UIImage(named: "icon_chips_20"),
                       slandingImage: UIImage(named: "icon_chips_s_20"),
                       value: 20),                              // 20
            CasinoChip(image: UIImage(named: "icon_chips_50"),
                       slandingImage: UIImage(named: "icon_chips_s_50"),
                       value: 50),                              // 50
            CasinoChip(image: UIImage(named: "icon_chips_100"),
                       slandingImage: UIImage(named: "icon_chips_s_100"),
                       value: 100),                            // 100
            CasinoChip(image: UIImage(named: "icon_chips_200"),
                       slandingImage: UIImage(named: "icon_chips_s_200"),
                       value: 200),                            // 200
            CasinoChip(image: UIImage(named: "icon_chips_500"),
                       slandingImage: UIImage(named: "icon_chips_s_500"),
                       value: 500),                            // 500
            CasinoChip(image: UIImage(named: "icon_chips_1k"),
                       slandingImage: UIImage(named: "icon_chips_s_1k"),
                       value: 1000),                            // 1000
            CasinoChip(image: UIImage(named: "icon_chips_2k"),
                       slandingImage: UIImage(named: "icon_chips_s_2k"),
                       value: 2000),                            // 2000
            CasinoChip(image: UIImage(named: "icon_chips_5k"),
                       slandingImage: UIImage(named: "icon_chips_s_5k"),
                       value: 5000),                            // 5000
            CasinoChip(image: UIImage(named: "icon_chips_10k"),
                       slandingImage: UIImage(named: "icon_chips_s_10k"),
                       value: 10000),                            // 10000
            CasinoChip(image: UIImage(named: "icon_chips_20k"),
                       slandingImage: UIImage(named: "icon_chips_s_20k"),
                       value: 20000),                            // 20000
            CasinoChip(image: UIImage(named: "icon_chips_50k"),
                       slandingImage: UIImage(named: "icon_chips_s_50k"),
                       value: 50000),                            // 50000
            CasinoChip(image: UIImage(named: "icon_chips_100k"),
                       slandingImage: UIImage(named: "icon_chips_s_100k"),
                       value: 100000),                            // 100000
            CasinoChip(image: UIImage(named: "icon_chips_200k"),
                       slandingImage: UIImage(named: "icon_chips_s_200k"),
                       value: 200000),                            // 200000
            CasinoChip(image: UIImage(named: "icon_chips_1m"),
                       slandingImage: UIImage(named: "icon_chips_s_1m"),
                       value: 1000000),                            // 1000000
            CasinoChip(image: UIImage(named: "icon_chips_5m"),
                       slandingImage: UIImage(named: "icon_chips_s_5m"),
                       value: 5000000),                            // 5000000
            CasinoChip(image: UIImage(named: "icon_chips_10m"),
                       slandingImage: UIImage(named: "icon_chips_s_10m"),
                       value: 10000000),                            // 10000000
            CasinoChip(image: UIImage(named: "icon_chips_20m"),
                       slandingImage: UIImage(named: "icon_chips_s_20m"),
                       value: 20000000),                            // 20000000
            CasinoChip(image: UIImage(named: "icon_chips_50m"),
                       slandingImage: UIImage(named: "icon_chips_s_50m"),
                       value: 50000000),                            // 50000000
            CasinoChip(image: UIImage(named: "icon_chips_100m"),
                       slandingImage: UIImage(named: "icon_chips_s_100m"),
                       value: 100000000),                            // 100000000
            CasinoChip(image: UIImage(named: "icon_chips_200m"),
                       slandingImage: UIImage(named: "icon_chips_s_200m"),
                       value: 200000000),                            // 200000000
            CasinoChip(image: UIImage(named: "icon_chips_500m"),
                       slandingImage: UIImage(named: "icon_chips_s_500m"),
                        value: 500000000),                            // 500000000
            CasinoChip(image: UIImage(named: "icon_chips_1b"),
                       slandingImage: UIImage(named: "icon_chips_s_1b"),
                       value: 1000000000),                            // 1000000000
            CasinoChip(image: UIImage(named: "icon_chips_5b"),
                       slandingImage: UIImage(named: "icon_chips_s_5b"),
                       value: 5000000000)                            // 5000000000
        ]

        return casinoChips
    }
}

class BetData {
    var currency: String
    var boothNum: String
    var freeStatus: String
    var groupNum: String
    var roundNo: String
    var arrCoinsValue: [[String: Any]]
    init(currency: String,
         boothNum: String,
         freeStatus: String,
         groupNum: String,
         roundNo: String,
         arrCoinsValue: [[String: Any]]) {
        self.currency = currency
        self.boothNum = boothNum
        self.freeStatus = freeStatus
        self.groupNum = groupNum
        self.roundNo = roundNo
        self.arrCoinsValue = arrCoinsValue
    }
}
enum GameResult: String {
    case tableInfo = "table_info"
    case roundResult = "round_result"
    case updateResult = "update_result"
    case roundNum = "round_num"
    case addCard = "add_card"
    case card = "card"
    case betPot = "bet_pot"
    case payoff = "payoff"
    case money = "money"
    case betInfo = "bet_info"
    case userEntered = "user_enter"
    case userLeave = "user_leave"
    case reset = "reset"
    case noData = ""
}

struct PlayerData {
    let symbol: String?
    let money: Double?
    let groupID: Int?
    let nickname, currency, seatNo: String?
    let userID: Int?
    let username: String?
}

