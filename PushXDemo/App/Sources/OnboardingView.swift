//
//  OnboardingView.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//
import UIKit
import CoreGraphics

class OnboardingView: UIView{
    var imageView: UIImageView!
    var textLabel: UILabel!
    var subTextLabel: UILabel!
    var loginButton: UIButton!
    
    var getTop : (() -> CGFloat)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    private func updateUI(){
        self.backgroundColor = UIColor.colorThemeBackground()
    }
    
    private func initViews(){
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        textLabel = UILabel()
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        subTextLabel = UILabel()
        subTextLabel.lineBreakMode = .byWordWrapping
        subTextLabel.numberOfLines = 0
        subTextLabel.textAlignment = .left
        addSubview(subTextLabel)
        
        loginButton = UIButton()
        loginButton.layer.cornerRadius = 8
        addSubview(loginButton)
        
        updateUI()
    }
    
    @discardableResult func getSizeByWidth(_ width: CGFloat, top: CGFloat, left: CGFloat, isUpdate: Bool) -> CGSize{
        
        let padding: CGFloat = 16
        let maxTextWidth = width - 2 * padding
        let sLeft = padding + left
        
        let textLabelSize = textLabel.sizeThatFits(CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude))
        let textLabelFrame = CGRect(x: sLeft, y: top, width: maxTextWidth, height: textLabelSize.height)
        
        let subTextLabelSize = subTextLabel.sizeThatFits(CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude))
        let subTextLabelTop = textLabelFrame.maxY + padding
        let subTextLabelFrame = CGRect(x: sLeft, y: subTextLabelTop, width: maxTextWidth, height: subTextLabelSize.height)
        
        let loginButtonFrame: CGRect
        if loginButton.isHidden {
            loginButtonFrame = CGRect(x: sLeft, y: subTextLabelFrame.maxY, width: 0, height: 0)
        }else{
            let loginButtonTop = subTextLabelFrame.maxY + padding
            loginButtonFrame = CGRect(x: sLeft, y: loginButtonTop, width: maxTextWidth, height: 50)
        }
        
        if isUpdate{
            textLabel.frame = textLabelFrame
            subTextLabel.frame = subTextLabelFrame
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
        
        var nextTop: CGFloat = 0
        //Image
        let imageMaxHeight = selfSize.height - size.height - 3 * 16 - minTop
        if let originImage = imageView.image, imageMaxHeight > 100{
            let imagePadding: CGFloat = 24
            let originSize = originImage.size
            
            var imageViewWidth = selfSize.width - 2 * imagePadding
            var imageViewHeight = imageViewWidth * originSize.height / originSize.width
            
            let imageMaxHeight = selfSize.height - size.height - 3 * 16 - minTop
            
            if imageViewHeight > imageMaxHeight{
                imageViewHeight = imageMaxHeight
                imageViewWidth = imageViewHeight * originSize.width / originSize.height
            }
            
            let top = 0.5 * (selfSize.height - 16 - imageViewHeight - size.height)
            
            let left = 0.5 * (selfSize.width - imageViewWidth)
            
            let imageViewFrame = CGRect(x: left, y: top, width: imageViewWidth, height: imageViewHeight)
            nextTop = imageViewFrame.maxY + 16
            imageView.frame = imageViewFrame
            imageView.isHidden = false
        }else{
            imageView.isHidden = true
        }
        
        
        var top = 0.5 * (selfSize.height - size.height)
        if top < minTop{
            top = minTop
        }
        if nextTop > 0 {
            top = nextTop
        }
        
        getSizeByWidth(width, top: top, left: left, isUpdate: true)
    }
}
