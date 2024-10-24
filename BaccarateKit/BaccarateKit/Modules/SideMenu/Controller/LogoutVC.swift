//
//  LogoutVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit

class LogoutVC: UIViewController {
    var delegate: LogoutDelegate?
    var eventHandler: LoginUIInterface?
    @IBOutlet weak var tileLbl: UILabel!
    @IBOutlet weak var logoutDescLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        self.languageSetup()
        // Do any additional setup after loading the view.
    }

    func languageSetup() {
        tileLbl.text = "Sign out".localizable
        self.logoutDescLbl.text = "Are you sure you want to quit the game?".localizable
        Utils.setButtonTitle(btn: cancelBtn, text: "Cancel".localizable)
        Utils.setButtonTitle(btn: logoutBtn, text: "Confirm".localizable)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.eventHandler?.handleLogout()
    }
}
extension LogoutVC: LoginUI, LoginDismissDelegate {
    func loginDismissed() {
        self.view.isHidden = true
        self.delegate?.reLoggedIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: false)
        }
    }
    func logOutSucess (_ data: ResponeData) {
        Datamanager.shared.isUserAuthenticated = false
        Datamanager.shared.accessToken = ""
        ConfigurationDataManager.shared.userInfo = nil
        ConfigurationDataManager.shared.cachelanguageSource = "local"
        Utils.showLoginVC(vc: self)
     //   dismiss(animated: true)
    }
    func foundError(_ error: BackendError) {
       // Utils.showLoginVC(vc: self)
        if error.errorCode == 401 {
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
protocol LogoutDelegate: AnyObject {
    func reLoggedIn()
}
