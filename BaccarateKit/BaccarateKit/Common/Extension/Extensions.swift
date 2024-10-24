//
//  Extensions.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import UIKit
import Foundation
import Alamofire
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    convenience init(hex: String, alpha: CGFloat) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
// MARK: UIViewController Extensions
extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok".localizable, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
extension String {
    var localizable: String {
        return localized(code: Session.shared.getLanguangeCode())
    }

    private func localized(code: String = "zh") -> String {
        guard let selectedlangData = ConfigurationDataManager.shared.languageSourceDataArr?.first(where: {$0.languageKey == code}) else {
            return self
        }
        return selectedlangData.languageData[self] ?? self
    }
    var camelCaseToWords: String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
            ? $0 + " " + String($1)
            : $0 + String($1)
        }
    }
    
    func removeWhitespace() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}
extension String {
    func currentUTCTimeDate() -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.timeZone = TimeZone(identifier: "UTC")
        fromFormatter.dateFormat = "yyyy-MM-dd+HH:mm:ss"
        let fromDate = fromFormatter.date(from: self)
        
        let toFormatter = DateFormatter()
        toFormatter.timeZone = TimeZone(identifier: "UTC")
        toFormatter.dateFormat = "yyyy-MM-dd"
        
        return toFormatter.string(from: fromDate!)
    }
}
extension Date {
    func currentUTCTimeDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone(identifier: "UTC")
        dtf.dateFormat = "yyyy-MM-dd"
        return dtf.string(from: self)
    }
    func getPreviousWeekStartDay() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from:
        gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: -7, to: sunday!)!
    }
        var startOfWeek: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            
            return gregorian.date(byAdding: .day, value: 1, to: sunday)
        }

        var endOfWeek: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 7, to: sunday)
        }
//    func currentUTCTimeDate() -> String {
//        let dtf = DateFormatter()
//        dtf.timeZone = TimeZone(identifier: "UTC")
//        dtf.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        return dtf.string(from: self)
//    }
}
extension Double {
    var afterDecimal2Digit: String {
        return String(format: "%.2f", self)
    }
    var afterDecimal2DigitNoZero: String {
            return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    var walletAmount: String {
     //   let balanceValue = 14098.6553455
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self )) {
            return formattedNumber
        }
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension URLRequest {
    mutating func setHeader() {
        if let accessToken = Datamanager.shared.accessToken, Datamanager.shared.isUserAuthenticated {
            let bearerToken = "Bearer \(accessToken)"
            self.headers.add(name: "Authorization", value: bearerToken)
        }
        var code = "en"
        let selectedCode = Session.shared.getLanguangeCode()
         if !selectedCode.isEmpty {
             code = selectedCode
         }
        self.headers.add(name: "Language", value: code)
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        print("self.headers ==>",  self.headers)
    }
    mutating func setCommonParams(parameters: inout Parameters) {
     //   let token = ConfigurationDataManager.shared.userToken ?? ""
        parameters["lang_id"] = BaccaratLivelanguage.code
        parameters["cur_id"] = "1"
        parameters["v"] =  "v" + appVersion
        parameters["database_connection"] = BaccaratUser.database
    }
}
extension NSLayoutConstraint {
    static func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem!,
                                               attribute: constraint.firstAttribute,
                                               relatedBy: constraint.relation,
                                               toItem: constraint.secondItem,
                                               attribute: constraint.secondAttribute,
                                               multiplier: multiplier,
                                               constant: constraint.constant)
        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier
        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }
}
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}
extension Locale {
    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}
