//
//  SettingsValueRowCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit

class SettingsValueRowCell: UITableViewCell{
    var keyLabel: UILabel!
    var valueLabel: UILabel!
    
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
        
        keyLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        keyLabel.textColor = UIColor.colorThemePrimary()
        
        valueLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        valueLabel.textColor = UIColor.colorThemeSecondary()
    }
    
    func initViews(){
        selectionStyle = .none
        
        keyLabel = UILabel()
        keyLabel.textAlignment = .left
        self.contentView.addSubview(keyLabel)
        
        valueLabel = UILabel()
        valueLabel.textAlignment = .right
        valueLabel.adjustsFontSizeToFitWidth = false
        valueLabel.lineBreakMode = .byTruncatingMiddle
        self.contentView.addSubview(valueLabel)
        
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
        
        let valueLabelSize = valueLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        var valueLabelWidth = valueLabelSize.width
        if valueLabelSize.width > width * 0.7 {
            valueLabelWidth = width * 0.7
        }
        
        let valueLabelLeft = width - padding - valueLabelWidth
        let valueLabelFrame = CGRect(x: valueLabelLeft, y: 0, width: valueLabelWidth, height: height)
        
        let keyLabelWidth = valueLabelFrame.maxX - 2 * padding
        let keyLabelFrame = CGRect(x: padding, y: 0, width: keyLabelWidth, height: height)
        
        if isUpdate{
            valueLabel.frame = valueLabelFrame
            keyLabel.frame = keyLabelFrame
        }
        
        return CGSize(width: width, height: 0)
    }
}

