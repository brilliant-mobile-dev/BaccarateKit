//
//  AppQRVC.swift
//  BaccaratLiveStream
//
//  Created by Mohd Farmood on 5/3/24.
//

import UIKit

class AppQRVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iosQRImageView: UIImageView!
    @IBOutlet weak var androidQRImageView: UIImageView!
    var eventHandler: LoginUIInterface?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageSetup()
        self.eventHandler = LoginPresenter(ui: self, wireframe: ProjectWireframe())
        eventHandler?.getSysConfigApp()
        // Do any additional setup after loading the view.
    }
    func languageSetup() {
        self.titleLbl.text = "Download APP".localizable
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    func dataForQR(appurl: String, type: String) {
        if let image = generateQRCode(from: appurl) {
            if type == "IOS" {
                self.iosQRImageView.image = image
            }
            else if type == "Android" {
                self.androidQRImageView.image = image
            }
        }
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 6, y: 6)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

}
extension AppQRVC: LoginUI {
    func getSysConfigAppSuccess(appData: AppStoreData) {
        for item in appData.datas {
            if item.device == "IOS" {
                self.dataForQR(appurl: item.url, type: "IOS")
            } else if item.device == "Android" {
                self.dataForQR(appurl: item.url, type: "Android")
            }
        }
    }
}
