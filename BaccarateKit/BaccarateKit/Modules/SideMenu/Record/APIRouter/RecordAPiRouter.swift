//
//  RecordAPiRouter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 12/9/23.
//
import Foundation
import Alamofire
enum RecordApiRouter: URLRequestConvertible {
    // creating cases for each API request
    case getRecordList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    case getMoneyChangeList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    case getWashCodeList(pageSize: Int, currentPage: Int, startDate: String, endDate: String)
    case getRecordDetail(data: PageResultData)
    // specifying the endpoints for each API
    var path: String {
        switch self {
            // when you need to pass a parameter to the endpoint
        case .getRecordList: // we can paas model as parameter
            return "/common/findBetList"
        case .getMoneyChangeList: // we can paas model as parameter
            return "/common/findMoneyChangeList"
        case .getWashCodeList: // we can paas model as parameter
            return "/common/findWashCodeList"
        case .getRecordDetail: // we can paas model as parameter
            return "/common/findBetDetail"
        }
    }
    
    // specifying the methods for each API
    var method: HTTPMethod {
        switch self {
        case .getRecordList:
            return .get
        case .getMoneyChangeList:
            return .get
        case .getWashCodeList:
            return .get
        case .getRecordDetail:
            return .get
        }
    }
    var encoding: URLEncoding {
        switch self {
        default:
            return .default
        }
    }
    
    // this function will return the request for the API call, for POST calls the body or additional headers can be added here
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Constants.APPURL.endpoint.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        var parameters = Parameters()
        switch self {
        case .getRecordList(pageSize: let pageSize, currentPage: let currPage, startDate: let startDate, endDate: let endDate):
            let baseStr = Constants.APPURL.endpoint.appendingPathComponent(path).absoluteString
            let path1 = "?pageSize=\(pageSize)&currPage=\(currPage)&startDate=\(startDate)&endDate=\(endDate)"
            let path2 = baseStr + path1
            request = URLRequest(url: URL(string: path2)!)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        case .getMoneyChangeList(pageSize: let pageSize, currentPage: let currPage, startDate: let startDate, endDate: let endDate):
            let baseStr = Constants.APPURL.endpoint.appendingPathComponent(path).absoluteString
            let path1 = "?pageSize=\(pageSize)&currPage=\(currPage)&startDate=\(startDate)&endDate=\(endDate)"
            let path2 = baseStr + path1
            request = URLRequest(url: URL(string: path2)!)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        case .getWashCodeList(pageSize: let pageSize, currentPage: let currPage, startDate: let startDate, endDate: let endDate):
            let baseStr = Constants.APPURL.endpoint.appendingPathComponent(path).absoluteString
            let path1 = "?pageSize=\(pageSize)&currPage=\(currPage)&startDate=\(startDate)&endDate=\(endDate)"
            let path2 = baseStr + path1
            request = URLRequest(url: URL(string: path2)!)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        case .getRecordDetail(data: let data):
            parameters["bootNo"] = data.bootNo ?? ""
            parameters["gameId"] = data.gameID ?? ""
            parameters["roundNo"] = data.roundNo ?? ""
            parameters["tableNo"] = data.tableNo ?? ""
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request = try encoding.encode(request, with: parameters)
        }
        request.setHeader()
        return request
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
