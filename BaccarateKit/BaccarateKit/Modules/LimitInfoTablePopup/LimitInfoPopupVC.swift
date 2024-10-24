//
//  LimitInfoPopupVC.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 22/9/23.
//

import UIKit

class LimitInfoPopupVC: UIViewController {
    var tableInfoData: TableRoomData?
    @IBOutlet weak var betLimitTitleLbl: UILabel!
    @IBOutlet weak var betLimitValueLbl: UILabel!
    
    @IBOutlet weak var howToPlayeLbl: UILabel!
    @IBOutlet weak var oddsLbl: UILabel!
    @IBOutlet weak var betLimitLbl: UILabel!
    
    @IBOutlet weak var pTitleLbl: UILabel!
    @IBOutlet weak var pPTitleLbl: UILabel!
    @IBOutlet weak var bTitleLbl: UILabel!
    @IBOutlet weak var bPTitleLbl: UILabel!
    @IBOutlet weak var tieTitleLbl: UILabel!
    
    @IBOutlet weak var pOddsValueLbl: UILabel!
    @IBOutlet weak var pPOddsValueLbl: UILabel!
    @IBOutlet weak var bOddsValueLbl: UILabel!
    @IBOutlet weak var bPOddsValueLbl: UILabel!
    @IBOutlet weak var tieOddsValueLbl: UILabel!
    
    @IBOutlet weak var pBetValueLbl: UILabel!
    @IBOutlet weak var pPBetValueLbl: UILabel!
    @IBOutlet weak var bBetValueLbl: UILabel!
    @IBOutlet weak var bPBetValueLbl: UILabel!
    @IBOutlet weak var tieBetValueLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 320, height: 280)
        // Do any additional setup after loading the view.
        if let data = tableInfoData?.bacOddsVo {
            if self.tableInfoData?.userFreeStatus == true {
                self.bOddsValueLbl.text = "1:" + "\((data.bankerFree ?? 0).afterDecimal2DigitNoZero)"
            } else {
                self.bOddsValueLbl.text = "1:" + "\((data.banker ?? 0).afterDecimal2DigitNoZero)"
            }
            //  self.bOddsValueLbl.text = "1:" + "\((data.banker ?? 0).afterDecimal2DigitNoZero)"
            self.pOddsValueLbl.text = "1:" + "\((data.player ?? 0).afterDecimal2DigitNoZero)"
            self.tieOddsValueLbl.text = "1:" + "\((data.tie ?? 0).afterDecimal2DigitNoZero)"
            self.bPOddsValueLbl.text = "1:" + "\((data.bankerPair ?? 0).afterDecimal2DigitNoZero)"
            self.pPOddsValueLbl.text = "1:" + "\((data.playerPair ?? 0).afterDecimal2DigitNoZero)"
            
        }
        if let dic = tableInfoData?.bacGameLimitPlanContent {
            // "P PAIR".localizable + " 1:" + "\((self.tableInfoData?.bacOddsVo?.playerPair ??
            self.bBetValueLbl.text =  "\((dic["bankerMin"] ?? 0).afterDecimal2DigitNoZero)" + "- " + "\((dic["bankerMax"] ?? 0).afterDecimal2DigitNoZero)"
            self.pBetValueLbl.text =  "\((dic["playerMin"] ?? 0).afterDecimal2DigitNoZero)" + "- " +  "\((dic["playerMax"] ?? 0).afterDecimal2DigitNoZero)"
            self.tieBetValueLbl.text = "\((dic["tieMin"] ?? 0).afterDecimal2DigitNoZero)" + "- " +  "\((dic["tieMax"] ?? 0).afterDecimal2DigitNoZero)"
            self.bPBetValueLbl.text = "\((dic["bankerPairMin"] ?? 0).afterDecimal2DigitNoZero)" + "- " +  "\((dic["bankerPairMax"] ?? 0).afterDecimal2DigitNoZero)"
            self.pPBetValueLbl.text = "\((dic["playerPairMin"] ?? 0).afterDecimal2DigitNoZero)" + "- " +  "\((dic["playerPairMax"] ?? 0).afterDecimal2DigitNoZero)"
        }
        self.betLimitValueLbl.text = "\((self.tableInfoData?.tableLimit ?? 0).afterDecimal2DigitNoZero)"
        self.languageSetup()
    }
    
    func languageSetup() {
        self.betLimitTitleLbl.text = "Table betting limit".localizable
        self.howToPlayeLbl.text = "How to play".localizable
        self.oddsLbl.text = "Odds".localizable
        self.betLimitLbl.text = "Betting limit".localizable
        self.bTitleLbl.text = "B".localizable
        self.pTitleLbl.text = "P".localizable
        self.tieTitleLbl.text = "Tie".localizable
        self.bPTitleLbl.text = "BP".localizable
        self.pPTitleLbl.text = "PP".localizable
        
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
