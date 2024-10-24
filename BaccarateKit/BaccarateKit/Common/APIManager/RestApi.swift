//
//  RestApi.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import Foundation
import Alamofire

struct BackendError {
    var errorCode: Int? // If you are giving UI error with this model please give error code -1
    var errorDescription: String = "Something went wrong".localizable
}

class RestApi: NSObject {
    // swiftlint:disable:next line_length cyclomatic_complexity large_tuple function_body_length
    static func fetchData<T: Decodable>(urlRequest: URLRequestConvertible,
                                        success: @escaping (T) -> Void,
                                        failure: @escaping (_ backendError: BackendError) -> Void) {
        
        if NetworkMonitor.shared.isConnected {
            let url = urlRequest.urlRequest?.url!
            Indicator.shared.showIndictorView(indicatoreTitle: "")
            AF.request(urlRequest).responseDecodable(of: T.self) { response in
                Indicator.shared.hideIndictorView()
                let statusCode = response.response?.statusCode
               // print("statusCode ==", statusCode)
                if statusCode != nil && statusCode == 500 {
                    print("Show Alert ==", statusCode)
                    Indicator.shared.hideIndictorView()
                    failure(BackendError(errorCode: 13, errorDescription: "Server error".localizable))
                    return
                  //  Utils.showAlert(withTitle: "Server error".localizable, message: "No data".localizable)
                 //   return
                }
                switch response.result {
                case .success(let data):
#if DEBUG
                    if let newData = response.data {
                        if url!.absoluteString.contains("mobileFullSource") {
                            if let strJson = String(data: newData, encoding: .utf8) {
                                Session.shared.setLanguageSource(sourceData: strJson)
                            }
                        }
                        Debuger.shared.debugerResult(urlRequest: urlRequest, data: newData, error: false)
                    }
#endif
                    switch statusCode {
                    case 401:
                        if let vc = currentVC, !(vc is LoginVC) {
                            failure(BackendError(errorCode: 401, errorDescription: "Session expired!"))
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let topMostViewController = window?.rootViewController
                            var topController = window?.rootViewController
                            var neddtoDismissVC1 = false
                            var neddtoDismissVC2 = false
                            while let presentedViewController = topController?.presentedViewController {
                                   topController = presentedViewController
                                if let rootViewController = topController as? UINavigationController {
                                    if let lastVC = rootViewController.viewControllers.last as? RecordsVC {
                                        neddtoDismissVC1 = true
                                    }
                                } else {
                                    if topController is ShuffleVC {
                                        neddtoDismissVC2 = true

                                    }
                                }
                              }
                            if vc is RecordDetailVC || (neddtoDismissVC1 == true && neddtoDismissVC2 == true) {
                                vc.dismiss(animated: false) {
                                    if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                        presentedViewController.dismiss(animated: false) {
                                            Utils.showLoginVCForExpireToken(vc: vc)
                                        }
                                    }
                                   //
                                }
                                return
                            }
                            if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                presentedViewController.dismiss(animated: false) {
                                    Utils.showLoginVCForExpireToken(vc: vc)
                                }
                                
                            } else {
                                Utils.showLoginVCForExpireToken(vc: vc)
                            }
                        }
                    case 444:
                        if let vc = currentVC, !(vc is LoginVC) {
                            failure(BackendError(errorCode: 401, errorDescription: "Session expired!"))
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let topMostViewController = window?.rootViewController
                            if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                presentedViewController.dismiss(animated: false) {
                                    Utils.showLoginVCForExpireToken(vc: vc)
                                }
                            } else {
                                Utils.showLoginVCForExpireToken(vc: vc)
                            }
                        }
                    default:
                        success(data)
                    }
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                    }
                    if error._code == 13 {    // Request timeout
                        Indicator.shared.hideIndictorView()
                        failure(BackendError(errorCode: 13, errorDescription: "Connection timed out".localizable))
                        return
                    }
#if DEBUG
                    print("❌❌❌❌")
                    print(response.debugDescription)
                    print(response.response?.statusCode)
                    print("❌❌❌❌")
#endif
                    
                    switch statusCode {
                    case 401:
                        if let vc = currentVC, !(vc is LoginVC) {
                            failure(BackendError(errorCode: 401, errorDescription: "Session expired!"))
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let topMostViewController = window?.rootViewController
                            if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                presentedViewController.dismiss(animated: false) {
                                    Utils.showLoginVCForExpireToken(vc: vc)
                                }
                                
                            } else {
                                Utils.showLoginVCForExpireToken(vc: vc)
                            }
                        }
                    case 444:
                        if let vc = currentVC, !(vc is LoginVC) {
                            failure(BackendError(errorCode: 401, errorDescription: "Session expired!"))
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let topMostViewController = window?.rootViewController
                            if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                presentedViewController.dismiss(animated: false) {
                                    Utils.showLoginVCForExpireToken(vc: vc)
                                }
                                
                            } else {
                                Utils.showLoginVCForExpireToken(vc: vc)
                            }
                            
                        }
                    default:
                        if let vc = currentVC, !(vc is LoginVC), Datamanager.shared.accessToken != nil, Datamanager.shared.accessToken.isEmpty == true {
                            failure(BackendError(errorCode: 401, errorDescription: "Session expired!"))
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let topMostViewController = window?.rootViewController
                            if let presentedViewController = topMostViewController?.presentedViewController, !(presentedViewController is LoginVC) {
                                presentedViewController.dismiss(animated: false) {
                                    Utils.showLoginVCForExpireToken(vc: vc)
                                }
                                
                            } else {
                                Utils.showLoginVCForExpireToken(vc: vc)
                            }
                            
                        } else {
                            Utils.showAlert(withTitle: "Server error".localizable, message: "No data".localizable)
                        }
                    }
                }
            }
        } else {
            failure(BackendError(errorCode: 411178, errorDescription: "The Internet connection appears to be offline.".localizable))
            //  Utils.showAlert(withTitle: "Alert".localizable, message: "The Internet connection appears to be offline.".localizable)
        }
    }
}
