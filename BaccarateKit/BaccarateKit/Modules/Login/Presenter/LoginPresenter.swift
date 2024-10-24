//
//  LoginPresenter.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//

import UIKit

struct LoginPresenter: LoginUIInterface {
    fileprivate var ui: LoginUI?
    fileprivate var wireframe: ProjectWireframe?
    
    init (ui: LoginUI, wireframe: ProjectWireframe) {
        self.ui = ui
        self.wireframe = wireframe
    }
    func handleLogin(_ userName: String, _ password: String) {
        RestApi.fetchData(urlRequest: LoginApiRouter.getLoginData(userName: userName, password: password)) { (loginData: LoginData) in
            if loginData.respCode ==  0 {
                self.ui?.loginSucess(loginData)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = loginData.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func handleGuestLogin() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getGuestLoginData) { (loginData: LoginData) in
            if loginData.respCode ==  0 {
                self.ui?.loginSucess(loginData)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = loginData.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func handleLogout() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getLogOut) { (data: ResponeData) in
            if data.respCode ==  0 {
                self.ui?.logOutSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func changePasswordData(oldPassword: String, newPassword: String) {
        RestApi.fetchData(urlRequest: LoginApiRouter.changePasswordData(oldPassword: oldPassword, newPassword: newPassword)) { (loginData: LoginData) in
            if loginData.respCode ==  0 {
                self.ui?.changePasswordSucess(loginData)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = loginData.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getLanguageData() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getLanguageData) { (data: LanguageResponse) in
            if data.respCode ==  0 {
                ConfigurationDataManager.shared.languageDataArr = data.datas ?? [LanguageData]()
                for item in (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()) {
                    item.isSelected = false
                }
                let lang = Session.shared.getLanguangeCode()
                if let index = (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()).firstIndex(where: {$0.code == lang}) {
                    (ConfigurationDataManager.shared.languageDataArr![index].isSelected) = true
                }
                if let selectedlangData = (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()).first(where: {$0.code == BaccaratLivelanguage.code}) {
                    BaccaratLivelanguage.iconUrl = selectedlangData.icon ?? BaccaratLivelanguage.iconUrl
                    BaccaratLivelanguage.code = selectedlangData.code ?? BaccaratLivelanguage.code
                    BaccaratLivelanguage.name = selectedlangData.name ?? BaccaratLivelanguage.name
                }
                self.ui?.languageDataSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getSourceLanguageData() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getLanguageSourceData) { (data: LanguageSourceResponse) in
            if data.respCode ==  0 {
                ConfigurationDataManager.shared.languageSourceDataArr = data.datas ?? [LanguageSourceData]()
                ConfigurationDataManager.shared.cachelanguageSource = "server"
                self.ui?.languageSourceDataSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getSysConfigApp() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getSysConfigApp) { (data: AppStoreData) in
            if data.respCode ==  0 {
                self.ui?.getSysConfigAppSuccess(appData: data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = "error"
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func takeWashableMoney() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getTakeWashableMoney) { (data: LoginData) in
            if data.respCode ==  0 {
                self.ui?.takeWashableSucess(data)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = data.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
    func getLogoData() {
        RestApi.fetchData(urlRequest: LoginApiRouter.getLogo) { (logoData: LogoResponseData) in
            if logoData.respCode ==  0 {
                if let logo = logoData.datas?.first(where: {$0.location == 1}) {
                    ConfigurationDataManager.shared.logoData = logo
                }
                self.ui?.logoSuccess(logoData)
            } else {
                var objError = BackendError()
                objError.errorCode = -1
                objError.errorDescription = logoData.respMsg ?? ""
                self.ui?.foundError(objError)
            }
        } failure: { backendError in
            self.ui?.foundError(backendError)
        }
    }
}

