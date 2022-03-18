//
//  SettingsClientInfoCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit

class SettingsClientInfoCell: UITableViewCell, CellSizeProtocol{
    var userImageView: UIImageView!
    var userTitleLabel: UILabel!
    
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
        self.backgroundColor = UIColor.colorThemeBackground()
        
        userTitleLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        
        userTitleLabel.textColor = UIColor.colorThemePrimary()
        
        updateData()
    }
    
    override func prepareForReuse(){
        updateData()
    }
    
    func updateData(){
        let userImage: UIImage?
        let userTitle: String?
        if let userIdInfo = ConnectData.shared.userIdInfo{
            userTitle = userIdInfo.id
            userImage = UIImage(named: "ico_login")?.withRenderingMode(.alwaysOriginal)
        }else{
            userImage = UIImage(named: "ico_anonimus")?.withRenderingMode(.alwaysOriginal)
            userTitle = LocalizedString("anonymous_header")
        }
        userImageView.image = userImage
        userTitleLabel.text = userTitle
    }
    
    private func initViews(){
        selectionStyle = .none
        
        userImageView = UIImageView()
        self.contentView.addSubview(userImageView)
        
        userTitleLabel = UILabel()
        userTitleLabel.textAlignment = .center
        self.contentView.addSubview(userTitleLabel)
        
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.contentView.frame.size
        let _ = getSizeByWidth(selfSize.width, isUpdate: true)
    }
    
    func getSizeByWidth(_ width: CGFloat, isUpdate: Bool) -> CGSize{
        let padding: CGFloat = 10
        let height = self.contentView.frame.height
        
        let userImageViewSize = CGSize(width: 36, height: 36)
        let userImageViewTop = 0.5 * (height - userImageViewSize.height)
        let userImageViewFrame = CGRect(x: 28, y: userImageViewTop, width: userImageViewSize.width, height: userImageViewSize.height)
        
        let userTitleLabelLeft = userImageViewFrame.maxX + padding
        let userTitleLabelWidth = width - 2 * userTitleLabelLeft
        let userTitleLabelFrame = CGRect(x: userTitleLabelLeft, y: 0, width: userTitleLabelWidth, height: height)
        
        if isUpdate{
            userImageView.frame = userImageViewFrame
            userTitleLabel.frame = userTitleLabelFrame
        }
        
        return CGSize(width: width, height: height)
    }
}
