//
//  SettingsLogsCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit

class SettingsLogsCell: SettingsButtonRowCell{
    override func initViews(){
        super.initViews()
        btnLabel.text = LocalizedString("lmenu_logs")
        accessoryType = .disclosureIndicator
        
        updateUI()
    }
}
