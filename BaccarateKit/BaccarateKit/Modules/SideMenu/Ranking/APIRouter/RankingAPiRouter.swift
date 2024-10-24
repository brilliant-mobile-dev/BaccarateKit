//
//  RankingAPiRouter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//

import Foundation
import Alamofire

enum RankingAPiRouter: URLRequestConvertible {
    // MARK: Write Cases for all list
    case getRichTop10List
    case getWinTop10List
    case getBetTop10List
    // specifying the endpoints for each API
    var path: String {
        switch self {
        case .getRichTop10List:
            return "/common/getRichTop10"
            
        case .getWinTop10List:
            return "/common/getWinTop10"
            
        case .getBetTop10List:
            return "/common/getBetTop10"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRichTop10List:
            return .get
        case .getWinTop10List:
            return .get
        case .getBetTop10List:
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
        let parameters = Parameters()
        switch self {
        case .getRichTop10List:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
            
        case .getWinTop10List:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
            
        case .getBetTop10List:
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setHeader()
        }
        request = try encoding.encode(request, with: parameters)
        return request
    }
}
