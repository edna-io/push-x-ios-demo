//
//  SettingsClearHistoryCell.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit

class SettingsClearHistoryCell: SettingsButtonRowCell{
    override func initViews(){
        super.initViews()
        btnLabel.text = LocalizedString("lmenu_clear_history_btn")
        
        updateUI()
    }
}
