//
//  Utils.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
// 

import Foundation
import UIKit
import Alamofire
import AudioToolbox
// swiftlint:disable type_body_length file_length
class Utils {
    static var modifiedStack = [CasinoChip]()
    static let windowKey = UIApplication.shared.keyWindow
    static let story = UIStoryboard(name: "Main", bundle: nil)
    static func vibrateDevice() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    static func timeFormatted(_ totalSeconds: Int) -> String {
     //   let seconds: Int = totalSeconds % 60
        let time = String(format: "%d", totalSeconds)
        var timer = time
        if time.count == 1 {
            timer = "0" + time
        }
        return timer
    }
    // Check App Version
    static func checkAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let appBuildNum = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0"
        let version = appVersion + "(\(appBuildNum))"
        return version
    }
    
    static func getDateWithFormate(dateString: String, formate: String = "yyyy-MM-dd") -> String {
        var  outputDate: String = ""
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = formate
            dateFormatter.locale = tempLocale // reset the locale
            outputDate = dateFormatter.string(from: date)
            return outputDate
        }
        return ""
    }
    static func isValidPassword(enteredPassword: String) -> Bool {
        let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if enteredPassword.rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }
        return true
    }
    
    static func showLoginVC(vc: UIViewController) {
        Datamanager.shared.isUserAuthenticated = false
        Datamanager.shared.accessToken = ""
        ConfigurationDataManager.shared.userInfo = nil
        AudioManager.soundQueue.removeAll()
        AudioManager.stopSound()
        if !(currentVC is LoginVC) {
            if let destVC = Utils.story.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                destVC.modalPresentationStyle = .overFullScreen
                destVC.delegate = vc as? any LoginDismissDelegate
                vc.present(destVC, animated: true)
            }
        }
    }
    static func showLoginVCForExpireToken(vc: UIViewController) {
        ConfigurationDataManager.shared.cachelanguageSource = "local"
        Datamanager.shared.isUserAuthenticated = false
        Datamanager.shared.accessToken = ""
        ConfigurationDataManager.shared.userInfo = nil
        AudioManager.soundQueue.removeAll()
        AudioManager.stopSound()
        if !(currentVC is LoginVC) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let rootViewController = window?.rootViewController as? UINavigationController {
            if let lastVCRoot = rootViewController.viewControllers.last, let firstVCRoot = rootViewController.viewControllers.first {
                lastVCRoot.navigationController?.popToRootViewController(animated: true)
                if let destVC = Utils.story.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                  //  firstVCRoot.showAlert(withTitle: "Alert".localizable, message: "Token Expired".localizable)
                    destVC.modalPresentationStyle = .overFullScreen
                    destVC.delegate = firstVCRoot as? any LoginDismissDelegate
                    destVC.isTokenExpire = true
                    firstVCRoot.present(destVC, animated: true)
                    
                }
                return
            }
        }
    }
    }
    static func lastVC() -> UIViewController? {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let rootViewController = window?.rootViewController as? UINavigationController {
            if let lastVCRoot = rootViewController.viewControllers.last {
                return lastVCRoot
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    // swiftlint:disable large_tuple
    static func getIconName(result: String) -> (playerName: String, iconname: String, breadPlatIcon: String) {
        var playerTemp = ""
        var iconeTemp = ""
        var breadPlatIcon = ""
        switch result {
        case "1":
            // Player Win
            playerTemp = "P"
            iconeTemp = "players"
            breadPlatIcon = "playerW"
        case "15":
            // Player win with Player Pair
            playerTemp = "P"
            iconeTemp = "playerP"
            breadPlatIcon = "playerPW"
        case "18":
            // Player win with Banker Pair
            playerTemp = "P"
            iconeTemp = "playerB"
            breadPlatIcon = "playerBW"
        case "12":
            // Player win with Player & Banker Pair
            playerTemp = "P"
            iconeTemp = "playerPB"
            breadPlatIcon = "playerPBW"
        case "4":
            // Banker Win
            playerTemp = "B"
            iconeTemp = "bankers"
            breadPlatIcon = "bankerW"
        case "45":
            // Banker win with Player Pair
            playerTemp = "B"
            iconeTemp = "bankerP"
            breadPlatIcon = "bankerPW"
        case "48":
            // Banker win with Banker Pair
            playerTemp = "B"
            iconeTemp = "bankerB"
            breadPlatIcon = "bankerBW"
        case "42":
            // Banker win with Player & Banker Pair
            playerTemp = "B"
            iconeTemp = "bankerPB"
            breadPlatIcon = "bankerPBW"
        case "7":
            // Match Tie
            playerTemp = "T"
            iconeTemp = "tieFirst"
            breadPlatIcon = "tieW"
        case "75":
            // Match Tie with Player Pair
            playerTemp = "T"
            iconeTemp = "tieFirst"
            breadPlatIcon = "tiePW"
        case "78":
            // Match Tie with Banker Pair
            playerTemp = "T"
            iconeTemp = "tieFirst"
            breadPlatIcon = "tieBW"
        case "72":
            // Match Tie with Player Pair & Banker Pair
            playerTemp = "T"
            iconeTemp = "tieFirst"
            breadPlatIcon = "tiePBW"
        default:
            playerTemp = ""
            iconeTemp = ""
        }
        return (playerTemp, iconeTemp, breadPlatIcon)
    }
    static func getImageIconForPredictForbanker(imageIcon: String) -> String {
        var imageIconPlayer = imageIcon
        switch imageIcon {
        case "red":
           // imageIconPlayer = "blue"
            imageIconPlayer = "predictBCircle"
            
        case "redSmall":
           // imageIconPlayer = "blueSmall"
            imageIconPlayer = "predictBFillCircle"
        case "redLine":
           // imageIconPlayer = "blueLine"
            imageIconPlayer = "predictBLine"
        case "blue":
           // imageIconPlayer = "red"
            imageIconPlayer = "predictPCircle"
        case "blueSmall":
            // imageIconPlayer = "redSmall"
            imageIconPlayer = "predictPFillCircle"
        case "blueLine":
           // imageIconPlayer = "redLine"
            imageIconPlayer = "predictPLine"
        case "playerW":
           // imageIconPlayer = "bankerW"
            imageIconPlayer = "predictPFillCircle"
        case "bankerW":
           // imageIconPlayer = "playerW"
            imageIconPlayer = "predictBFillCircle"
        case "bankers":
          //  imageIconPlayer = "players"
            imageIconPlayer = "predictBCircle"
        case "players":
           // imageIconPlayer = "bankers"
            imageIconPlayer = "predictPCircle"
        default:
            imageIconPlayer = imageIcon
        }
        return imageIconPlayer
    }
    static func getImageIconForPredict(imageIcon: String) -> String {
        var imageIconPlayer = imageIcon
        switch imageIcon {
        case "red":
           // imageIconPlayer = "blue"
            imageIconPlayer = "predictPCircle"
            
        case "redSmall":
           // imageIconPlayer = "blueSmall"
            imageIconPlayer = "predictPFillCircle"
        case "redLine":
           // imageIconPlayer = "blueLine"
            imageIconPlayer = "predictPLine"
        case "blue":
           // imageIconPlayer = "red"
            imageIconPlayer = "predictBCircle"
        case "blueSmall":
            // imageIconPlayer = "redSmall"
            imageIconPlayer = "predictBFillCircle"
        case "blueLine":
           // imageIconPlayer = "redLine"
            imageIconPlayer = "predictBLine"
        case "playerW":
           // imageIconPlayer = "bankerW"
            imageIconPlayer = "predictBFillCircle"
        case "bankerW":
           // imageIconPlayer = "playerW"
            imageIconPlayer = "predictPFillCircle"
        case "bankers":
          //  imageIconPlayer = "players"
            imageIconPlayer = "predictPCircle"
        case "players":
           // imageIconPlayer = "bankers"
            imageIconPlayer = "predictBCircle"
        default:
            imageIconPlayer = imageIcon
        }
        return imageIconPlayer
    }
    static func getStatus(statusCode: Int) -> String {
        var statusText = ""
        switch statusCode {
        case 0:
            statusText = "Shuffling".localizable
        case 1:
            statusText = "Opening".localizable
        case 2:
            statusText = "Opening".localizable
        case 4:
            statusText  = "Settlement".localizable
        case -1:
            statusText  = "Settlement".localizable
        default:
            statusText = "Opening".localizable
            //  statusLabel.text = ""
        }
        return statusText
    }
    static func getVoiceByPoints(points: Int) -> Voices {
        var soundVoice = Voices.zeroPoint
        switch points {
        case 0:
            soundVoice = .zeroPoint
        case 1:
            soundVoice = .onePoint
        case 2:
            soundVoice = .twoPoints
        case 3:
            soundVoice  = .threePoints
        case 4:
            soundVoice  = .fourPoints
        case 5:
            soundVoice  = .fivePoints
        case 6:
            soundVoice  = .sixPoints
        case 7:
            soundVoice  = .sevenPoints
        case 8:
            soundVoice  = .eightPoints
        case 9:
            soundVoice  = .ninePoints
        default:
            soundVoice = .zeroPoint
            //  statusLabel.text = ""
        }
        return soundVoice
    }
    static func getDefaultLangCode() -> String {
        let lang =  Locale.preferredLocale().identifier
        var languageCode = lang
        if lang.contains("zh") {
            languageCode = "zh"
        } else if lang.contains("km") {
            languageCode = "kh"
        } else if lang.contains("ko") {
            languageCode = "kr"
        } else if lang.contains("th") {
            languageCode = "th"
        } else if lang.contains("en") {
            languageCode = "en"
        } else {
            if let selectedlangData = (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()).first(where: {$0.code == languageCode}) {
                languageCode = selectedlangData.code ?? "en"
            } else {
                languageCode = "en"
            }
        }
        return languageCode
    }
    static func getDateStringFormat(dateString: String, formate: String = "yyyy-MM-dd") -> String {
        var  outputDate: String = ""
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = formate
            dateFormatter.locale = tempLocale // reset the locale
            outputDate = dateFormatter.string(from: date)
            return outputDate
        }
        return ""
    }
    
    static func getDateStringWithFormate (date: Date, format: String = "yyyy-MM-dd") -> String {
        var  outputDate: String = ""
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        dateFormatter.locale = tempLocale // reset the locale
        outputDate = dateFormatter.string(from: date)
        return outputDate
    }
    static func getDateStringWithFormateUTC (date: Date, format: String = "yyyy-MM-dd") -> String {
        var  outputDate: String = ""
        let dateFormatter = DateFormatter()
        //   dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        //   dateFormatter.locale = tempLocale // reset the locale
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        outputDate = dateFormatter.string(from: date)
        return outputDate
    }
    static func setButtonTitle(btn: UIButton, text: String) {
        btn.setTitle(text, for: .normal)
        btn.setTitle(text, for: .highlighted)
        btn.setTitle(text, for: .selected)
    }
    static func setButtonAttributedTitle(btn: UIButton, text: String) {
        // var fontSize = (Display.typeIsLike == .iphone5) ? 10.0: 12.0
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let titleText = NSAttributedString(string: text,
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.buttonTextColor,
                                                        NSAttributedString.Key.font: UIFont.appFont(family: .medium, size: 12),
                                                        NSAttributedString.Key.paragraphStyle: paragraph])
        
        btn.setAttributedTitle(titleText, for: .selected)
        btn.setAttributedTitle(titleText, for: .normal)
        btn.setAttributedTitle(titleText, for: .highlighted)
        btn.tintColor = .white
    }
    static func setButtonAttributedTitleGameRoom(btn: UIButton, text: String) {
        // var fontSize = (Display.typeIsLike == .iphone5) ? 10.0: 12.0
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let titleText = NSAttributedString(string: text,
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: UIFont.appFont(family: .medium, size: 12),
                                                        NSAttributedString.Key.paragraphStyle: paragraph])
        
        btn.setAttributedTitle(titleText, for: .selected)
        btn.setAttributedTitle(titleText, for: .normal)
        btn.setAttributedTitle(titleText, for: .highlighted)
        btn.tintColor = .white
    }
    static func setCommissionFeeButtonAttributedTitle(btn: UIButton, text: String, userFreeStatus: Bool? = nil, bgImage: UIImageView) {
        let txtColor: UIColor = .lightText
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        btn.setTitle(text, for: .selected)
        btn.setTitle(text, for: .normal)
        btn.setTitle(text, for: .highlighted)
        btn.setTitleColor(txtColor, for: .selected)
        btn.setTitleColor(txtColor, for: .normal)
        btn.setTitleColor(txtColor, for: .highlighted)
        if userFreeStatus == nil {
            bgImage.image = UIImage(named: "lockComm")
        } else if userFreeStatus == true {
            bgImage.image = UIImage(named: "freeComm")
        } else if userFreeStatus == false {
            bgImage.image = UIImage(named: "noComm")
        }
    }
    static func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok".localizable, style: .cancel, handler: nil)
        alert.addAction(action)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    static func jsonToString(json: [String: String]) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: .utf8) // the data will be converted to the string
            return convertedString ?? ""
        } catch _ {
            return ""
        }
    }
    static func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch _ {
            }
        }
        return nil
    }
    class public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    static func saveString(data: String, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getString(key: String) -> String {
        if let stringData = UserDefaults.standard.string(forKey: key) {
            return stringData
        } else {
            return ""
        }
    }
    static func checkChipExistRange(chipValue: Int) -> [CasinoChip] {
        var returnValue: (isExist: Bool, (value: Int, Image: String))!
        switch chipValue {
        case 1:
            returnValue = (isExist: true, (value: 1, Image: "1"))
        case 2..<5:
            returnValue = (isExist: true, (value: 2, Image: "2"))
        case 5..<10:
            returnValue = (isExist: true, (value: 5, Image: "5"))
        case 10..<20:
            returnValue = (isExist: true, (value: 10, Image: "10"))
        case 20..<50:
            returnValue = (isExist: true, (value: 20, Image: "20"))
        case 50..<100:
            returnValue = (isExist: true, (value: 50, Image: "50"))
        case 100..<200:
            returnValue = (isExist: true, (value: 100, Image: "100"))
        case 200..<500:
            returnValue = (isExist: true, (value: 200, Image: "200"))
        case 500..<1000:
            returnValue = (isExist: true, (value: 500, Image: "500"))
        case 1000..<2000:
            returnValue = (isExist: true, (value: 1000, Image: "1k"))
        case 2000..<5000:
            returnValue = (isExist: true, (value: 2000, Image: "2k"))
        case 5000..<10000:
            returnValue = (isExist: true, (value: 5000, Image: "5k"))
        case 10000..<20000:
            returnValue = (isExist: true, (value: 10000, Image: "10k"))
        case 20000..<50000:
            returnValue = (isExist: true, (value: 20000, Image: "20k"))
        case 50000..<100000:
            returnValue = (isExist: true, (value: 50000, Image: "50k"))
        case 100000..<200000:
            returnValue = (isExist: true, (value: 100000, Image: "100k"))
        case 200000..<1000000:
            returnValue = (isExist: true, (value: 200000, Image: "200k"))
        case 1000000..<5000000:
            returnValue = (isExist: true, (value: 1000000, Image: "1m"))
        case 5000000..<10000000:
            returnValue = (isExist: true, (value: 5000000, Image: "5m"))
        case 10000000..<20000000:
            returnValue = (isExist: true, (value: 10000000, Image: "10m"))
        case 20000000..<50000000:
            returnValue = (isExist: true, (value: 20000000, Image: "20m"))
        case 50000000..<100000000:
            returnValue = (isExist: true, (value: 50000000, Image: "50m"))
        case 100000000..<200000000:
            returnValue = (isExist: true, (value: 100000000, Image: "100m"))
        case 200000000..<500000000:
            returnValue = (isExist: true, (value: 200000000, Image: "200m"))
        case 500000000..<1000000000:
            returnValue = (isExist: true, (value: 500000000, Image: "500m"))
        case 1000000000..<5000000000:
            returnValue = (isExist: true, (value: 1000000000, Image: "1b"))
        case 5000000000:
            returnValue = (isExist: true, (value: 100000, Image: "5b"))
        case 0:
            returnValue = (isExist: false, (value: 0, Image: "0"))
        default:
            returnValue = (isExist: false, (value: 0, Image: "0"))
        }
        if returnValue.0 == true {
            let chip = CasinoChip(image: UIImage(named: "icon_chips_" + returnValue.1.Image),
                                  slandingImage: UIImage(named: "icon_chips_s_" + returnValue.1.Image),
                                  value: returnValue.1.value)
            self.modifiedStack.append(chip)
            let value = returnValue.1.value
            // Loop until there is no duplicate
            _ = Utils.checkChipExistRange(chipValue: chipValue - value)
            
        }
        return self.modifiedStack
        
    }
}
class Session {
    static let shared = Session()
    private let selectedLanguage = "languageKey"
    private let selectedLanguageName = "languageNameKey"
    private let selectedLanguageId = "languageId"
    private let selectedLanguageIcon = "languageIcon"
    private let loginToken = "token"
    private let loginUserID = "userid"
    private let languageSource = "mobileFullSource"
    private var defaults: UserDefaults {
        UserDefaults.standard
    }
    func setLanguageSource(sourceData: String) {
        defaults.set(sourceData, forKey: languageSource)
    }
    func getLanguageSource() -> String {
        guard let languageSource = defaults.object(forKey: languageSource) as? String else {
            return ""
        }
        return languageSource
    }
    func setLanguage(code language: String, name: String, id: String, iconUrl: String) {
        BaccaratLivelanguage.codeISO = language
        let languageTemp = language
        BaccaratLivelanguage.code = languageTemp
        BaccaratLivelanguage.name = name
        BaccaratLivelanguage.iconUrl = iconUrl
        if languageTemp.contains("zh-Hans") {
            BaccaratLivelanguage.codeISO = "zh"
        } else if languageTemp.contains("ko") {
            BaccaratLivelanguage.codeISO = "kr"
        } else if languageTemp.contains("km") {
            BaccaratLivelanguage.codeISO = "kh"
        }
        defaults.set(languageTemp, forKey: selectedLanguage)
        defaults.set(name, forKey: selectedLanguageName)
        defaults.set(id, forKey: selectedLanguageId)
        defaults.set(iconUrl, forKey: selectedLanguageIcon)
        defaults.synchronize()
    }
    
