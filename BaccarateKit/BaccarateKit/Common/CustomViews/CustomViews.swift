//
//  CustomViews.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
// swiftlint:disable superfluous_disable_command file_length self_in_property_initialization
import UIKit
import MBProgressHUD
import Lottie
class Indicator {
    static let shared = Indicator()
    
    private init() {}
    
    func showIndictorView(indicatoreTitle: String) {
        if let window = Utils.windowKey {
            let hud =  MBProgressHUD.showAdded(to: window, animated: true) as MBProgressHUD
            hud.label.text = indicatoreTitle
        } else if let window = windowG {
            let hud =  MBProgressHUD.showAdded(to: window, animated: true) as MBProgressHUD
            hud.label.text = indicatoreTitle
        }
    }
    
    func hideIndictorView() {
        if let window = Utils.windowKey {
            MBProgressHUD.hide(for: window, animated: true)
        } else if let window = windowG {
            MBProgressHUD.hide(for: window, animated: true)
        }
    }
    
    class func showIndictorAtSubView(indicatoreTitle: String, sView: UIView) {
        let hud =  MBProgressHUD.showAdded(to: sView, animated: true) as MBProgressHUD
        hud.label.text =  ""  // IndicatoreTitle
        hud.label.font = UIFont(name: "Helvetica Neue", size: 11)
    }
    
    class func hideIndictorAtSubView(sView: UIView) {
        MBProgressHUD.hide(for: sView, animated: true)
    }
}

class CustView: UIView {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    private func provideAnimation(animationDuration: TimeInterval, deleyTime: TimeInterval,
                                  springDamping: CGFloat, springVelocity: CGFloat) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}

class CardView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        self.layer.borderColor =  UIColor(red: 221, green: 221, blue: 221, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
}

class CardViewLarge: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        self.layer.borderColor =  UIColor(red: 221, green: 221, blue: 221, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
}

class RoundView: UIView {
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

class RoundView2: UIView {
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if newValue != nil {
                self.layer.cornerRadius = 10
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowOpacity = 1
                self.layer.shadowRadius = 2
                self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

class FieldView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor(hex: AppColors.shadowColor).cgColor
    }
}
class FieldViewLogin: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor(hex: AppColors.shadowColor).cgColor
        self.layer.borderColor = UIColor(hex: "F7CE56").cgColor
        self.layer.borderWidth = 1
    }
}

class CustBtn: UIButton {
    
    @IBInspectable public var borderColor: UIColor = UIColor.green {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

class RoundButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        self.setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        self.setTitleColor(UIColor.lightGray, for: .disabled)
        if self.isEnabled {
            self.backgroundColor = UIColor(hex: AppColors.themeColor)
            self.tintColor = .white
        } else {
            self.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
            self.tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }
    func setEnable(value: Bool) {
        self.isEnabled = value
        if self.isEnabled {
            self.backgroundColor = UIColor(hex: AppColors.themeColor)
            self.tintColor = .white
        } else {
            self.backgroundColor = UIColor(hex: AppColors.disableColor)
            
            //   UIColor(red: 239, green: 239, blue: 239, alpha: 1)
            self.tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
            self.isHidden = false
        }
    }
}
class RoundBtnWithBorder: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        self.setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor(hex: "FB8954").cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        self.setBackgroundImage(UIImage(named: "btnBgImage"), for: .normal)
        self.setBackgroundImage(UIImage(named: "btnBgImage"), for: .selected)
        self.setBackgroundImage(UIImage(named: "btnBgImage"), for: .highlighted)
        if self.isEnabled {
            self.backgroundColor = UIColor(hex: AppColors.themeColor)
            self.tintColor = .white
        } else {
            self.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
            self.tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }
}

class BtnSlotNumber: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
}

class RoundButtonCancel: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14)
        self.setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        if self.isEnabled {
            self.backgroundColor = UIColor.gray
            self.tintColor = .white
        } else {
            self.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
            self.tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }
}

