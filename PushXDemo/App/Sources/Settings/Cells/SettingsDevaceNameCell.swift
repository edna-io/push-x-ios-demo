//
//  SettingsDevaceNameCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit

class SettingsDevaceNameCell: SettingsValueRowCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    
    override func initViews(){
        super.initViews()
        keyLabel.text = LocalizedString("lmenu_device_name")
        valueLabel.text = UIDevice.current.name
    }
}
