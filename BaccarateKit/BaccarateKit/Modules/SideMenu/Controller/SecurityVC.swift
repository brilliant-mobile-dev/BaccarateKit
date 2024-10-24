//
//  SecurityVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit

class SecurityVC: UIViewController {
    var delegateLogout: LogoutDelegate?
    var delegate: LoginDismissDelegate?
    @IBOutlet weak var currentPasswordTxt: KKTxtField!
    @IBOutlet weak var newPasswordTxt: KKTxtField!
    @IBOutlet weak var newConfirmPasswordTxt: KKTxtField!
    @IBOutlet weak var currentPasswordLbl: UILabel!
    @IBOutlet weak var newPasswordLbl: UILabel!
    @IBOutlet weak var newConfirmPasswordLbl: UILabel!
    @IBOutlet weak var changePassBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    var eventHandler: LoginUIInterface?
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        self.languageSetup()
        // Do any additional setup after loading the view.
    }
    func languageSetup() {
        self.currentPasswordLbl.text = "Please enter the original login password".localizable
        self.newPasswordLbl.text = "Please enter the new login password".localizable
        self.newConfirmPasswordLbl.text = "Please confirm the new login password".localizable
        self.currentPasswordTxt.placeholder = "Password (6-10 digits or letters)".localizable
        self.newPasswordTxt.placeholder = "Password (6-10 digits or letters)".localizable
        self.newConfirmPasswordTxt.placeholder = "Password (6-10 digits or letters)".localizable
        Utils.setButtonTitle(btn: changePassBtn, text: "OK to modify".localizable)
        self.titleLbl.text = "Security setting".localizable
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        if isValidUIInput() == true {
            self.eventHandler?.changePasswordData(oldPassword: currentPasswordTxt.text!,
                                                  newPassword: self.newPasswordTxt.text!)
        }
    }
    func isValidUIInput() -> Bool {
        var alertText = ""
        var isValid = true
        if currentPasswordTxt.text!.count == 0 {
            alertText = "Please enter the original login password".localizable
            isValid = false
        } else if currentPasswordTxt.text!.count < 6 ||  currentPasswordTxt.text!.count > 10 {
            alertText = "Please enter the correct password".localizable
            isValid = false
        } else if newPasswordTxt.text!.count == 0 {
            alertText = "Please enter the new login password".localizable
            isValid = false
        } else if newPasswordTxt.text!.count < 6 ||  newPasswordTxt.text!.count > 10 {
            alertText = "Please enter the correct password".localizable
            isValid = false
        } else if newConfirmPasswordTxt.text!.count == 0 {
            alertText = "Please confirm the new login password".localizable
            isValid = false
        } else if !(newConfirmPasswordTxt.text! == newPasswordTxt.text!) {
            alertText =  "The new password is not the same as the confirmation password".localizable
            isValid = false
        } else if currentPasswordTxt.text! == newPasswordTxt.text! {
            alertText =  "The new password cannot be the same as the old password".localizable
            isValid = false
        } else if (Utils.isValidPassword(enteredPassword: newPasswordTxt.text!)) == false {
            alertText = "Please enter the correct password".localizable
            isValid = false
        }
        if isValid == false {
            self.showAlert(withTitle: "Alert".localizable, message: alertText)
        }
        return isValid
    }
}
extension SecurityVC: LoginUI {
    func changePasswordSucess (_ data: LoginData) {
        Datamanager.shared.isUserAuthenticated = false
        Datamanager.shared.accessToken = ""
        ConfigurationDataManager.shared.userInfo = nil
        dismiss(animated: true)
        self.delegate?.loginDismissed()
    }
    func foundError (_ error: BackendError) {
        if error.errorCode == 401 {
           // self.dismiss(animated: true)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
extension SecurityVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        guard let preText = textField.text as NSString?,
              preText.replacingCharacters(in: range, with: string).count <= maxPassword else {
            return false
        }
        return true
    }
}
//extension SecurityVC: LoginDismissDelegate {
//    func loginDismissed() {
//        self.view.isHidden = true
//        self.delegateLogout?.reLoggedIn()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.dismiss(animated: false)
//        }
//    }
//}
