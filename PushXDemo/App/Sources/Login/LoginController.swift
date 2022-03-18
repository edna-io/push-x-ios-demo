//
//  LoginController.swift
//  NCE
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit
import EDNAPushX
import CoreGraphics

extension UIViewController {
    var topbarHeight: CGFloat {
        var height: CGFloat = 0
        
        if #available(iOS 13.0, *) {
            height += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        }
        
        height += self.navigationController?.navigationBar.frame.height ?? 0.0
        
        return height
    }
}

class LoginTypeButton: UIButton{
    var textLabel: UILabel!
    var arrowImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews(){
        textLabel = UILabel()
        addSubview(textLabel)
        
        arrowImageView = UIImageView()
        let arrowImage = UIImage(named: "ico_arrow_right")?.withRenderingMode(.alwaysTemplate)
        arrowImageView.image = arrowImage
        addSubview(arrowImageView)
        
        layer.cornerRadius = 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.frame.size
        let padding: CGFloat = 16
        
        let arrowImageViewSize = CGSize(width: 22, height: 22)
        let arrowImageViewTop = 0.5 * (selfSize.height - arrowImageViewSize.height)
        let arrowImageViewLeft = selfSize.width - arrowImageViewSize.width - padding
        let arrowImageViewFrame = CGRect(x: arrowImageViewLeft, y: arrowImageViewTop, width: arrowImageViewSize.width, height: arrowImageViewSize.height)
        arrowImageView.frame = arrowImageViewFrame
        
        let textLabelWidth = arrowImageViewFrame.midX - 2 * padding
        let textLabelFrame = CGRect(x: padding, y: 0, width: textLabelWidth, height: selfSize.height)
        textLabel.frame = textLabelFrame
    }
}

class TypeValueTextField: UITextField, UITextFieldDelegate{
    var onChanged: (() -> Void)?
    var isPhoneType: Bool = false{
        didSet{
            if isPhoneType{
                self.keyboardType = .numberPad
            }else{
                self.keyboardType = .default
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews(){
        self.delegate = self
        clearButtonMode = .whileEditing
        layer.cornerRadius = 4
    }
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 36 + 8) //16

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect{
        let x = bounds.maxX - 36
        let bPadding = UIEdgeInsets(top: 0, left: x, bottom: 0, right: 16);
        return bounds.inset(by: bPadding)
    }
    
    enum NumPrefix{
        case none
        case one
        case plus7
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        onChanged?()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        onChanged?()
        if isPhoneType {
            //Вводим только числа
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            let allowed = allowedCharacters.isSuperset(of: characterSet)
            if allowed {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                
                let prefix: NumPrefix
                if length > 0 && decimalString.hasPrefix("1") {
                    prefix = .one
                }else if length > 0 && decimalString.hasPrefix("7"){
                    prefix = .plus7
                }else{
                    prefix = .none
                }
                
                if length == 0 || (length > 10 && !(prefix != .none) )  || length > 11 {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if length > 2 {
                    switch prefix {
                    case .none:
                        break
                    case .one:
                        formattedString.append("1 ")
                        index += 1
                    case .plus7:
                        formattedString.append("+7 ")
                        index += 1
                    }
                }
                
                if (length - index) > 3 {
                    let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@) ", areaCode)
                    index += 3
                }
                if length - index > 3 {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                if length - index > 2 {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 2))
                    formattedString.appendFormat("%@-", prefix)
                    index += 2
                }

                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
            }else{
                return false
            }
        }else{
            return true
        }
    }
}

class LoginButton: UIButton {
    var normalColor: UIColor?
    var disableColor: UIColor?
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalColor : disableColor
        }
    }
}

class LoginView: UIView{
    var titleLabel: UILabel!
    var descLabel: UILabel!
    var typeButton: LoginTypeButton!
    var typeValueTextField: TypeValueTextField!
    var loginButton: LoginButton!
    
    var getTop : (() -> CGFloat)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func initViews(){
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .left
        addSubview(descLabel)
        
        typeButton = LoginTypeButton()
        addSubview(typeButton)
        
        typeValueTextField = TypeValueTextField()
        addSubview(typeValueTextField)
        
        loginButton = LoginButton()
        loginButton.layer.cornerRadius = 8
        addSubview(loginButton)
    }
    
    func getSizeByWidth(_ width: CGFloat, top: CGFloat, left: CGFloat, isUpdate: Bool) -> CGSize{
        
        let padding: CGFloat = 16
        let maxTextWidth = width - 2 * padding
        let sLeft = padding + left
        
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude))
        let titleLabelFrame = CGRect(x: sLeft, y: top, width: maxTextWidth, height: titleLabelSize.height)
        
        let descLabelSize = descLabel.sizeThatFits(CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude))
        let descLabelTop = titleLabelFrame.maxY + padding
        let descLabelFrame = CGRect(x: sLeft, y: descLabelTop, width: maxTextWidth, height: descLabelSize.height)
        
        let typeButtonTop = descLabelFrame.maxY + padding
        let typeButtonFrame = CGRect(x: sLeft, y: typeButtonTop, width: maxTextWidth, height: 44)
        
        let typeValueTextFieldTop = typeButtonFrame.maxY + padding
        let typeValueTextFieldFrame = CGRect(x: sLeft, y: typeValueTextFieldTop, width: maxTextWidth, height: 44)
        
        let loginButtonTop = typeValueTextFieldFrame.maxY + padding
        let loginButtonFrame = CGRect(x: sLeft, y: loginButtonTop, width: maxTextWidth, height: 50)
        
        if isUpdate{
            titleLabel.frame = titleLabelFrame
            descLabel.frame = descLabelFrame
            typeButton.frame = typeButtonFrame
            typeValueTextField.frame = typeValueTextFieldFrame
            loginButton.frame = loginButtonFrame
        }
        
        return CGSize(width: width, height: loginButtonFrame.maxY - top)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.frame.size
        
        let minTop: CGFloat = getTop?() ?? 0
        var left: CGFloat = 0
        var width = selfSize.width
        
        if #available(iOS 11.0, *) {
            width -= self.safeAreaInsets.left + self.safeAreaInsets.right
            left += self.safeAreaInsets.left
        }
        
        let size = getSizeByWidth(width, top: 0, left: left, isUpdate: false)
        var top = 0.5 * (selfSize.height - size.height)
        if top < minTop{
            top = minTop
        }

        _ = getSizeByWidth(width, top: top, left: left, isUpdate: true)
    }
}

