//
//  MessageDetailViewController.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit
import CoreGraphics

class MessageDetailNavController: UINavigationController{
}

class MessageDetailViewController: UIViewController{
    private var scrollView: MessageDetailScrollView?
    private var pushViewData: PushViewData?
    init(pushViewData: PushViewData) {
        self.pushViewData = pushViewData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        self.view.backgroundColor = UIColor.colorThemeBackground()
        scrollView?.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString("push_params_header")
        let infoButton = UIBarButtonItem(image: UIImage(named: "xmark"), style: .plain, target: self, action: #selector(closeClick(_:)))
        self.navigationItem.rightBarButtonItem = infoButton
        
        scrollView = MessageDetailScrollView()

        if let pushViewData = pushViewData{
            scrollView?.setPushViewData(pushViewData)
        }
        
        if let scrollView = scrollView{
            self.view = scrollView
        }
        
        scrollView?.navigationSubheaderLabel.text = LocalizedString("push_details_navigation_subheader")
        scrollView?.paramsSubheaderLabel.text = LocalizedString("push_details_params_subheader")
        scrollView?.collHeaderLabel.text = LocalizedString("push_details_collapsed_header")
        scrollView?.collTextLabel.text = LocalizedString("push_details_collapsed_text")
        scrollView?.collIconLabel.text = LocalizedString("push_details_collapsed_icon")
        scrollView?.extHeaderLabel.text = LocalizedString("push_details_extended_header")
        scrollView?.extTextLabel.text = LocalizedString("push_details_extended_text")
        scrollView?.extIconLabel.text = LocalizedString("push_details_extended_icon")
        scrollView?.additionalLabel.text = LocalizedString("push_details_additional_subheader")
    }
    
    @objc func closeClick(_ button: UIBarButtonItem){
        dismiss(animated: true)
    }
}

class MessageDetailScrollView: UIScrollView{
    fileprivate var navigationSubheaderLabel: UILabel!
    fileprivate var navigationSubheaderValueLabel: UILabel!
    
    fileprivate var paramsSubheaderLabel: UILabel!
    fileprivate var collHeaderLabel: UILabel!
    fileprivate var collHeaderValueLabel: UILabel!
    fileprivate var collTextLabel: UILabel!
    fileprivate var collTextValueLabel: UILabel!
    fileprivate var collIconLabel: UILabel!
    fileprivate var collIconValueLabel: UILabel!
    fileprivate var collIconView: UIImageView!
    fileprivate var extHeaderLabel: UILabel!
    fileprivate var extHeaderValueLabel: UILabel!
    fileprivate var extTextLabel: UILabel!
    fileprivate var extTextValueLabel: UILabel!
    fileprivate var extIconLabel: UILabel!
    fileprivate var extIconValueLabel: UILabel!
    fileprivate var extIconView: UIImageView!
    fileprivate var actionLabels = [UILabel]()
    fileprivate var additionalLabel: UILabel!
    fileprivate var jsonLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    fileprivate func updateUI(){
        navigationSubheaderLabel.font = FontUtils.font("SFProDisplay-Regular", 22, .regular)
        navigationSubheaderLabel.textColor = UIColor.colorThemePrimary()
        
        navigationSubheaderValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        navigationSubheaderValueLabel.textColor = UIColor.colorThemeSecondary()
        
        paramsSubheaderLabel.font = FontUtils.font("SFProDisplay-Regular", 22, .regular)
        paramsSubheaderLabel.textColor = UIColor.colorThemePrimary()
        
        collHeaderLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        collHeaderLabel.textColor = UIColor.colorThemeSecondary()
        
        collHeaderValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        collHeaderValueLabel.textColor = UIColor.colorThemeSecondary()
        
        collTextLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        collTextLabel.textColor = UIColor.colorThemeSecondary()
        
        collTextValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        collTextValueLabel.textColor = UIColor.colorThemeSecondary()
        
        collIconLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        collIconLabel.textColor = UIColor.colorThemeSecondary()
        
        collIconValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        collIconValueLabel.textColor = UIColor.colorThemeSecondary()
        
        extHeaderLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        extHeaderLabel.textColor = UIColor.colorThemeSecondary()
        
        extHeaderValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        extHeaderValueLabel.textColor = UIColor.colorThemeSecondary()
        
        extTextLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        extTextLabel.textColor = UIColor.colorThemeSecondary()
        
        extTextValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        extTextValueLabel.textColor = UIColor.colorThemeSecondary()
        
        extIconLabel.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
        extIconLabel.textColor = UIColor.colorThemeSecondary()
        
        extIconValueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        extIconValueLabel.textColor = UIColor.colorThemeSecondary()
        
        additionalLabel.font = FontUtils.font("SFProDisplay-Regular", 22, .regular)
        additionalLabel.textColor = UIColor.colorThemePrimary()
        
        jsonLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        jsonLabel.textColor = UIColor.colorThemeSecondary()
        
        if actionLabels.count > 0{
            for index in 0...actionLabels.count-1{
                let pos = (index + 1) % 3
                let label = actionLabels[index]
                if pos == 1 {
                    label.font = FontUtils.font("SFProDisplay-Regular", 12, .regular)
                    label.textColor = UIColor.colorThemeSecondary()
                }else{
                    label.font = FontUtils.font("SFProText-Regular", 17, .regular)
                    label.textColor = UIColor.colorThemeSecondary()
                }
            }
        }

    }
    
