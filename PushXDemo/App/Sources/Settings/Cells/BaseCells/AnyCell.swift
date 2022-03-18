//
//  AnyCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit

class AnyCell: UITableViewCell{
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
    }
    
    private func initViews(){
        selectionStyle = .none
        
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfSize = self.contentView.frame.size
        let _ = getSizeByWidth(selfSize.width, isUpdate: true)
    }
    
    func getSizeByWidth(_ width: CGFloat, isUpdate: Bool) -> CGSize{
        return CGSize(width: width, height: 0)
    }
}
