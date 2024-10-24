//
//  FeesStatusVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 18/9/23.
//

import UIKit

class FeesStatusVC: UIViewController {
    var freeStatusDelegate: UpdateUserFreeStatusDelegate?
    var tableInfoData: TableRoomData?
    @IBOutlet weak var dealerTileLbl: UILabel!
    @IBOutlet weak var dealerDescLbl: UILabel!
    @IBOutlet weak var bankerTileLbl: UILabel!
    @IBOutlet weak var bankerDescLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var dealerRadioBtn: UIButton!
    @IBOutlet weak var bankerRadioBtn: UIButton!
    var eventHandler: GameRoomUIInterface?
    var freeStatus = "true"
    var groupData: TableGroupData?
    override func viewDidLoad() {
        super.viewDidLoad()
     //   currentVC = self
        self.eventHandler = GameRoomPresenter(ui: self, wireframe: ProjectWireframe())
        // Do any additional setup after loading the view.
        languageSetup()
    }
    func languageSetup() {
        self.titleLbl.text = "Switch to Comm. Free".localizable
        self.dealerTileLbl.text = "B(Comm.)".localizable
        self.dealerDescLbl.text = "Banker wins by any number of points, payout is 1:0.95, and capital refund on a draw".localizable
        self.bankerTileLbl.text = "B(Comm. Free)".localizable
        let textS = "Banker wins on anything other than 6 points, payout at 1:1; Banker with 6 points payout at 1:0.5 and capital refund on a draw."
        self.bankerDescLbl.text = textS.localizable
        Utils.setButtonTitle(btn: self.cancelBtn, text: "Cancel".localizable)
        Utils.setButtonTitle(btn: self.confirmBtn, text: "Confirm".localizable)
        if (self.tableInfoData?.userFreeStatus ?? true) == true {
            freeStatus = "true"
            self.bankerRadioBtn.isSelected = true
            self.dealerRadioBtn.isSelected = false
        } else {
            freeStatus = "false"
            self.bankerRadioBtn.isSelected = false
            self.dealerRadioBtn.isSelected = true
        }
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func radioButtonAction(_ btn: UIButton) {
        if btn.tag == 1 {
            self.dealerRadioBtn.isSelected = true
            self.bankerRadioBtn.isSelected = false
            freeStatus = "false"
        } else {
            self.dealerRadioBtn.isSelected = false
            self.bankerRadioBtn.isSelected = true
            freeStatus = "true"
        }
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        let status = (freeStatus == "true") ? true : false
        if (self.tableInfoData?.userFreeStatus ?? true) != status {
            if let data = groupData {
                self.eventHandler?.setFreeStatus(groupNo: data.groupNo ?? "", freeStatus: freeStatus)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
extension FeesStatusVC: GameRoomUI {
    func setFreeStatusSucess(_ data: LoginData) {
        self.freeStatusDelegate?.updateFreeStatus(freeStatus: self.freeStatus)
        self.dismiss(animated: true)
    }
    func foundError (_ error: BackendError) {
        if error.errorCode == 401 {
            self.freeStatusDelegate?.stopSocketFromFreeStatus(error: error)
           self.dismiss(animated: true)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}

protocol UpdateUserFreeStatusDelegate: AnyObject {
    func updateFreeStatus(freeStatus: String)
    func stopSocketFromFreeStatus(error: BackendError?)
}
