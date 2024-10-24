//
//  ImageDispayVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
import UIKit
import SDWebImage
class ImageDispayVC: UIViewController {
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var displayImg: UIImageView!
    var imageReceipt: UIImage?
    var imageUrl: String?
    var titleStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle.text = titleStr ?? ""
        self.displayImg.contentMode = .scaleAspectFit
        if let imgUrl = imageUrl {
            let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: urlString ) {
                self.displayImg.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: SDWebImageOptions(), completed: nil)
            }
        } else if imageReceipt != nil {
            self.displayImg.image = imageReceipt
        }
    }
    
    @IBAction func onCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
