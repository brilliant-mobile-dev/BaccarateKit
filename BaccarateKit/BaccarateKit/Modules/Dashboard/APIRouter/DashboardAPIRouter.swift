//
//  DashboardAPIRouter.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import Foundation
import Alamofire

enum DashboardAPIRouter: URLRequestConvertible {
    // MARK: Write Cases for all list
    case getGameRoomList(gameId: Int, placeId: Int)
    case getUserInfo
    case getNoticeInfo
    case getOnlineNumber
    case getCustomerList
    case getPlaceList(gameID: Int)
    case getGameList
    // specifying the endpoints for each API
    var path: String {
        switch self {
        case .getGameRoomList:
            return "/lobby/getGameTableList"
        case .getUserInfo:
            return "/common/getUserInfo"
        case .getNoticeInfo:
            return "/lobby/getNoticeList"
        case .getOnlineNumber:
            return "common/getOnlineNum"
        case .getCustomerList:
            return "/lobby/getCustomerList"
        case .getGameList:
            return "/lobby/getGameList"
        case .getPlaceList:
            return "/lobby/getPlaceList"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getGameRoomList:
            return .get
        case .getUserInfo:
            return .get
        case .getNoticeInfo:
            return .get
        case .getOnlineNumber:
            return .get
        case .getCustomerList:
            return .get
      //  case .getPlaceList:
       //     return .get
        case .getGameList:
            return .get
        case .getPlaceList:
            return .get
        }
    }
    
    var encoding: URLEncoding {
        switch self {
        default:
            return .default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Constants.APPURL.endpoint.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        var parameters = Parameters()
        switch self {
        case .getGameRoomList(let gameId, let placeId):
            parameters["gameId"] = gameId
            parameters["placeId"] = placeId
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        case .getUserInfo:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        case .getNoticeInfo:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        case .getOnlineNumber:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        case .getCustomerList:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
//        case .getPlaceList(let gameID):
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.setHeader()
        case .getGameList:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        case .getPlaceList(gameID: let gameID):
            parameters["gameId"] = gameID
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        }
        request = try encoding.encode(request, with: parameters)
        return request
    }
}