class RoundSmallBtn: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 10)
        self.setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        if self.isEnabled {
            self.backgroundColor = UIColor(red: 20, green: 26, blue: 70, alpha: 1)
            self.tintColor = .white
        } else {
            self.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
            self.tintColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
        }
    }
}

class SegmentButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = .appFont(family: .medium, size: 12)
        layer.cornerRadius = 4.0
    }
}

class RoundLightBtn: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 10)
        self.setTitleColor(UIColor(red: 140, green: 140, blue: 140, alpha: 1), for: .normal)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        self.backgroundColor = .clear
    }
}
/*
class RoundLoginBtn: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        self.titleLabel?.font = .appFont(family: .medium, size: 14)
        self.setBackgroundImage(UIImage(named: "common_btn"), for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        //        self.setTitleColor(UIColor(red: 140, green: 140, blue: 140, alpha: 1), for: .normal)
        //        layer.borderColor = UIColor.clear.cgColor
        //        layer.borderWidth = 1.0
        //        layer.cornerRadius = 8.0
        //        self.backgroundColor = .clear
        //        self.setBackgroundImage(UIImage(named: "login_input_bg"), for: .normal)
        //        self.setBackgroundImage(UIImage(named: "login_input_bg"), for: .selected)
        //        self.setBackgroundImage(UIImage(named: "login_input_bg"), for: .highlighted)
    }
}
*/
class RoundLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
}

class TtlFieldLbl: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        self.textColor = .primary
        self.font = .appFont(family: .medium, size: 14)
    }
}

class TtlProfileLbl: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.textColor = .primary
        self.font = .appFont(family: .medium, size: 16)
    }
}

class TitleLbl: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.textColor = .primary
        self.font = .appFont(family: .demibold, size: 20)
    }
}

class TitleLightLbl: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        let titleFont =  "SFProText-Semibold"
        self.textColor = .black
        self.font = UIFont(name: titleFont, size: 10)
    }
}

class LightLbl: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        let titleFont =  "SFProText-Regular"
        self.textColor = .darkGray
        self.font = UIFont(name: titleFont, size: 12)
    }
}

class TtlLightSmallLbl: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        let titleFont =  "SFProText-Regular"
        self.textColor = .black
        self.font = UIFont(name: titleFont, size: 9)
    }
}

class RoomListLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        self.textColor = .primary
        self.font = .appFont(family: .regular, size: 14)
        if UserPreference.shared.getIsDarkMode() == true {
            self.textColor = .white
        }
    }
}

class TxtField: UITextField {
    
    var btnRight: UIButton!
    
    @objc func actionClicked(btn: UIButton) {
        btnRight.isSelected = !(btnRight.isSelected)
        self.isSecureTextEntry = !(btnRight.isSelected)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.btnRight = UIButton(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
    }
    
    func setLeftIcone(image: UIImage) {
        let lview = UIView(frame: CGRect(x: 30, y: 30, width: 150, height: 15))
        let btnLeft = UIButton(frame: CGRect(x: 30, y: 0, width: 15, height: 15))
        lview.backgroundColor = .red
        btnLeft.setImage(image, for: .normal)
        btnLeft.setImage(image, for: .selected)
        btnLeft.setImage(image, for: .highlighted)
        btnLeft.backgroundColor = .clear
        lview.addSubview(btnLeft)
        self.leftView = lview
        self.leftView?.backgroundColor = .clear
        self.leftViewMode = .always
    }
    
    @IBInspectable var leftMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            let lview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 15))
            let btnLeft = UIButton(frame: CGRect(x: 20, y: 0, width: 15, height: 15))
            btnLeft.setImage(leftMenuIcon, for: .normal)
            btnLeft.setImage(leftMenuIcon, for: .selected)
            btnLeft.setImage(leftMenuIcon, for: .highlighted)
            lview.addSubview(btnLeft)
            self.leftView = lview
            lview.backgroundColor = .clear
            btnLeft.backgroundColor = .clear
            self.leftViewMode = .always
            let rview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 15))
            rview.backgroundColor = .clear
        }
    }
    
    @IBInspectable var rightMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            let lview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
            btnRight.setImage(rightMenuIcon, for: .normal)
            if self.isSecureTextEntry == true {
                btnRight.addTarget(self, action: #selector(actionClicked(btn:)), for: .touchUpInside)
                btnRight.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                btnRight.setImage(UIImage(systemName: "eye"), for: .selected)
            }
            lview.addSubview(btnRight)
            self.rightView = lview
            lview.backgroundColor = .clear
            btnRight.backgroundColor = .clear
            self.rightViewMode = .always
            self.tintColor = .lightGray
        }
    }
    
    @IBInspectable var selRightMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            btnRight.setImage(selRightMenuIcon, for: .selected)
        }
    }
}

