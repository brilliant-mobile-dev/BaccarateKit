//
//  APiRouter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
import Foundation
import Alamofire

enum LoginApiRouter: URLRequestConvertible {
    // creating cases for each API request
    case getLoginData(userName: String, password: String)
    case getLogOut
    case changePasswordData(oldPassword: String, newPassword: String)
    case getGuestLoginData
    case getLanguageData
    case getLanguageSourceData
    case getTakeWashableMoney
    case getLogo
    case getSysConfigApp
   
    // specifying the endpoints for each API
    var path: String {
        switch self {
            // when you need to pass a parameter to the endpoint
        case .getLoginData: // we can paas model as parameter
            return "/common/login"
        case .getLogOut:
            return "/common/logout"
        case .changePasswordData:
            return "/common/resetPassword"
        case .getGuestLoginData:
            return "/common/login/tourists"
        case .getLanguageData:
            return "/common/languages"
        case .getTakeWashableMoney:
            return "/common/takeWashCodeMoney"
        case .getLanguageSourceData:
            return "/common/mobileFullSource"
        case .getLogo:
            return "/common/getLogo"
        case .getSysConfigApp:
            return "/common/getSysConfigApp"
        }
    }
    // specifying the methods for each API
    var method: HTTPMethod {
        switch self {
        case .getLoginData:
            return .post
        case .getLogOut:
            return .post
        case .changePasswordData:
            return .post
        case .getGuestLoginData:
            return .post
        case .getLanguageData:
            return .get
        case .getTakeWashableMoney:
            return .get
        case .getLanguageSourceData:
            return .get
        case .getLogo:
            return .get
        case .getSysConfigApp:
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
            case .getLoginData(let userName, let password):
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.headers.add(name: "Language", value: code)
                request.headers.add(name: "User-Agent", value: "iOS")
                parameters["username"] = userName
                parameters["password"] = password
                
            case .getLogOut:
                request.setHeader()
            case .changePasswordData(oldPassword: let oldPassword, newPassword: let newPassword):
                parameters["oldPwd"] = oldPassword
                parameters["newPwd"] = newPassword
                parameters["newPwd2"] = newPassword
                request.setHeader()
            case .getGuestLoginData:
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.headers.add(name: "Language", value: code)
            case .getLanguageData:
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.headers.add(name: "Language", value: code)
            case .getTakeWashableMoney:
                request.setHeader()
            case .getLanguageSourceData:
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.headers.add(name: "Language", value: code)
            case .getLogo:
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.headers.add(name: "Language", value: code)
                
            case .getSysConfigApp:
                var code = "en"
                let selectedCode = Session.shared.getLanguangeCode()
                if !selectedCode.isEmpty {
                    code = selectedCode
                }
                request.setHeader()
                request.headers.add(name: "Language", value: code)
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
           
            request = try encoding.encode(request, with: parameters)
            return request
        }
}

