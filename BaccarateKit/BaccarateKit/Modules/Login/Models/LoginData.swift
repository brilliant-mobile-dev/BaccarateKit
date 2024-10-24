//
//  LoginData.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import Foundation

// MARK: - LoginData
struct LoginData: Codable {
    let datas: DataResponse?
    let respCode: Int
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - Datas
struct DataResponse: Codable {
    let accessToken: String?
}
// MARK: - LanguageModel
struct LanguageResponse: Codable {
    let datas: [LanguageData]?
    let respCode: Int?
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - LanguageData Model
class LanguageData: Codable {
    let code: String?
    let icon: String?
    var isSelected: Bool?
    let name: String?
}

// MARK: - // MARK: - Language Mobile Source Data Model
struct LanguageSourceResponse: Codable {
    let respMsg: String?
    let respCode: Int
    let datas: [LanguageSourceData]?

    enum CodingKeys: String, CodingKey {
        case respMsg = "resp_msg"
        case respCode = "resp_code"
        case datas
    }
}

// MARK: - DataElement
struct LanguageSourceData: Codable {
    let languageKey: String
    let languageData: [String: String]
}

struct ResponeData: Codable {
    let datas: String?
    let respCode: Int
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

struct LogoResponseData: Codable {
    let datas: [LogoData]?
    let respCode: Int
    let respMsg: String?
    enum CodingKeys: String, CodingKey {
        case datas
        case respMsg
        case respCode = "resp_code"
    }
}

// MARK: - DataElement
struct LogoData: Codable {
    let id, location: Int
    let url: String?
}
struct AppStoreData: Codable {
    let datas: [AppData]
    let respCode: Int

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
    }
}

// MARK: - DataElement
struct AppData: Codable {
    let id: Int
    let createTime, updateTime, createBy, updateBy: String
    let device: String
    let url: String
    let versionName, version: String
    let remark: String?
}