class KKNewTxtField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        self.borderStyle = .none
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
    }
}

class DisableCopyPasteTextField: TxtField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

class OneTxtField: UITextField {
    
    var btnRight: UIButton!
    var btnLeft: UIButton!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.setLeftIcone(imageSel: "clearColorImg", imageUnsel: "editIcon")
        self.setRightIcone(imageSel: "tickIcon", imageUnsel: "warningIcon")
    }
    
    func setLeftIcone(imageSel: String, imageUnsel: String) {
        btnLeft = UIButton(type: .custom)
        btnLeft.setImage(UIImage(named: "tickIcon"), for: .selected)
        btnLeft.setImage(UIImage(named: "warningIcon"), for: .normal)
        let lview = UIView(frame: CGRect(x: 5, y: 30, width: 30, height: 20))
        btnLeft.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        lview.addSubview(btnLeft)
        self.leftView = lview
        self.leftViewMode = .always
    }
    
    func setRightIcone(imageSel: String, imageUnsel: String) {
        btnRight = UIButton(type: .custom)
        btnRight.setImage(UIImage(named: "editIcon"), for: .normal)
        btnRight.setImage(UIImage(named: "clearColorImg"), for: .selected)
        let lview = UIView(frame: CGRect(x: 0, y: 30, width: 20, height: 20))
        btnRight.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        lview.addSubview(btnRight)
        self.rightView = lview
        self.rightViewMode = .always
    }
}

class KKTxtField: UITextField {
    
    var btnRight: UIButton!
    
    @objc func actionClicked(btn: UIButton) {
        btnRight.isSelected = !(btnRight.isSelected)
        self.isSecureTextEntry = !(btnRight.isSelected)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        let txtFontSize: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6) ? 15.0: 16.0
        self.font = .appFont(family: .medium, size: txtFontSize)
        self.btnRight = UIButton(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        self.backgroundColor = .clear
        self.borderStyle = .roundedRect
    }
    
    func setLeftIcone(image: UIImage) {
        let lview = UIView(frame: CGRect(x: 30, y: 30, width: 150, height: 20))
        let btnLeft = UIButton(frame: CGRect(x: 30, y: 0, width: 20, height: 20))
        lview.backgroundColor = .red
        btnLeft.setImage(image, for: .normal)
        btnLeft.setImage(image, for: .selected)
        btnLeft.setImage(image, for: .highlighted)
        btnLeft.backgroundColor = .clear
        lview.addSubview(btnLeft)
        self.leftView = lview
        self.leftView?.backgroundColor = .clear
        self.leftViewMode = .always
    }
    
