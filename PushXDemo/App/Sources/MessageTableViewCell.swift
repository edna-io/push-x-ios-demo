//
//  MessageTableViewCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 09.02.2022.
//

import UIKit
import CoreGraphics

class MessageTableViewCell: UITableViewCell {
    private var logoImageView: UIImageView!
    private var actionLabel: UILabel!
    private var dateLabel: UILabel!
    private var titleLabel: UILabel!
    private var bodyLabel: UILabel!
    
    private var pushImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        actionLabel.font = FontUtils.font("SFProText-Regular", 12, .regular)
        dateLabel.font = FontUtils.font("SFProText-Regular", 12, .regular)
        titleLabel.font = FontUtils.font("SFProText-Semibold", 17, .semibold)
        bodyLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        
        logoImageView.image = UIImage(named: "ico_small_app")?.withRenderingMode(.alwaysOriginal)
        self.backgroundColor = UIColor.colorThemeBackground()
        actionLabel.textColor = UIColor.colorThemeSecondary()
        dateLabel.textColor = UIColor.colorThemeSecondary()
        
        titleLabel.textColor = UIColor.colorThemePrimary()
        bodyLabel.textColor = UIColor.colorThemeSecondary()
    }
    
    func fill(pushViewData: PushViewData){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12

        let action: String
        if let value = pushViewData.action{
            switch value {
            case .deeplink(_):
                action = LocalizedString("push_list_nav_info_btn")
            case .button(_, name: let name):
                action = String(format: LocalizedString("push_list_nav_info"), name ?? "")
                //"Переход по кнопке “\(name)”"
            }
        }else{
            action = ""
        }
        
        
        let dateStr = pushViewData.dateAsListStr ?? "-"
        
        let appName = LocalizedString("push_app_name")
        
        actionLabel.attributedText = NSMutableAttributedString(string: "\(appName) \(action)", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        dateLabel.attributedText = NSMutableAttributedString(string: dateStr, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        let titleText = pushViewData.title ?? ""
        let short = pushViewData.body ?? ""
        
        paragraphStyle.lineHeightMultiple = 1.08
        titleLabel.attributedText = NSMutableAttributedString(string: titleText, attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: titleLabel.font!])
        
        bodyLabel.attributedText = NSMutableAttributedString(string: short, attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        if let logoUrl = pushViewData.logoURL{
            FileStore.downloadImage(from: logoUrl, complition: { [weak self] image in
                DispatchQueue.main.async() { [weak self] in
                    self?.pushImageView.image = image
                    self?.setNeedsLayout()
                }
            })
        }else{
            pushImageView.image = nil
        }
        
        updateUI()
        setNeedsLayout()
    }
    
    func initViews(){
        logoImageView = UIImageView()
        self.contentView.addSubview(logoImageView)
        
        actionLabel = UILabel()
        self.contentView.addSubview(actionLabel)
        
        dateLabel = UILabel()
        self.contentView.addSubview(dateLabel)
        
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        
        pushImageView = UIImageView()
        pushImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(pushImageView)
        
        bodyLabel = UILabel()
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.numberOfLines = 0
        self.contentView.addSubview(bodyLabel)
    }
    
    func getSizeByWidth(_ width: CGFloat, isUpdate: Bool) -> CGSize{
        let padding: CGFloat = 16
        //Logo
        let logoImageViewFrame = CGRect(x: padding, y: padding, width: 20, height: 20)
        
        let leftTextPadding = logoImageViewFrame.maxX + 4
        let maxTextWidth = width - leftTextPadding - padding
        let maxTextSize = CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude)
        let titleAndDateLineY = logoImageViewFrame.minY + 0.5 * logoImageViewFrame.height

        //Date
        let dateLabelSize = dateLabel.sizeThatFits(maxTextSize)
        let dateLabelTop = titleAndDateLineY - 0.5 * dateLabelSize.height
        let dateLabelLeft = width - padding - dateLabelSize.width
        let dateLabelFrame = CGRect(x: dateLabelLeft, y: dateLabelTop, width: dateLabelSize.width, height: dateLabelSize.height)
        
        //Action
        let actionLabelSize = actionLabel.sizeThatFits(maxTextSize)
        let actionLabelTop = titleAndDateLineY - 0.5 * actionLabelSize.height
        let actionLabelWidth = maxTextWidth - dateLabelFrame.width - 4
        let actionLabelFrame = CGRect(x: leftTextPadding, y: actionLabelTop, width: actionLabelWidth, height: actionLabelSize.height)
        
        //pushImageView
        let pushImageViewSize = pushImageView.image==nil ? CGSize(width: -padding, height: 0) : CGSize(width: 36, height: 36)
        let pushImageViewTop = actionLabelFrame.maxY + padding
        let pushImageViewLeft = width - padding - pushImageViewSize.width
        let pushImageViewFrame = CGRect(x: pushImageViewLeft, y: pushImageViewTop, width: pushImageViewSize.width, height: pushImageViewSize.height)
        
        //Title
        let titleLabelWidth = maxTextWidth - pushImageViewFrame.minY - padding
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: titleLabelWidth, height: CGFloat.greatestFiniteMagnitude))
        let titleLabelTop = actionLabelFrame.maxY + padding
        let titleLabelFrame = CGRect(x: leftTextPadding, y: titleLabelTop, width: titleLabelWidth, height: titleLabelSize.height)
        
        //Text
        let bodyLabelSize = bodyLabel.sizeThatFits(maxTextSize)
        let bodyLabelTop = titleLabelFrame.maxY + padding
        let bodyLabelFrame = CGRect(x: leftTextPadding, y: bodyLabelTop, width: maxTextWidth, height: bodyLabelSize.height)
        
        
        if isUpdate{
            logoImageView.frame = logoImageViewFrame
            dateLabel.frame = dateLabelFrame
            actionLabel.frame = actionLabelFrame
            titleLabel.frame = titleLabelFrame
            pushImageView.frame = pushImageViewFrame
            bodyLabel.frame = bodyLabelFrame
        }
        
        //Return
        return CGSize(width: width, height: bodyLabelFrame.maxY + padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.contentView.frame.size
        let _ = getSizeByWidth(selfSize.width, isUpdate: true)
    }
}

