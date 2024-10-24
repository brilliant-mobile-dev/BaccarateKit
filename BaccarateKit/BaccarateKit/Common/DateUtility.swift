//
//  DateUtility.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 07/09/23.
//

import Foundation

class DateUtility {
    static let shared = DateUtility()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getCurrentDate() -> String {
        return dateFormatter.string(from: Date())
    }
    func convertDateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    func convertStringToDate(string: String) -> Date {
        return dateFormatter.date(from: string)!
    }
}