    @IBInspectable var leftMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            let lview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 20))
            let btnLeft = UIButton(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
            btnLeft.setImage(leftMenuIcon, for: .normal)
            btnLeft.setImage(leftMenuIcon, for: .selected)
            btnLeft.setImage(leftMenuIcon, for: .highlighted)
            lview.addSubview(btnLeft)
            self.leftView = lview
            lview.backgroundColor = .clear
            btnLeft.backgroundColor = .clear
            self.leftViewMode = .always
            let rview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 20))
            rview.backgroundColor = .clear
        }
    }
    
    @IBInspectable var rightMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            let lview = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
            btnRight.setImage(rightMenuIcon, for: .normal)
            if self.isSecureTextEntry == true {
                btnRight.addTarget(self, action: #selector(actionClicked(btn:)), for: .touchUpInside)
                btnRight.setImage(UIImage(systemName: "login_btn_password_0"), for: .selected)
            }
            lview.addSubview(btnRight)
            self.rightView = lview
            lview.backgroundColor = .clear
            btnRight.backgroundColor = .clear
            self.rightViewMode = .always
            self.tintColor = .lightGray
        }
    }
    @IBInspectable var selRightMenuIcon: UIImage = UIImage(named: "clearColorImg")! {
        didSet {
            btnRight.setImage(selRightMenuIcon, for: .selected)
        }
    }
}
extension UITextField {
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

class RoundBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor(hex: AppColors.themeColor)
        self.layer.cornerRadius = 8
        self.setTitle("View All", for: .normal)
        let titleFont = "SFProText-Semibold"
        self.titleLabel?.font = UIFont(name: titleFont, size: 12)
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EdgeInsetLabel: UILabel {
    
    static let shared = EdgeInsetLabel()
    
    private override init(frame: CGRect) {
        super.init(frame: .zero)
        self.tag = 9830384
        self.layer.cornerRadius = (18 / 2)
        self.textAlignment = .center
        self.layer.masksToBounds = true
        self.textColor = .white
        self.font = .systemFont(ofSize: 11)
        self.backgroundColor = .red
        self.isHidden = true
        self.textInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

class BadgeCountFavorite: EdgeInsetLabel {
    var badgeCountFav: Int = 0 {
        didSet {
            self.text = "\(badgeCountFav)"
            if badgeCountFav <= 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    static let sharedFavInstance = BadgeCountFavorite()
}

class BadgeCountCart: EdgeInsetLabel {
    var badgeCountCart: Int = 0 {
        didSet {
            self.text = "\(badgeCountCart)"
            if badgeCountCart <= 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    static let sharedCartInstance = BadgeCountCart()
}

class BadgeCountNotification: EdgeInsetLabel {
    var badgeCountNotifi: Int = 0 {
        didSet {
            self.text = "\(badgeCountNotifi)"
            if badgeCountNotifi <= 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    static let sharedNotiInstance = BadgeCountNotification()
}
class CircularProgressBarView: UIView {
    let circleRadius: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6) ? 28.0: 35.0
     var circleLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: circleRadius,
                                                           y: circleRadius),
                                        radius: circleRadius, startAngle: startPoint, endAngle: endPoint,
                                        clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 6.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.green.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    func resetCircularPath() {
        circleLayer = CAShapeLayer()
        progressLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: circleRadius,
                                                           y: circleRadius),
                                        radius: circleRadius,
                                        startAngle: startPoint,
                                        endAngle: endPoint,
                                        clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 6.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.clear.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    func updateColorbyTableColor(tableColor: String) {
            startColor = UIColor(red: 83/255, green: 0, blue: 2/255, alpha: 0.22)
            endColor =  UIColor(hex: tableColor)
        self.updateColors()
        self.updatePoints()
        self.updateLocations()
    }
    func updateColorbyTableNum(tableColor: String) {
       // startColor = UIColor(red: 83/255, green: 0, blue: 2/255, alpha: 0.22)
        startColor = UIColor(hex: tableColor, alpha: 0.22)
        endColor =  UIColor(hex: tableColor)
        self.updateColors()
        self.updatePoints()
        self.updateLocations()
    }
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}

class LineViewGame: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateView() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateView() }}
    var gradientLayer =  CAGradientLayer()
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
//    func updateColors() {
//        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//    }
    func updateView() {
        //  let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        let color1 = startColor
        let color2 = endColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        // Set the frame to the layer
        gradientLayer.frame = self.frame
        // Add the gradient layer as a sublayer to the background view
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
