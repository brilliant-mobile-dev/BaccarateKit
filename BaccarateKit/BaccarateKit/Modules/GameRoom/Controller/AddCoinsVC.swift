//
//  AddCoinsVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 26/09/23.
//

import UIKit

class AddCoinsVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    var eventHandler: GameRoomUIInterface?
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var coinTable: UICollectionView!
    var allCoins = [CasinoChip]()
    var updateChipDelegate: UpdateChipsDelegate?
    var userInfo = ConfigurationDataManager.shared.userInfo
    var userChips = [Int]()
    let statusView = StatusView(isDisplayBg: false)
    override func viewDidLoad() {
        super.viewDidLoad()
         currentVC = self
        self.eventHandler = GameRoomPresenter(ui: self, wireframe: ProjectWireframe())
        // Do any additional setup after loading the view.
        coinTable.delegate = self
        coinTable.dataSource = self
        allCoins = GameRoomVM.shared.fetchAllChips()
        initializeStatusView()
        if let chips = userInfo?.chips {
            userChips = chips.split(separator: ",").compactMap { Int($0) }
            // Filtering chips which are not in our chip list
            let removeSet = Set(userChips)
            userChips = Constants.allChips.filter { removeSet.contains($0) }
            DispatchQueue.main.async {
                self.coinTable.reloadData()
            }
        }
        self.languageSetup()
    }
    func languageSetup() {
        self.titleLbl.text = "Chip setting".localizable
        Utils.setButtonTitle(btn: self.cancelBtn, text: "Cancel".localizable)
        Utils.setButtonTitle(btn: self.confirmBtn, text: "Confirm".localizable)
    }
    func initializeStatusView() {
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 300),
            statusView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        if userChips.count <= 10 {
            var userChipsStr = [String]()
            for item in userChips {
                userChipsStr.append("\(item)")
            }
            let userChipsList = userChipsStr.joined(separator: ",")
            self.eventHandler?.saveChips(chipsList: userChipsList)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: "Only 10 chips can be selected at most".localizable)
        }
    }
}
// MARK: Coin Table Delegate & Datasource Methods
extension AddCoinsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCoins.count
    }
    func collectionView(_ collectionView:
                        UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AddCoinCVCell
        cell?.updateView(coin: allCoins[indexPath.row])
        if userChips.contains(allCoins[indexPath.row].value) {
            cell?.chipStatusVU.isHidden = false
        } else {
            cell?.chipStatusVU.isHidden = true
        }
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = userChips.firstIndex(of: allCoins[indexPath.row].value) {
            if userChips.count < 6 {
            //    statusView.showStatus("Customized chips number 5-10".localizable, duration: 1)
                self.showAlert(withTitle: "Alert".localizable, message: "Customized chips number 5-10".localizable)
            } else {
                userChips.remove(at: index)
            }
        } else {
            if userChips.count >= 10 {
                self.showAlert(withTitle: "Alert".localizable, message: "Customized chips number 5-10".localizable)
              //  statusView.showStatus("Customized chips number 5-10".localizable, duration: 1)
            } else {
                userChips.append(allCoins[indexPath.row].value)
            }
        }
        DispatchQueue.main.async {
            self.coinTable.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
}
extension AddCoinsVC: GameRoomUI {
    func sucessSaveChips (_ data: ResponeData) {
        var userChipsStr = [String]()
        for item in userChips {
            userChipsStr.append("\(item)")
        }
        let userChipsList = userChipsStr.joined(separator: ",")
        ConfigurationDataManager.shared.userInfo?.chips = userChipsList
        self.updateChipDelegate?.updateChips(chips: userChipsList)
        dismiss(animated: true)
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
            self.updateChipDelegate?.stopSocketFromAddChips(error: error)
            self.dismiss(animated: true)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}

protocol UpdateChipsDelegate: AnyObject {
    func updateChips(chips: String)
    func stopSocketFromAddChips(error: BackendError?)
}
extension AddCoinsVC: LoginDismissDelegate {
    func loginDismissed() {
        if userChips.count < 11 {
            var userChipsStr = [String]()
            for item in userChips {
                userChipsStr.append("\(item)")
            }
            let userChipsList = userChipsStr.joined(separator: ",")
            self.eventHandler?.saveChips(chipsList: userChipsList)
        } else {
            self.showAlert(withTitle: "Alert".localizable, message: "Customized chips number 5-10".localizable)
        }
    }
}
