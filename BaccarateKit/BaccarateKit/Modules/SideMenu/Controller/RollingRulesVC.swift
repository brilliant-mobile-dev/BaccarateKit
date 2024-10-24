//
//  RollingRulesVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 15/9/23.
//

import UIKit
import WebKit
import SDWebImage
class RollingRulesVC: UIViewController {
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var imggView: UIImageView!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    var eventHandler: GameRoomUIInterface?
    var heightCell: CGFloat?
    var ruleImage: UIImage?
    let emptyView = EmptyStateView()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVC = self
        customNavBar()
        self.eventHandler = GameRoomPresenter(ui: self, wireframe: ProjectWireframe())
        self.eventHandler?.getRuleImage()
        self.title = "Game rules".localizable
        self.imgViewHeight.constant = 2500.0
        self.scrlView.contentSize = CGSize(width: Utils.screenWidth - 50, height: 2500.0)
        initializeEmptyView()
    }
    func initializeEmptyView() {
        view.addSubview(emptyView)
        emptyView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonAction), for: .touchUpInside)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    @objc func tryAgainButtonAction() {
        self.eventHandler?.getRuleImage()
    }
    override func viewDidLayoutSubviews() {
        self.scrlView.contentSize = CGSize(width: Utils.screenWidth - 50, height: 1700)
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    func setImage(height: CGFloat) {
        emptyView.hideView()
        heightCell = height
        self.imgViewHeight.constant = height
        self.scrlView.contentSize = CGSize(width: Utils.screenWidth - 50, height: height)
    }
}
extension RollingRulesVC: GameRoomUI {
    func imageRuleSucess(_ data: ResponeData) {
//        self.showEmptyData(count: 1)
        let imageURL = data.respMsg ?? ""
        if let imgURL = URL(string: imageURL) {
            self.imggView.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "no_data"))
            SDWebImageManager.shared.loadImage(
                with: imgURL,
                options: .continueInBackground, // or .highPriority
                progress: nil,
                completed: { [weak self] (image, _, error, _, _, _) in
                    if error != nil {
                        // Do something with the error
                        let height = 2500.0
                        self?.setImage(height: height)
                        return
                    }
                    guard let img = image else {
                        // No image handle this error
                        let height = 2500.0
                        self?.setImage(height: height)
                        return
                    }
                    self?.setImage(height: img.size.height)
                }
            )
        }
    }
    func foundError (_ error: BackendError) {
        if error.errorCode == 401 {
           self.dismiss(animated: true)
        } else if error.errorCode == 411178 {
            emptyView.showView(type: .internet, title: nil)
        } else if error.errorCode == 13 {
            emptyView.showView(type: .timeOut, title: nil)
        } else {
            emptyView.showView(type: .general, title: nil)
            showAlert(withTitle: "", message: error.errorDescription)
        }
    }
}
extension RollingRulesVC: LoginDismissDelegate {
    func loginDismissed() {
        self.eventHandler?.getRuleImage()
    }
}
