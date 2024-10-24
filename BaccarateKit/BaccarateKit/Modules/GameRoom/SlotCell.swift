//
//  SlotCell.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import Foundation
import UIKit
import SpreadsheetView
class SlotCell: Cell {
    @IBOutlet  weak var imgIcon: UIImageView!
    @IBOutlet  weak var titleLbl: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLbl?.font = UIFont.appFont(family: .medium, size: 9)
        if Display.typeIsLike == .iphone5 {
            self.titleLbl?.font = UIFont(name: fontName, size: 10)!
        }
        self.backgroundColor = .roadMapBgColor
    }
    func setData(dataArr: [BigRoadMapData], indexPath: IndexPath, spreadsheetView: SpreadsheetView) {
        self.backgroundColor = .roadMapBgColor
        if dataArr.count > 0 {
            let objArr = dataArr.filter({$0.column == indexPath.column && $0.row == indexPath.row})
            if objArr.count > 0 {
                let obj = objArr[0]
                if obj.isAnimate == false {
                self.titleLbl.text = ""
                //    self.setBorderOnCell(node: obj)
                if obj.column != nil && indexPath.column == obj.column! {
                    self.imgIcon.image = UIImage(named: obj.name ?? "empty")
                } else {
                    self.imgIcon.image = UIImage(named: "empty")
                }
                if spreadsheetView.tag == 786 {   // bread Plate SpreadSheetView
                    self.titleLbl.text = "P".localizable
                    if (obj.name ?? "").contains("tie") {
                        self.titleLbl.text = "T".localizable
                    } else if (obj.name ?? "").contains("player") {
                        self.titleLbl.text = "P".localizable
                    } else if (obj.name ?? "").contains("banker") {
                        self.titleLbl.text = "B".localizable
                    }
                }
                if (obj.name ?? "").contains("T") && obj.tieCount > 1 {
                    let newIcon = (obj.name ?? "").replacingOccurrences(of: "T", with: "")
                    if obj.column != nil && indexPath.column == obj.column! {
                        self.imgIcon.image = UIImage(named: newIcon)
                    } else {
                        self.imgIcon.image = UIImage(named: "empty")
                    }
                    self.titleLbl.text = "\(obj.tieCount)"
                    self.titleLbl.textColor = .tieColor
                } else {
                    self.titleLbl.textColor = .white
                    // self.titleLbl.text = ""
                }
                } else {
                    self.imgIcon.image = UIImage(named: "empty")
                }
            } else {
                self.imgIcon.image = UIImage(named: "empty")
            }
        } else {
            self.imgIcon.image = UIImage(named: "empty")
        }
    }
    func setBorderOnCell(node: BigRoadMapData) {
        var borderColor = UIColor.yellow
        if (node.name ?? "").contains("banker") {
            borderColor = bankerColor
        } else if (node.name ?? "").contains("player") {
            borderColor = playerColor
        } else if (node.name ?? "").contains("tie") {
            borderColor = tieColor
        } else if (node.name ?? "").contains("red") {
            borderColor = bankerColor
        } else if (node.name ?? "").contains("blue") {
            borderColor = playerColor
        }
        self.borders.top = .solid(width: 1, color: borderColor)
        self.borders.left = .solid(width: 1, color: borderColor)
        self.borders.bottom = .solid(width: 1, color: borderColor)
        self.borders.right = .solid(width: 1, color: borderColor)
    }
}