    func getLanguangeCode() -> String {
        guard let languageCode = defaults.object(forKey: selectedLanguage) as? String else {
            return ""
        }
        return languageCode
    }
    
    func getLanguangeName() -> String {
        guard let languageName = defaults.object(forKey: selectedLanguageName) as? String else {
            return ""
        }
        return languageName
    }
    
    func getLanguangeId() -> String {
        guard let languageName = defaults.object(forKey: selectedLanguageId) as? String else {
            return ""
        }
        return languageName
    }
    func getLanguangeIcon() -> String {
        guard let languageIcon = defaults.object(forKey: selectedLanguageIcon) as? String else {
            return ""
        }
        return languageIcon
    }
}

class Debuger {
    
    static let shared = Debuger()
    
    func debugerResult(urlRequest: URLRequestConvertible, data: Data, error: Bool) {
        
        let url = urlRequest.urlRequest?.url!
        let strurl = url!.absoluteString
        let allHeaders = urlRequest.urlRequest.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        let body =  urlRequest.urlRequest.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let result = """
              ⚡️⚡️⚡️⚡️ Headers: \(allHeaders)
              ⚡️⚡️⚡️⚡️ Request Body: \(body)
        """
        //  #if DEBUG
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                if let arrayObject = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                    self.formatArrayAnyObject(json: arrayObject, url: strurl, error: error)
                }
                return
            }
            self.formatDictionay(json: json, url: strurl, error: error)
        } catch {}
        //  #endif
    }
    
    private func printerFormat(url: String, data: String, error: Bool) {
        let printer = """
        URL -->: \(url)
        Response Received -->: \(data)
        """
        
        if error {
            print("❌❌❌❌ \(printer) ❌❌❌❌")
        } else {
            print("✅✅✅✅ \(printer) ✅✅✅✅")
        }
    }
    
    private func formatArrayAnyObject(json: [AnyObject], url: String, error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
        let data = "\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? NSString())"
        self.printerFormat(url: url, data: data, error: error)
    }
    
    private func formatDictionay(json: [String: AnyObject], url: String, error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
        let data = "\(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? NSString())"
        self.printerFormat(url: url, data: data, error: error)
    }
}

// UserType Enum

enum UserType {
    case player
    case banker
    case noOne
}

class UserPreference {
    private let isDarkMode = "isDarkMode"
    static let shared = UserPreference()
    private var defaults: UserDefaults {
        UserDefaults.standard
    }
    func getIsDarkMode() -> Bool {
        guard let isDarkMode = defaults.object(forKey: isDarkMode) as? Bool else {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
              //  self.setIsDarkMode(set: true)
                return true
            } else {
             //   self.setIsDarkMode(set: false)
                return false
            }
        }
        return isDarkMode
    }
    
    func setIsDarkMode(set: Bool) {
        defaults.set(set, forKey: isDarkMode)
    }
    
}
