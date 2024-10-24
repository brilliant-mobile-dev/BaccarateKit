//
//  GameRoomApiRouter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 6/9/23.
//
// http://gateway.fxdd6678.cc/game-server/game/api/v1/room/getTableBetInfo?groupNo=1-101-939-2

import Foundation
import Alamofire

enum GameRoomApiRouter: URLRequestConvertible {
    // creating cases for each API request
    case getTableInfoData(data: CasinoTableData)
    case getTableGroupData(data: CasinoTableData)
    case getTableBetInfo(groupNo: String)
    case leaveTableGroup(groupNo: String)
    case setFreeStatus(groupNo: String, freeStatus: String)
    case setBetData(betData: BetData)
    case saveChips(chipsList: String)
    case getRuleImage
    // specifying the endpoints for each API
    var path: String {
        switch self {
            // when you need to pass a parameter to the endpoint
        case .getTableInfoData: // we can paas model as parameter
            return "/room/getGameTableInfo"
        case .getTableGroupData:
            return "/room/enterTableGroup"
        case .getTableBetInfo:
            return "/room/getTableBetInfo"
        case .leaveTableGroup:
            return "/room/leaveTableGroup"
        case .setFreeStatus:
            return "/room/bac/change/freeStatus"
        case .setBetData:
            return "/room/bac/bet"
        case .saveChips:
            return "/common/saveChips"
        case .getRuleImage:
            return "/common/getRuleImage"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getTableInfoData:
            return .get
        case .getTableGroupData:
            return .get
        case .getTableBetInfo:
            return .get
        case .leaveTableGroup:
            return .post
        case .setFreeStatus:
            return .post
        case .setBetData:
            return .post
        case .saveChips:
            return .post
        case .getRuleImage:
            return .get
        }
    }
    var encoding: URLEncoding {
        switch self {
        case .setBetData:
            return .default
        default:
            return .default
        }
    }
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Constants.APPURL.endpoint.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        var parameters = Parameters()
        switch self {
        case .getTableInfoData(let data):
            parameters["gameId"] = gameIdG
            parameters["placeId"] = placeIdG
            parameters["tableNo"] = data.tableNo ?? ""
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request = try encoding.encode(request, with: parameters)
        case .getTableGroupData(data: let data):
            parameters["gameId"] = gameIdG
            parameters["placeId"] = placeIdG
            parameters["tableNo"] = data.tableNo ?? ""
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request = try encoding.encode(request, with: parameters)
        case .getTableBetInfo(groupNo: let groupNo):
            parameters["groupNo"] = groupNo
            request = try encoding.encode(request, with: parameters)
        case .leaveTableGroup(groupNo: let groupNo):
            parameters["groupNo"] = groupNo
            request = try encoding.encode(request, with: parameters)
        case .setFreeStatus(groupNo: let groupNo, freeStatus: let freeStatus):
            parameters["freeStatus"] = freeStatus
            parameters["groupNo"] = groupNo
            request = try encoding.encode(request, with: parameters)
        case .setBetData(betData: let betData):
            parameters["bootNo"] = betData.boothNum
            parameters["currency"] = betData.currency
            parameters["freeStatus"] = betData.freeStatus
            parameters["groupNo"] = betData.groupNum
            parameters["roundNo"] = betData.roundNo
            parameters["betDetailList"] = betData.arrCoinsValue
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .saveChips(chipsList: let chipsList):
            parameters["chipsList"] = chipsList
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request = try encoding.encode(request, with: parameters)
        case .getRuleImage:
            parameters["gameId"] = gameIdG
        }
        request.setHeader()
        //  request.setCommonParams(parameters: &parameters)
        return request
    }
}
