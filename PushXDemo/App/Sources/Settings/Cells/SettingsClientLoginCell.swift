//
//  SettingsClientLoginCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit

class SettingsClientLoginCell: UITableViewCell{
    var connectTitleLabel: UILabel!
    
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
        connectTitleLabel.textColor = .systemBlue
    }
    
    func updateData(){
        let type: UITableViewCell.AccessoryType
        let text: String?
        if let _ = ConnectData.shared.userIdInfo{
            text = LocalizedString("logout_btn")
            type = .none
        }else{
            text = LocalizedString("login_btn")
            type = .disclosureIndicator
        }
        accessoryType = type
        connectTitleLabel.text = text
    }
    
    override func prepareForReuse(){
        updateData()
    }
    
    private func initViews(){
        selectionStyle = .none
        
        connectTitleLabel = UILabel()
        connectTitleLabel.textAlignment = .left
        self.contentView.addSubview(connectTitleLabel)
        
        updateData()
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.contentView.frame.size
        let _ = getSizeByWidth(selfSize.width, isUpdate: true)
    }
    
    func getSizeByWidth(_ width: CGFloat, isUpdate: Bool) -> CGSize{
        let padding: CGFloat = 16
        let height = self.contentView.frame.height
        
        let connectTitleLabelWidth = width - 2 * padding
        let connectTitleLabelFrame = CGRect(x: padding, y: 0, width: connectTitleLabelWidth, height: height)
        
        if isUpdate{
            connectTitleLabel.frame = connectTitleLabelFrame
        }
        
        return CGSize(width: width, height: 0)
    }
}
