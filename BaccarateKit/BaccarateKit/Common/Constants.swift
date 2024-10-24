//
//  Constants.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
// gfdgdf

import Foundation
import UIKit
// Road Maps
var gameIdG = "101"
var placeIdG = "1"
let maxPassword = 10
let minPassword = 6
let mapHeight = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6) ? 110.0: 140.0
var casinoCellHeight = 180.0
var switchCellHeight = 180.0
let ipadFontSize = 24.0
let iphoneFontSize = 14.0
let fontName = "HelveticaNeue-Bold"
var fontSize = (Display.typeIsLike == .ipad) ? ipadFontSize: iphoneFontSize
var bigEyeStartColumn = 1
var c2 = 2
var d1 = 3
var e2 = 4
var f1 = 5
let playerColor = UIColor.blue
let bankerColor = UIColor.red
let naturalColor = UIColor(red: 249/255.0, green: 181/255.0, blue: 14/255.0, alpha: 1.0)
let winColor = UIColor.purple
let tieColor = UIColor(red: 17/255.0, green: 137/255.0, blue: 1/255.0, alpha: 1.0)
//
var windowG: UIWindow?
var totalTimeRegister = 0
var appVersion = "0.0"
var deviceTokenG = ""
struct BaccaratLivelanguage {
    static var id = "1"
    static var code = "en"
    static var name = "English"
    static var iconUrl = "http://minio1.fxdd6900.cc/kkvideo/language_en.png"
    static var codeISO = "en"
}
var currentVC: UIViewController?
let prefixStartTime = "+00:00:00"
let prefixEndTime = "+23:59:59"
struct BaccaratUser {
    static var id = ""
    static var name = ""
    static var image = ""
    static var logoutStatus = "false"
    static var isEnable = false
    static var forceUpdate = false
    static var otpTimer = 60
    static var database = ""
}

struct AppColors {
    static let shadowColor = "DDDDDD"
    static let themeColor = "F26522"
    static let backgroundColor = "FAFAFA"
    static let drakGreen = "00AD30"
    static let borderGray = "D9D9D9"
    static let mediumGray = "8C8C8C"
    static let lightOrange = "FFDCCC"
    static let receiveColor = "07B863"
    static let transferColor = "FF7A00"
    static let withdraw = "ffffdc7e"
    static let enableColor = "0075E3"
    static let failColor = "EB3223"
    static let reviewColor = "FF7A00"
    static let verifiedColor = "009700"
    static let reject = "FF9C00" // X status
    static let APPROVED = "0DAC43" // Approved
    static let greenText = "61C57D"
    static let redText = "FF0000"
    static let disableColor = "C8C8C8"
}

struct Constants {
    static let allChips: [Int] = [1,
                                  2,
                                  5,
                                  10,
                                  20,
                                  50,
                                  100,
                                  200,
                                  500,
                                  1000,
                                  2000,
                                  5000,
                                  10000,
                                  20000,
                                  50000,
                                  100000,
                                  200000,
                                  1000000,
                                  5000000,
                                  10000000,
                                  20000000,
                                  50000000,
                                  100000000,
                                  200000000,
                                  500000000,
                                  1000000000,
                                  5000000000]
    static let amountLimit = 5000.0
    struct BaseUrl {
        static var appUrl: String {
    #if CNY
            return "https://search.tg7899.cc/game-server"

    #elseif USD
            return "https://search.tg6666.cc/game-server"
    #elseif THB
            return "https://search.tg8999.cc/game-server"
    #elseif KRW
            return "https://search.tg6789.cc/game-server"
    #else
        //    return "https://test-gateway.kkvd88819.com/game-server"
               return "https://test-gateway.kkvd88819.com/game-server"
            // return "https://test-gateway-ios.kkvd88819.com/game-server"
    #endif
        }
        static var lobbySocketUrl: String {
    #if CNY
            return "wss://lobby.tg7899.cc"

    #elseif USD
            return "wss://lobby.tg6666.cc"
    #elseif THB
            return "wss://lobby.tg8999.cc"
    #elseif KRW
            return "wss://lobby.tg6789.cc"
    #else
         //   return "wss://lobby.kk88819.net"
            return "wss://test-lobby.kkvd88819.com"
    #endif
        }
        static var roomSocketUrl: String {
    #if CNY
            return "wss://room.tg7899.cc"

    #elseif USD
            return "wss://room.tg6666.cc"
    #elseif THB
            return "wss://room.tg8999.cc"
    #elseif KRW
            return "wss://room.tg6789.cc"
            
    #else
      //      return "wss://room.kk88819.net"
            return "wss://test-room.kkvd88819.com"
        
    #endif
        }
        
    }
    static let baseUrlStr = BaseUrl.appUrl
    static let baseUrlWebSocketRoom = BaseUrl.roomSocketUrl
    static let baseUrlWebSocketLobby = BaseUrl.lobbySocketUrl
    struct APPURL {
        static let endpoint = URL(string: Constants.baseUrlStr + "/game/api/v1")!
    }
    struct SOCKETURLLOBBY {
        static let endpoint = URL(string: Constants.baseUrlWebSocketLobby + "/ws/lobby")!
    }
    struct SOCKETURLROOM {
        static let endpoint = URL(string: Constants.baseUrlWebSocketRoom + "/ws/room")!
    }
    struct AlertMessages {
        static let NoDataFound = "No Data Found."
        static let InternetError = "Check internet connection."
    }
    struct FontNames {
        static let LatoName = "Lato"
        struct Lato {
            static let LatoBold = "Lato-Bold"
            static let LatoMedium = "Lato-Medium"
            static let LatoRegular = "Lato-Regular"
            static let LatoExtraBold = "Lato-ExtraBold"
        }
    }
    
    struct Key {
        static let DeviceType = "iOS"
        
        struct Beacon {
            static let ONEXUUID = "xxxx-xxxx-xxxx-xxxx"
        }
        
        struct UserDefaults {
            static let kAppRunningFirstTime = "userRunningAppFirstTime"
        }
        
        struct Headers {
            static let Authorization = "Authorization"
            static let ContentType = "Content-Type"
        }
        
        struct Google {
            static let placesKey = "some key here"
            static let serverKey = "some key here"
        }
        
        struct ErrorMessage {
            static let listNotFound = "ERROR_LIST_NOT_FOUND"
            static let validationError = "ERROR_VALIDATION"
        }
    }
}
typealias ChipViewCallBack = (Bool) -> Void
