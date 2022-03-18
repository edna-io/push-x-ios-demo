//
//  UserData.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import Foundation
import EDNAPushX

enum LoginType: CaseIterable{
    case none
    case phoneNumber
    case eMail
    case facebookId
    case telegramId
    case utm
    case cookieId
    case googleId
    case appleId
    case yandexId
    case userId
}

extension LoginType{
    func title() -> String{
        let title: String
        switch self {
        case .none:
            title = LocalizedString("login_type")
        case .phoneNumber:
            title = LocalizedString("login_type_phone")
        case .eMail:
            title = LocalizedString("login_type_email")
        case .facebookId:
            title = LocalizedString("login_type_facebook")
        case .telegramId:
            title = LocalizedString("login_type_telegram")
        case .utm:
            title = LocalizedString("login_type_utm")
        case .cookieId:
            title = LocalizedString("login_type_cookie")
        case .googleId:
            title = LocalizedString("login_type_google")
        case .appleId:
            title = LocalizedString("login_type_apple")
        case .yandexId:
            title = LocalizedString("login_type_yandex")
        case .userId:
            title = LocalizedString("login_type_userid")
        }
        return title
    }
    
    func toPushXUserIdType() -> EDNAPushXUserIdType?{
        let pushXUserIdType: EDNAPushXUserIdType?
        switch self {
        case .none:
            pushXUserIdType = nil
        case .phoneNumber:
            pushXUserIdType = .phoneNumber
        case .eMail:
            pushXUserIdType = .email
        case .facebookId:
            pushXUserIdType = .facebookId
        case .telegramId:
            pushXUserIdType = .telegramId
        case .utm:
            pushXUserIdType = .utm
        case .cookieId:
            pushXUserIdType = .cookieId
        case .googleId:
            pushXUserIdType = .googleId
        case .appleId:
            pushXUserIdType = .appleId
        case .yandexId:
            pushXUserIdType = .yandexId
        case .userId:
            pushXUserIdType = .extUserId
        }
        return pushXUserIdType
    }
}

extension LoginType{
    func toString() -> String{
        let str: String
        switch self {
        case .none:
            str = "none"
        case .phoneNumber:
            str = "phoneNumber"
        case .eMail:
            str = "eMail"
        case .facebookId:
            str = "facebookId"
        case .telegramId:
            str = "telegramId"
        case .utm:
            str = "utm"
        case .cookieId:
            str = "cookieId"
        case .googleId:
            str = "googleId"
        case .appleId:
            str = "appleId"
        case .yandexId:
            str = "yandexId"
        case .userId:
            str = "userId"
        }
        return str
    }
    
    static func fromString(_ str: String) -> LoginType?{
        let type: LoginType?
        switch str{
        case "none":
            type = LoginType.none
        case "phoneNumber":
            type = .phoneNumber
        case "eMail":
            type = .eMail
        case "facebookId":
            type = .facebookId
        case "telegramId":
            type = .telegramId
        case "utm":
            type = .utm
        case "cookieId":
            type = .cookieId
        case "googleId":
            type = .googleId
        case "appleId":
            type = .appleId
        case "yandexId":
            type = .yandexId
        case "userId":
            type = .userId
        default:
            type = nil
        }
        return type
    }
}

struct LoginIdInfo {
    // Идентификатор
    let id: String
    // Тип идентификатора
    let idType: LoginType
}

class ConnectData{
    static let shared = ConnectData()
    
    init() {
        userIdInfo = loadUserIdInfo()
    }
    
    var userIdInfo: LoginIdInfo?{
        didSet{
            saveUserIdInfo(info: userIdInfo)
        }
    }
    
    let keyId = "LoginInfo_Id"
    let keyIdType = "LoginInfo_IdType"
    private func loadUserIdInfo() -> LoginIdInfo?{
        let userDef = UserDefaults.standard
        if let id = userDef.value(forKey: keyId) as? String, let IdTypeValue = userDef.value(forKey: keyIdType) as? String, let IdType = LoginType.fromString(IdTypeValue) {
            return LoginIdInfo(id: id, idType: IdType)
        }
        return nil
    }
    
    private func saveUserIdInfo(info: LoginIdInfo?){
        let userDef = UserDefaults.standard
        if let info = info{
            userDef.set(info.id, forKey: keyId)
            userDef.set(info.idType.toString(), forKey: keyIdType)
        }else{
            userDef.removeObject(forKey: keyId)
            userDef.removeObject(forKey: keyIdType)
        }
    }
    
    // Определяется библиотекой
    var deviceAddress: String?
    
    
    // Определяется библиотекой
    var deviceUid: String?

}