class LoginController: UIViewController {
    // Значение типа по умолчанию
    var loginType: LoginType = .phoneNumber
    
    private var loginView: LoginView!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        self.view.backgroundColor = UIColor.colorThemeBackground()
        
        loginView.titleLabel.font = FontUtils.font("SFProDisplay-Regular", 22, .regular)
        loginView.titleLabel.textColor = UIColor.colorThemePrimary()
        
        loginView.descLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        loginView.descLabel.textColor = UIColor.colorThemePrimary()
        
        loginView.typeButton.titleLabel?.font = FontUtils.font("SFProText-Regular", 17, .regular)
        loginView.typeButton.backgroundColor = UIColor.colorThemeSettingsTable()
        loginView.typeButton.arrowImageView.tintColor = UIColor.colorThemeSecondary()
        
        loginView.typeValueTextField.backgroundColor = UIColor.colorThemeSettingsTable()
        loginView.typeValueTextField.font = FontUtils.font("SFProText-Regular", 17, .regular)
        loginView.typeValueTextField.textColor = UIColor.colorThemePrimary()
        
        
        loginView.loginButton.normalColor = UIColor.colorThemePrimary()
        loginView.loginButton.disableColor = UIColor.colorThemeSecondary()
        loginView.loginButton.isEnabled = loginView.loginButton.isEnabled
        loginView.loginButton.setTitleColor(UIColor.colorThemeBackground(), for: .normal)
    }
    
    private func showTitle(){
         self.navigationItem.title = nil
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
        
        showTitle()
        
        loginView = LoginView()
        self.view = loginView
        
        loginView.getTop = {
            return self.topbarHeight
        }
        
        loginView.typeButton.addTarget(self, action: #selector(selectTypeClick), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        loginView.typeValueTextField.onChanged = { [weak self] in
            self?.updateData()
        }
        
        if let userIdInfo = ConnectData.shared.userIdInfo{
            loginType = userIdInfo.idType
            loginView.typeValueTextField.text = userIdInfo.id
        }
        updateData()
        
        loginView.loginButton.setTitle(LocalizedString("login_btn"), for: .normal)
        loginView.titleLabel.text = LocalizedString("login_header")
        loginView.descLabel.text = LocalizedString("login_subheader")
        loginView.typeValueTextField.placeholder = LocalizedString("login_id")
        
        updateUI()
        loginView.setNeedsLayout()
    }
    
    private func updateData(){
        loginView.typeButton.textLabel.text = loginType.title()
        
        let typeButtonTextColor: UIColor?
        if loginType == .none{
            typeButtonTextColor = UIColor.colorThemeSecondary()?.withAlphaComponent(0.5)
        }else{
            typeButtonTextColor = UIColor.colorThemePrimary()
        }
        
        loginView.typeButton.textLabel?.textColor = typeButtonTextColor
        
        //обновить маску ввода
        self.loginView.typeValueTextField.isPhoneType = loginType == .phoneNumber
        
        //Обновить кнопку Login
        let textCount = loginView.typeValueTextField.text?.count ?? 0
        let loginViewEnabled = loginType != .none && textCount > 0
        loginView.loginButton.isEnabled = loginViewEnabled
    }
    
    @objc func loginClick(){
        if let type = loginType.toPushXUserIdType(), let id = loginView.typeValueTextField.text, id.count > 0 {
            ConnectData.shared.userIdInfo = LoginIdInfo(id: id, idType: loginType)
            EDNAPushX.login(userIdType: type, userId: id)
            Logger.log("[APP] pushX.login", params: ["id" : id])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func selectTypeClick() {
        let vc = LoginTypeController()
        vc.onChangeType = { [weak self] type in
            self?.loginType = type
            self?.updateData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
       guard let userInfo = notification.userInfo else { return }

       let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
       let endFrameY = endFrame?.origin.y ?? 0
       let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
       let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
       let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
       let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        var top = endFrame?.size.height ?? 0.0
        top -= self.view.frame.height - loginView.loginButton.frame.maxY - 8

        if let bounds = self.view?.bounds{
           if endFrameY >= UIScreen.main.bounds.size.height {
               self.view?.bounds = CGRect(x: bounds.minX, y: 0, width: bounds.width, height: bounds.height)
           } else {
               self.view?.bounds = CGRect(x: bounds.minX, y: top, width: bounds.width, height: bounds.height)
           }
        }

       UIView.animate(
         withDuration: duration,
         delay: TimeInterval(0),
         options: animationCurve,
         animations: { self.view.layoutIfNeeded() },
         completion: nil)
     }
}
