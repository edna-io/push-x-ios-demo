//
//  SettingsPushXNECell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit
import EDNAPushX
import EDNAPushXNE

class SettingsPushXNECell: SettingsValueRowCell{
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
        keyLabel.text = LocalizedString("PushXNE")
        valueLabel.text = EDNAPushXNE.libVersion()
    }
}