    private func initViews(){
        navigationSubheaderLabel = UILabel()
        addSubview(navigationSubheaderLabel)
        
        navigationSubheaderValueLabel = UILabel()
        navigationSubheaderValueLabel.textAlignment = .left
        navigationSubheaderValueLabel.lineBreakMode = .byWordWrapping
        navigationSubheaderValueLabel.numberOfLines = 0
        addSubview(navigationSubheaderValueLabel)
        
        paramsSubheaderLabel = UILabel()
        addSubview(paramsSubheaderLabel)
        
        collHeaderLabel = UILabel()
        addSubview(collHeaderLabel)
        
        collHeaderValueLabel = UILabel()
        collHeaderValueLabel.textAlignment = .left
        collHeaderValueLabel.lineBreakMode = .byWordWrapping
        collHeaderValueLabel.numberOfLines = 0
        addSubview(collHeaderValueLabel)
        
        collTextLabel = UILabel()
        addSubview(collTextLabel)
        
        collTextValueLabel = UILabel()
        collTextValueLabel.textAlignment = .left
        collTextValueLabel.lineBreakMode = .byWordWrapping
        collTextValueLabel.numberOfLines = 0
        addSubview(collTextValueLabel)
        
        collIconLabel = UILabel()
        addSubview(collIconLabel)
        
        collIconValueLabel = UILabel()
        collIconValueLabel.textAlignment = .left
        collIconValueLabel.lineBreakMode = .byWordWrapping
        collIconValueLabel.numberOfLines = 0
        addSubview(collIconValueLabel)
        
        collIconView = UIImageView()
        addSubview(collIconView)
        
        extHeaderLabel = UILabel()
        addSubview(extHeaderLabel)
        
        extHeaderValueLabel = UILabel()
        extHeaderValueLabel.textAlignment = .left
        extHeaderValueLabel.lineBreakMode = .byWordWrapping
        extHeaderValueLabel.numberOfLines = 0
        addSubview(extHeaderValueLabel)
        
        extTextLabel = UILabel()
        addSubview(extTextLabel)
        
        extTextValueLabel = UILabel()
        extTextValueLabel.textAlignment = .left
        extTextValueLabel.lineBreakMode = .byWordWrapping
        extTextValueLabel.numberOfLines = 0
        addSubview(extTextValueLabel)
        
        extIconLabel = UILabel()
        addSubview(extIconLabel)
        
        extIconValueLabel = UILabel()
        extIconValueLabel.textAlignment = .left
        extIconValueLabel.lineBreakMode = .byWordWrapping
        extIconValueLabel.numberOfLines = 0
        addSubview(extIconValueLabel)
        
        extIconView = UIImageView()
        addSubview(extIconView)
        
        additionalLabel = UILabel()
        addSubview(additionalLabel)
        
        jsonLabel = UILabel()
        jsonLabel.textAlignment = .left
        jsonLabel.lineBreakMode = .byWordWrapping
        jsonLabel.numberOfLines = 0
        addSubview(jsonLabel)
    }
    
