//
//  ShuffleVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 08/09/23.
//

import UIKit
class ShuffleVC: UIViewController {
    var delegateLogout: LogoutDelegate?
    var validDelegate: ValidBetDelegate?
    var userInfo = ConfigurationDataManager.shared.userInfo
    @IBOutlet weak var tileLbl: UILabel!
    @IBOutlet weak var myTurnOverAmountLbl: UILabel!
    @IBOutlet weak var myTurnOverLbl: UILabel!
    @IBOutlet weak var rollingRuleBtn: UIButton!
    @IBOutlet weak var turnOverBtn: UIButton!
    @IBOutlet weak var claimButton: ButtonDesign!
    @IBOutlet weak var popupView: ViewDesign!
    var eventHandler: LoginUIInterface?
    override func viewDidLoad() {
        super.viewDidLoad()
       // currentVC = self
        self.languageSetup()
        if eventHandler == nil {
            self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        }
        claimButton.isEnabled = false
        claimButton.backgroundColor = .placeholder
        self.claimButton.isEnabled = false
        if let data = self.userInfo {
            self.myTurnOverAmountLbl.text =  (data.symbol ?? "") + (data.washCodeMoney?.afterDecimal2Digit ?? "0.0")
            if (data.washCodeMoney ?? 0.0) > 0.0 {
                self.claimButton.isEnabled = true
                claimButton.backgroundColor = .appYellow
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeRules" {
            if let presentationController = segue.destination.popoverPresentationController { // 1
                presentationController.delegate = self // 2
            }
        }
    }
    func languageSetup() {
        self.tileLbl.text = "Valid bet".localizable
        self.myTurnOverLbl.text = "My valid bet".localizable
        Utils.setButtonAttributedTitle(btn: rollingRuleBtn, text: "Valid bet requirement".localizable)
        Utils.setButtonAttributedTitle(btn: turnOverBtn, text: "Valid bet record".localizable)
        Utils.setButtonTitle(btn: claimButton, text: "Claim valid bet".localizable)
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func turnOverBtnAction(_ sender: Any) {
        let navVC = storyboard?.instantiateViewController(withIdentifier: "recordsNav") as? UINavigationController
      //  let destVC = navVC.viewControllers.first as! RecordsVC
        (navVC!.viewControllers.first as? RecordsVC)?.selectedIndex = 2
        navVC!.isModalInPresentation = true
        present(navVC!, animated: true)
    }
    @IBAction func claimButtonAction(_ sender: Any) {
        if let data = self.userInfo {
            if (data.washCodeMoney ?? 0.0) > 0.0 {
                self.eventHandler?.takeWashableMoney()
            }
        }
    }
}
extension ShuffleVC: LoginUI {
    func takeWashableSucess (_ data: LoginData) {
        if let userInfo = userInfo {
            let amount = userInfo.washCodeMoney ?? 0.0
            // Call Delegate method to HomeVC Pass this Amount
            // On HomeVC Show this PopUp
            ConfigurationDataManager.shared.userInfo?.washCodeMoney = 0.0
            self.validDelegate?.validBetUpdate(washCodeMoney: amount, message: "Claim successfully".localizable)
        }
        self.dismiss(animated: true)
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
           // Utils.showLoginVC(vc: self)
           // self.dismiss(animated: true)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }

}
extension ShuffleVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none // 3
    }
}
//extension ShuffleVC: LoginDismissDelegate {
//    func loginDismissed() {
//        self.view.isHidden = true
//        self.delegateLogout?.reLoggedIn()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.dismiss(animated: false)
//        }
//    }
//}

protocol ValidBetDelegate: AnyObject {
    func validBetUpdate(washCodeMoney: Double, message: String)
}
