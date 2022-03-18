//
//  SettingsButtonRowCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 17.02.2022.
//

import UIKit

class SettingsButtonRowCell: UITableViewCell{
    var btnLabel: UILabel!
    
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
    
    func updateUI(){
        self.backgroundColor = UIColor.colorThemeBackground()
        
        btnLabel.textColor = .systemBlue
        btnLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
    }
    
    func initViews(){
        selectionStyle = .none
        
        btnLabel = UILabel()
        btnLabel.textAlignment = .left
        self.contentView.addSubview(btnLabel)
        
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
        
        let clearTitleLabelWidth = width - 2 * padding
        let clearTitleLabelFrame = CGRect(x: padding, y: 0, width: clearTitleLabelWidth, height: height)
        
        if isUpdate{
            btnLabel.frame = clearTitleLabelFrame
        }
        
        return CGSize(width: width, height: 0)
    }
}
