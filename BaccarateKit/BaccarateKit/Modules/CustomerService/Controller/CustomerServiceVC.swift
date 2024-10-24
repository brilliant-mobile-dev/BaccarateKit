//
//  CustomerServiceVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 7/10/23.

import UIKit

class CustomerServiceVC: UIViewController {
    @IBOutlet weak var customerTableView: UITableView!
    var eventHandler: DashboardUIInterface?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var arrCustomerService = [CustomerServiceData]()
    let emptyView = EmptyStateView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageSetup()
        // Get Customer Service List
        self.eventHandler = DashboardPresenter(ui: self, wireframe: ProjectWireframe())
        self.eventHandler?.getCustomerList()
        
        // Do any additional setup after loading the view.
        initializeEmptyView()
    }
    func initializeEmptyView() {
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    @objc func tryAgainButtonAction() {
        self.eventHandler?.getCustomerList()
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    func languageSetup() {
        self.titleLbl.text = "Contact Customer Service".localizable
    }
}
extension CustomerServiceVC: DashboardUI {
    func customerServiceSuccess(_ data: CustomerServiceResponse) {
        customerTableView.isHidden = false
        self.arrCustomerService = data.datas ?? [CustomerServiceData]()
       
        if self.arrCustomerService.count == 0 {
            emptyView.showView(type: .general, title: nil)
         //   tableHeight.constant = CGFloat(5) * 80
        } else {
            emptyView.hideView()
            tableHeight.constant = CGFloat(arrCustomerService.count) * 80
            self.customerTableView.reloadData()
        }
        
    }
    func foundError(_ error: BackendError) {
        if error.errorCode == 401 {
           self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            self.customerTableView.isHidden = true
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            self.customerTableView.isHidden = true
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: "Alert".localizable)
            showAlert(withTitle: "Alert".localizable, message: error.errorDescription)
        }
        
    }
}
extension CustomerServiceVC: UITableViewDelegate, UITableViewDataSource, UpdateActionDelegate {
    func updateAction(index: Int) {
        for index in self.arrCustomerService.indices {
            self.arrCustomerService[index].isSelected = false
        }
        self.arrCustomerService[index].isSelected = true
        self.customerTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCustomerService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerServiceCell", for: indexPath) as? CustomerServiceCell {
            cell.copyBtn.tag = indexPath.row
            cell.updateDelegate = self
            cell.data = self.arrCustomerService[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
}