    func setPushViewData(_ pushViewData: PushViewData){
        let underlineAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        //Action
        let actionTypeStr: String
        if let action = pushViewData.action {
            switch action {
            case .deeplink(action: let action):
                actionTypeStr = String(format: LocalizedString("push_details_nav_info_default"), action ?? "")
            case .button(action: let action, name: let name):
                actionTypeStr = String(format: LocalizedString("push_details_nav_info"), name ?? "", action ?? "")
            }
        }else{
            actionTypeStr = LocalizedString("push_details_no_nav_info")
        }
        navigationSubheaderValueLabel.text = actionTypeStr
        collHeaderValueLabel.text = pushViewData.title
        collTextValueLabel.text = pushViewData.body
        collIconValueLabel.attributedText = NSAttributedString(string: pushViewData.logoURL ?? "", attributes: underlineAttrs)
        jsonLabel.text = pushViewData.jsonStr
        
        if let logoUrl = pushViewData.logoURL{
            FileStore.downloadImage(from: logoUrl, complition: { [weak self] image in
                DispatchQueue.main.async() { [weak self] in
                    self?.collIconView.image = image
                    self?.setNeedsLayout()
                }
            })
        }else{
            collIconView.image = nil
        }
        
        extHeaderValueLabel.text = pushViewData.content?.title
        extTextValueLabel.text = pushViewData.content?.text
        extIconValueLabel.attributedText = NSAttributedString(string: pushViewData.content?.url ?? "", attributes: underlineAttrs)
        
        if let url = pushViewData.content?.url{
            FileStore.downloadImage(from: url, complition: { [weak self] image in
                DispatchQueue.main.async() { [weak self] in
                    self?.extIconView.image = image
                    self?.setNeedsLayout()
                }
            })
        }else{
            extIconView.image = nil
        }
        
        //actions
        var btnIndex = 0
        for action in pushViewData.actions{
            let btNameLabel = UILabel()
            btnIndex += 1
            btNameLabel.text =  String(format: LocalizedString("push_details_button"), btnIndex)
            addSubview(btNameLabel)
            actionLabels.append(btNameLabel)
            
            let btTitleLabel = UILabel()
            btTitleLabel.textAlignment = .left
            btTitleLabel.lineBreakMode = .byWordWrapping
            btTitleLabel.numberOfLines = 0
            btTitleLabel.text  = action.title
            addSubview(btTitleLabel)
            actionLabels.append(btTitleLabel)
            
            let btActionLabel = UILabel()
            btActionLabel.textAlignment = .left
            btActionLabel.lineBreakMode = .byWordWrapping
            btActionLabel.numberOfLines = 0
            btActionLabel.attributedText  = NSAttributedString(string: action.action, attributes: underlineAttrs)
            addSubview(btActionLabel)
            actionLabels.append(btActionLabel)
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.frame.size
        
        let padding: CGFloat = 16
        var maxContextWidth = selfSize.width - 2 * padding
        var left = padding
        
        if #available(iOS 11.0, *) {
            left += self.safeAreaInsets.left
            maxContextWidth -= self.safeAreaInsets.left + self.safeAreaInsets.right
        }
        
        
        let fitSize = CGSize(width: maxContextWidth, height: CGFloat.greatestFiniteMagnitude)
        
        //
        let navigationSubheaderLabelSize = navigationSubheaderLabel.sizeThatFits(fitSize)
        let navigationSubheaderLabelFrame = CGRect(x: left, y: padding, width: maxContextWidth, height: navigationSubheaderLabelSize.height)
        navigationSubheaderLabel.frame = navigationSubheaderLabelFrame
        
        //
        let navigationSubheaderValueLabelSize = navigationSubheaderValueLabel.sizeThatFits(fitSize)
        let navigationSubheaderValueLabelTop = navigationSubheaderLabelFrame.maxY + padding
        let navigationSubheaderValueLabelFrame = CGRect(x: left, y: navigationSubheaderValueLabelTop, width: maxContextWidth, height: navigationSubheaderValueLabelSize.height)
        navigationSubheaderValueLabel.frame = navigationSubheaderValueLabelFrame
        
        //
        let paramsSubheaderLabelSize = paramsSubheaderLabel.sizeThatFits(fitSize)
        let paramsSubheaderLabelTop = navigationSubheaderValueLabelFrame.maxY + padding
        let paramsSubheaderLabelFrame = CGRect(x: left, y: paramsSubheaderLabelTop, width: maxContextWidth, height: paramsSubheaderLabelSize.height)
        paramsSubheaderLabel.frame = paramsSubheaderLabelFrame
        
        //
        let collHeaderLabelSize = collHeaderLabel.sizeThatFits(fitSize)
        let collHeaderLabelTop = paramsSubheaderLabelFrame.maxY + padding
        let collHeaderLabelFrame = CGRect(x: left, y: collHeaderLabelTop, width: maxContextWidth, height: collHeaderLabelSize.height)
        collHeaderLabel.frame = collHeaderLabelFrame
        
        //
        let collHeaderValueLabelSize = collHeaderValueLabel.sizeThatFits(fitSize)
        let collHeaderValueLabelTop = collHeaderLabelFrame.maxY + padding
        let collHeaderValueLabelFrame = CGRect(x: left, y: collHeaderValueLabelTop, width: maxContextWidth, height: collHeaderValueLabelSize.height)
        collHeaderValueLabel.frame = collHeaderValueLabelFrame
        
        //
        let collTextLabelSize = collTextLabel.sizeThatFits(fitSize)
        let collTextLabelTop = collHeaderValueLabelFrame.maxY + padding
        let collTextLabelFrame = CGRect(x: left, y: collTextLabelTop, width: maxContextWidth, height: collTextLabelSize.height)
        collTextLabel.frame = collTextLabelFrame
        
        //
        let collTextValueLabelSize = collTextValueLabel.sizeThatFits(fitSize)
        let collTextValueLabelTop = collTextLabelFrame.maxY + padding
        let collTextValueLabelFrame = CGRect(x: left, y: collTextValueLabelTop, width: maxContextWidth, height: collTextValueLabelSize.height)
        collTextValueLabel.frame = collTextValueLabelFrame
        
        //
        let collIconLabelSize = collIconLabel.sizeThatFits(fitSize)
        let collIconLabelTop = collTextValueLabelFrame.maxY + padding
        let collIconLabelFrame = CGRect(x: left, y: collIconLabelTop, width: maxContextWidth, height: collIconLabelSize.height)
        collIconLabel.frame = collIconLabelFrame
        
        //
        let collIconValueLabelSize = collIconValueLabel.sizeThatFits(fitSize)
        let collIconValueLabelTop = collIconLabelFrame.maxY + padding
        let collIconValueLabelFrame = CGRect(x: left, y: collIconValueLabelTop, width: maxContextWidth, height: collIconValueLabelSize.height)
        collIconValueLabel.frame = collIconValueLabelFrame
        
        //
        let collIconViewFrame: CGRect
        if let image = collIconView.image{
            let collIconViewSize = image.size
            let collIconViewTop = collIconValueLabelFrame.maxY + padding
            //
            let startHeight: CGFloat = 36
            let calcWidth = (startHeight / collIconViewSize.height) * collIconViewSize.width
            let calcSize: CGSize
            if calcWidth > maxContextWidth{
                let newHeight = (maxContextWidth / collIconViewSize.width) * collIconViewSize.height
                calcSize = CGSize(width: maxContextWidth, height: newHeight)
            }else{
                calcSize = CGSize(width: calcWidth, height: startHeight)
            }
            //
            collIconViewFrame = CGRect(x: left, y: collIconViewTop, width: calcSize.width, height: calcSize.height)
        }else{
            collIconViewFrame = CGRect(x: left, y: collIconValueLabelFrame.maxY, width: 0, height: 0)
        }
        collIconView.frame = collIconViewFrame
        
        //
        let extHeaderLabelSize = extHeaderLabel.sizeThatFits(fitSize)
        let extHeaderLabelTop = collIconViewFrame.maxY + padding
        let extHeaderLabelFrame = CGRect(x: left, y: extHeaderLabelTop, width: maxContextWidth, height: extHeaderLabelSize.height)
        extHeaderLabel.frame = extHeaderLabelFrame
        
        //
        let extHeaderValueLabelSize = extHeaderValueLabel.sizeThatFits(fitSize)
        let extHeaderValueLabelTop = extHeaderLabelFrame.maxY + padding
        let extHeaderValueLabelFrame = CGRect(x: left, y: extHeaderValueLabelTop, width: maxContextWidth, height: extHeaderValueLabelSize.height)
        extHeaderValueLabel.frame = extHeaderValueLabelFrame
        
        //
        let extTextLabelSize = extTextLabel.sizeThatFits(fitSize)
        let extTextLabelTop = extHeaderValueLabelFrame.maxY + padding
        let extTextLabelFrame = CGRect(x: left, y: extTextLabelTop, width: maxContextWidth, height: extTextLabelSize.height)
        extTextLabel.frame = extTextLabelFrame
        
        //
        let extTextValueLabelSize = extTextValueLabel.sizeThatFits(fitSize)
        let extTextValueLabelTop = extTextLabelFrame.maxY + padding
        let extTextValueLabelFrame = CGRect(x: left, y: extTextValueLabelTop, width: maxContextWidth, height: extTextValueLabelSize.height)
        extTextValueLabel.frame = extTextValueLabelFrame
        
        //
        let extIconLabelSize = extIconLabel.sizeThatFits(fitSize)
        let extIconLabelTop = extTextValueLabelFrame.maxY + padding
        let extIconLabelFrame = CGRect(x: left, y: extIconLabelTop, width: maxContextWidth, height: extIconLabelSize.height)
        extIconLabel.frame = extIconLabelFrame
        
        //
        let extIconValueLabelSize = extIconValueLabel.sizeThatFits(fitSize)
        let extIconValueLabelTop = extIconLabelFrame.maxY + padding
        let extIconValueLabelFrame = CGRect(x: left, y: extIconValueLabelTop, width: maxContextWidth, height: extIconValueLabelSize.height)
        extIconValueLabel.frame = extIconValueLabelFrame
        
        //
        let extIconViewFrame: CGRect
        if let image = extIconView.image{
            let extIconViewSize = image.size
            let extIconViewTop = extIconValueLabelFrame.maxY + padding
            let extIconViewHeight = (maxContextWidth / extIconViewSize.width) * extIconViewSize.height
            extIconViewFrame = CGRect(x: left, y: extIconViewTop, width: maxContextWidth, height: extIconViewHeight)
        }else{
            extIconViewFrame = CGRect(x: left, y: extIconValueLabelFrame.maxY, width: 0, height: 0)
        }
        extIconView.frame = extIconViewFrame
        
        //actions
        var actionLabelFrame: CGRect = extIconViewFrame
        for actionLabel in actionLabels{
            let row = (actionLabels.firstIndex(of: actionLabel) ?? 0) % 3
            
            let actionLabelSize = actionLabel.sizeThatFits(fitSize)
            var actionLabelTop = actionLabelFrame.maxY + padding
            if row == 2{
                actionLabelTop -= padding
            }
            actionLabelFrame = CGRect(x: left, y: actionLabelTop, width: maxContextWidth, height: actionLabelSize.height)
            actionLabel.frame = actionLabelFrame
        }
        
        //
        let additionalLabelSize = additionalLabel.sizeThatFits(fitSize)
        let additionalLabelTop = actionLabelFrame.maxY + padding
        let additionalLabelFrame = CGRect(x: left, y: additionalLabelTop, width: maxContextWidth, height: additionalLabelSize.height)
        additionalLabel.frame = additionalLabelFrame
        
        //
        let jsonLabelSize = jsonLabel.sizeThatFits(fitSize)
        let jsonLabelTop = additionalLabelFrame.maxY + padding
        let jsonLabelFrame = CGRect(x: left, y: jsonLabelTop, width: maxContextWidth, height: jsonLabelSize.height)
        jsonLabel.frame = jsonLabelFrame
        
        // Set size
        let height = jsonLabelFrame.maxY + padding
        contentSize = CGSize(width: selfSize.width, height: height)
    }
}
