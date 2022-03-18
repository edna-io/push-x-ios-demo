//
//  SettingsCopyInfoCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 17.02.2022.
//

import UIKit

class SettingsCopyInfoCell: SettingsButtonRowCell{
    override func initViews(){
        super.initViews()
        btnLabel.text = LocalizedString("copy_device_info_btn")
        
        updateUI()
    }
}
