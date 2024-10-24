//
//  RecordExtension.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 13/9/23.
//

import Foundation
import UIKit
// MARK: Textfield Delegate
extension RecordsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = DateUtility.shared.convertDateToString(date: datepicker.date)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = DateUtility.shared.convertDateToString(date: datepicker.date)
        if textField == startDateTF {
            if datepicker.date > Date() {
                endDateTF.text = startDateTF.text
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == endDateTF {
            activeTFTag = 2
            if let startDate = startDateTF.text {
                datepicker.minimumDate = DateUtility.shared.convertStringToDate(string: startDate)
                datepicker.maximumDate = Date()
            }
        } else {
            activeTFTag = 1
            datepicker.maximumDate = self.endDateD
            datepicker.minimumDate = Calendar.current.date(byAdding: .day, value: -29, to: Date())
        }
    }
}
extension RecordsVC: RecordUI {
    func washCodeListSucess(_ data: WashCodeResponse) {
        self.recordTable.isHidden = false
        totalPage = data.datas?.pageResult?.totalPage ?? 1
        for washCodeData in  data.datas?.pageResult?.data ?? [] {
            self.washCodeArr.append(washCodeData)
        }
        self.footer4.text = (data.datas?.total ?? 0).afterDecimal2Digit
        if washCodeArr.count == 0 {
            emptyView.showView(type: .general, title: nil)
        } else {
            emptyView.hideView()
        }
        self.recordTable.reloadData()
    }
    
    func moneyChangeListSucess(_ data: MoneyChangeListResponse) {
        self.recordTable.isHidden = false
        totalPage = data.datas?.totalPage ?? 1
       // self.moneyChangeArr = data.datas?.data ?? []
        for moneyChange in data.datas?.data ?? [] {
            self.moneyChangeArr.append(moneyChange)
        }
        if moneyChangeArr.count == 0 {
            emptyView.showView(type: .general, title: nil)
        } else {
            emptyView.hideView()
        }
        self.recordTable.reloadData()
    }
    func recordListSucess(_ data: RecordListResponse) {
        self.recordTable.isHidden = false
        totalPage = data.datas?.pageResult?.totalPage ?? 1
     //   self.pageResultArr = data.datas?.pageResult?.data ?? [PageResultData]()
        for pageResult in data.datas?.pageResult?.data ?? [PageResultData]() {
            self.pageResultArr.append(pageResult)
        }
        self.footer4.text = (data.datas?.betTotal?.betMoney ?? 0).afterDecimal2Digit
        self.footer5.text = (data.datas?.betTotal?.winLossMoney ?? 0).afterDecimal2Digit
        if (data.datas?.betTotal?.winLossMoney ?? 0) < 0.0 {
            footer5.textColor = .loseColor
        } else {
            footer5.textColor = .winColor
        }
        if pageResultArr.count == 0 {
            emptyView.showView(type: .general, title: nil)
        } else {
            emptyView.hideView()
        }
        self.recordTable.reloadData()
    }
    
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
          // self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            self.recordTable.isHidden = true
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            self.recordTable.isHidden = true
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: "Alert".localizable)
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
    }
}
// MARK: RecordVC Delegate
extension RecordsVC: RecordVCDelegate {
    func showRecordDetail(data: PageResultData) {
        let navVC = UINavigationController()
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "RecordDetailVC") as? RecordDetailVC {
            destVC.data = data
            navVC.viewControllers = [destVC]
        }
        if #available(iOS 15.0, *) {
            if let presentationController = navVC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
        } else {
            // Fallback on earlier versions
        }
        present(navVC, animated: true)
    }
}
extension RecordsVC: LoginDismissDelegate {
    func loginDismissed() {
        self.getDataList()
    }
}
