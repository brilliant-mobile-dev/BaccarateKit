//
//  LanguageVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
class LanguageVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    var delegateLanguage: LanguageSelectionDelegate?
    var eventHandler: LoginUIInterface?
    @IBOutlet weak var languageTV: UICollectionView!
    var selectedIndex: Int?
    var languageDataArr = ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        self.titleLbl.text = "Select language".localizable
        self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        // Do any additional setup after loading the view.
        languageTV.delegate = self
        languageTV.dataSource = self
        if let index = languageDataArr.firstIndex(where: {$0.isSelected == true}) {
            self.selectedIndex = index
        }
        if languageDataArr.count < 1 {
            self.eventHandler?.getLanguageData()
        }
        let lang = Session.shared.getLanguangeCode()
        if let index = (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()).firstIndex(where: {$0.code == lang}) {
            (ConfigurationDataManager.shared.languageDataArr![index].isSelected) = true
        }
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    func updateLanguageData(index: Int) {
        dismiss(animated: true) {
            let flagD = "flag.slash.fill"
            let defaultFUrl = "http://minio1.kk88814.net/kkvideo/language_kh.png"
            for item in (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()) {
                item.isSelected = false
            }
            (ConfigurationDataManager.shared.languageDataArr![index].isSelected) = true
            ConfigurationDataManager.shared.selectedLanguage = ConfigurationDataManager.shared.languageDataArr![index]
            Session.shared.setLanguage(code: (ConfigurationDataManager.shared.selectedLanguage?.code ?? "en"),
                                       name: (ConfigurationDataManager.shared.selectedLanguage?.name ?? "English"),
                                       id: (ConfigurationDataManager.shared.selectedLanguage?.code ?? "en"),
                                       iconUrl: (ConfigurationDataManager.shared.selectedLanguage?.icon ?? flagD))
            BaccaratLivelanguage.code = ConfigurationDataManager.shared.selectedLanguage?.code ?? "zh-Hans"
            BaccaratLivelanguage.name = ConfigurationDataManager.shared.selectedLanguage?.name ?? "简体中文"
            BaccaratLivelanguage.iconUrl = ConfigurationDataManager.shared.selectedLanguage?.icon ?? defaultFUrl
            if let languageData = ConfigurationDataManager.shared.selectedLanguage {
                self.delegateLanguage?.languageSelected(languageData: languageData)
            }
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localizable
        }
    }
}

// MARK: Language CollectionView Delegate & Datasource Methods
extension LanguageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageDataArr.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                         for: indexPath) as? LanguageCVCell {
            if indexPath.row == selectedIndex {
                cell.updateView(isSelected: true, data: languageDataArr[indexPath.row])
            } else {
                cell.updateView(isSelected: false, data: languageDataArr[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.updateLanguageData(index: indexPath.row)
        DispatchQueue.main.async {
            self.languageTV.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 70
        let height = 85
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
extension LanguageVC: LoginUI {
    func languageDataSucess (_ data: LanguageResponse) {
        let lang = Session.shared.getLanguangeCode()
        if let index = (ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()).firstIndex(where: {$0.code == lang}) {
            (ConfigurationDataManager.shared.languageDataArr![index].isSelected) = true
            self.selectedIndex = index
        }
        self.languageDataArr = ConfigurationDataManager.shared.languageDataArr ?? [LanguageData]()
        self.languageTV.reloadData()
    }
    func foundError (_ error: BackendError) {
        if error.errorCode == 401 {
        } else {
            DispatchQueue.main.async {
                self.showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
            }
        }
    }
}
protocol LanguageSelectionDelegate: AnyObject {
    func languageSelected(languageData: LanguageData)
}
