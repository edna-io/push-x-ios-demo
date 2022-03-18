//
//  LocalizableUtils.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 16.02.2022.
//

import Foundation

class LocalizableUtils{
    static func currentLanguageCode() -> String{
        let supportedLanguageCodes = ["en", "ru"]
        let languageCode = Locale.current.languageCode ?? "en"

        return supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
    }
}
