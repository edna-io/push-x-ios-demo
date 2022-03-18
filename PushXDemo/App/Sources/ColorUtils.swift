//
//  ColorUtils.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 09.02.2022.
//

import UIKit

extension UIColor{
    static func colorThemeBackground() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_background")
        }else{
            return .white
        }
    }
    
    static func colorThemeLight() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_light")
        }else{
            return .white
        }
    }
    
    static func colorThemePrimary() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_primary")
        }else{
            return .black
        }
    }
    
    static func colorThemeSecondary() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_secondary")
        }else{
            return .black
        }
    }
    
    static func colorThemeAccent() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_accent")
        }else{
            return .green
        }
    }
    
    static func colorThemeMedium() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_medium")
        }else{
            return UIColor.lightGray
        }
    }
    
    static func colorThemeSettingsTable() -> UIColor?{
        if #available(iOS 11.0, *) {
            return UIColor(named: "color_theme_settings_table")
        }else{
            return UIColor.white
        }
    }

}