class FontUtils{
    enum FontWeight{
        case medium
        case regular
        case bold
        case light
        case semibold
        
        
        @available(iOS 8.2, *)
        func fontWeight() -> UIFont.Weight{
            var res = UIFont.Weight.regular
            if self == .medium { res = UIFont.Weight.medium }
            if self == .bold { res = UIFont.Weight.bold }
            if self == .regular { res = UIFont.Weight.regular }
            if self == .light { res = UIFont.Weight.light }
            if self == .semibold { res = UIFont.Weight.semibold }
            return res
        }
    }
    
    // TODO Проверена. Почти ничего не разьехалось. Надо подумать/проверить.
    public static func fontScale(_ name: String, _ size: CGFloat, _ weight: FontWeight) -> UIFont{
        let iOSWidth = UIScreen.main.bounds.width
        let fontScale: CGFloat
        switch iOSWidth {
        case 320:
            fontScale = 1
        case 375:
            fontScale = 1.172
        case 414:
            fontScale = 1.29
            
        default:
            fontScale = 1
        }
        
        let newSize = (size * fontScale).rounded()
        
        if #available(iOS 8.2, *) {
            let fontWeight = weight.fontWeight()
            return UIFont.systemFont(ofSize: newSize, weight: fontWeight)
        } else {
            if let font = UIFont(name: name, size: newSize){
                return font
            }
            return UIFont.systemFont(ofSize: newSize)
        }
    }
    
    public static func font(_ name: String, _ size: CGFloat, _ weight: FontWeight) -> UIFont{
        if #available(iOS 8.2, *) {
            if let font = UIFont(name: name, size: size){
                return font
            }            
            let fontWeight = weight.fontWeight()
            return UIFont.systemFont(ofSize: size, weight: fontWeight)
        } else {
            if let font = UIFont(name: name, size: size){
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }
    }
}
