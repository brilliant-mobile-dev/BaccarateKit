//
//  LoginVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 4/9/23.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SDWebImage
class LoginVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var userNameTitleLbl: UILabel!
    @IBOutlet weak var passwordTitleLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var guestLoginBtn: UIButton!
    @IBOutlet weak var languageNameLbl: UILabel!
    @IBOutlet weak var languageIconImgView: UIImageView!
    @IBOutlet weak var logoIconImgView: UIImageView!
    var eventHandler: LoginUIInterface?
    // Delegate to find Login Dismissed
    var delegate: LoginDismissDelegate?
    var isTokenExpire = false
    var languageDataArr = [LanguageData]()
    let statusView = StatusView(isDisplayBg: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxt.placeHolderColor = UIColor(hex: "C8CDDB")
        passwordTxt.placeHolderColor = UIColor(hex: "C8CDDB")
        self.initializeStatusView()
         currentVC = self
        self.logoIconImgView.image = UIImage(named: "clearColorImg")
        if let logo = ConfigurationDataManager.shared.logoData {
            self.setLogoImage(logo: logo)
        }
        if eventHandler == nil {
            self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        }
        let languageDataArr = ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()
         if languageDataArr.count < 1 {
            self.eventHandler?.getLanguageData()
         }
        self.languageSetup()
        self.passwordTxt.delegate = self
        if isTokenExpire == true {
            self.statusView.showStatus("Session expired!".localizable)
            isTokenExpire = false
        }
    }
    func initializeStatusView() {
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 200),
            statusView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    func languageSetup() {
        self.userNameTxt.placeholder = "Please enter the user name".localizable
        self.passwordTxt.placeholder = "Please enter the password".localizable
        self.userNameTitleLbl.text = ""
        self.passwordTitleLbl.text = ""
        self.titleLbl.text = "User login".localizable
        Utils.setButtonTitle(btn: guestLoginBtn, text: "Guest login".localizable)
        Utils.setButtonTitle(btn: loginBtn, text: "Login".localizable)
        self.languageNameLbl.text = BaccaratLivelanguage.name
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localizable
        if let url = URL(string: BaccaratLivelanguage.iconUrl) {
            self.languageIconImgView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "flag.slash.fill"))
        } else {
            self.languageIconImgView.image = UIImage(systemName: "flag.slash.fill")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // navigationController?.setNavigationBarHidden(false, animated: false)
        // self.view.backgroundColor = .red
    }
    // Login APi Call
    @IBAction func actionLogin(_ sender: UIButton) {
        if isValidUIInput() {
            eventHandler?.handleLogin(self.userNameTxt.text!, self.passwordTxt.text!)
        }
    }
    // Guest Login APi Call
    @IBAction func actionGuestLogin(_ sender: UIButton) {
        eventHandler?.handleGuestLogin()
    }
    func isValidUIInput() -> Bool {
        var alertText = ""
        var isValid = true
        if userNameTxt.text!.count < 1 {
            alertText = "Please enter the user name".localizable
            isValid = false
        } else if passwordTxt.text!.count == 0 {
            isValid = false
            alertText = "Please enter the password".localizable
        } else if passwordTxt.text!.count < 6 {
            isValid = false
            alertText = "Please enter the correct password".localizable
        }
        if !isValid {
            self.showAlert(withTitle: "Alert".localizable, message: alertText)
            return false
        }
        return true
    }
    @IBAction func showLanguagePopUp() {
        self.view.endEditing(true)
        if let popupVC = storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as? LanguageVC {
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .coverVertical
            popupVC.delegateLanguage = self
            present(popupVC, animated: true)
        }
    }
}
extension LoginVC: LoginUI {
    func loginSucess(_ loginData: LoginData) {
        if (loginData.datas?.accessToken) != nil {
            Datamanager.shared.isUserAuthenticated = true
            Datamanager.shared.accessToken = loginData.datas?.accessToken
        }
        delegate?.loginDismissed()
        dismiss(animated: true)
    }
    func languageDataSucess (_ data: LanguageResponse) {
        self.languageDataArr = data.datas ?? [LanguageData]()
        if let url = URL(string: BaccaratLivelanguage.iconUrl) {
            self.languageIconImgView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "flag.slash.fill"))
            self.languageNameLbl.text = BaccaratLivelanguage.name
        } else {
            self.languageIconImgView.image = UIImage(systemName: "flag.slash.fill")
        }
        eventHandler?.getSourceLanguageData()
    }
    func languageSourceDataSucess (_ data: LanguageSourceResponse) {
        ConfigurationDataManager.shared.languageSourceDataArr = data.datas ?? [LanguageSourceData]()
        self.languageSetup()
        self.eventHandler?.getLogoData()
    }
    func logoSuccess (_ loginData: LogoResponseData) {
        let logoArr = loginData.datas ?? [LogoData]()
        if let logo = logoArr.first(where: {$0.location == 1}) {
            self.setLogoImage(logo: logo)
        }
    }
    func foundError(_ error: BackendError) {
        self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
    }
    func setLogoImage(logo: LogoData) {
        if let imgUrl = logo.url {
            let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: urlString ) {
                self.logoIconImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "clearColorImg"), options: SDWebImageOptions(), completed: nil)
            }
        } else {
            self.logoIconImgView.image = UIImage(named: "clearColorImg")
        }
    }
    //clearColorImg
}
extension LoginVC: LanguageSelectionDelegate {
    func languageSelected(languageData: LanguageData) {
        self.languageSetup()
    }
}
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.passwordTxt {
            if string == " " {
                return false
            }
            guard let preText = textField.text as NSString?,
                  preText.replacingCharacters(in: range, with: string).count <= maxPassword else {
                return false
            }
            return true
        } else {
            return true
        }
        
    }
}
