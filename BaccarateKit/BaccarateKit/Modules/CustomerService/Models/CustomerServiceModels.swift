//
//  CustomerServiceModels.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 7/10/23.
//

import Foundation
// MARK: - Welcome
struct CustomerServiceResponse: Codable {
    let datas: [CustomerServiceData]?
    let respCode: Int?
    let respMsg: String?

    enum CodingKeys: String, CodingKey {
        case datas
        case respCode = "resp_code"
        case respMsg = "resp_msg"
    }
}

// MARK: - DataElement
struct CustomerServiceData: Codable {
    let customerChannel, account: String?
    let urlPC, urlApp: String?
    let urlContacAddress: String?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case customerChannel, account
        case urlPC = "urlPc"
        case urlApp
        case urlContacAddress
    }
}
