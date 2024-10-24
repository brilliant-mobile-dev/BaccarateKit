//
//  LoginProtocols.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import Foundation

protocol LoginUI {
    func loginSucess (_ loginData: LoginData)
    func logOutSucess (_ data: ResponeData)
    func languageDataSucess (_ data: LanguageResponse)
    func languageSourceDataSucess (_ data: LanguageSourceResponse)
    func changePasswordSucess (_ data: LoginData)
    func takeWashableSucess (_ data: LoginData)
    func foundError (_ error: BackendError)
    func logoSuccess (_ loginData: LogoResponseData)
    func getSysConfigAppSuccess(appData: AppStoreData)
}
protocol LoginUIInterface {
    func handleLogin(_ userName: String, _ password: String)
    func handleGuestLogin()
    func getLanguageData()
    func getSourceLanguageData()
    func handleLogout()
    func changePasswordData(oldPassword: String, newPassword: String)
    func takeWashableMoney()
    func getLogoData()
    func getSysConfigApp()
}
protocol UpdatePreviousVCData {
    func updatePreviousVC(data: Any)
}
protocol LoginDismissDelegate: AnyObject {
    func loginDismissed()
}

extension LoginUI {
    func getSysConfigAppSuccess(appData: AppStoreData) {
        
    }
    func loginSucess (_ loginData: LoginData) {
        
    }
    func logOutSucess (_ data: ResponeData) {
        
    }
    func changePasswordSucess (_ data: LoginData) {
        
    }
    func foundError (_ error: BackendError) {
        
    }
    func languageDataSucess (_ data: LanguageResponse) {
        
    }
    func takeWashableSucess (_ data: LoginData) {
        
    }
    func languageSourceDataSucess (_ data: LanguageSourceResponse) {
        
    }
    func logoSuccess (_ loginData: LogoResponseData) {
        
    }
}

