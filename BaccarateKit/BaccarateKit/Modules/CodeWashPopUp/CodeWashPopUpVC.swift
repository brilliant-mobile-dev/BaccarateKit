//
//  CodeWashPopUpVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 19/9/23.
//

import UIKit
// swiftlint:disable line_length
class CodeWashPopUpVC: UIViewController {
    
    @IBOutlet weak var rulesLbl: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let rule1 = "1. " + "Valid bet refers to the player in the game after the effective betting, according to a certain percentage of cashback, the greater the amount of bets, the more valid bets received".localizable
        let rule2 = "\n2. " + "Cash earned through valid bet can be withdrawn immediately without rolling".localizable
        let rule3 = "\n3. " + "There is no limit to the amount of valid bets per day, different games may have different percentages of valid bets, so please check carefully.".localizable
        rulesLbl.text = rule1 + rule2 + rule3
        rulesLbl.font = .appFont(family: .regular, size: 13)

        preferredContentSize = CGSize(width: 300, height: rulesLbl.contentSize.height) // rulesLbl.contentSize
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
