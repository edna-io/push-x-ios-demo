//
//  AppDelegate.swift
//  PushXDemo
//
//  Created by Anton Bulankin on 25.09.2020.
//  Copyright © 2020 edna. All rights reserved.
//

import UIKit
import EDNAPushX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let appId = AppConf.appId
        
        // auto_register - Автоматически показывать диалог с разрешением на Push-уведомления.
        let pushXSettings = ["auto_register": true]
        
        EDNAPushX.setDidRegister(block: { (deviceInfo) in
            Logger.log("[APP] pushX.didRegister", params: ["deviceAddress" : deviceInfo.deviceAddress, "deviceUid": deviceInfo.deviceUid])
            ConnectData.shared.deviceAddress = deviceInfo.deviceAddress
            ConnectData.shared.deviceUid = deviceInfo.deviceUid
    
            if let userIdInfo = ConnectData.shared.userIdInfo, let type = userIdInfo.idType.toPushXUserIdType(){
                EDNAPushX.login(userIdType: type, userId: userIdInfo.id)
                Logger.log("[APP] Startup pushX.login", params: ["userId": userIdInfo.id])
            }
        })
        
        EDNAPushX.setOnPushReceived(block: { (pushData) in
            Logger.log("[APP] pushX.setOnPushReceived", params: [ "messageId" : pushData.messageId, "title": pushData.shortMessage])
            PushDataHelper.add(pushData: pushData)
        })
        
        EDNAPushX.setOnPushAction(block: { (action) in
            Logger.log("[APP] pushX.onPushAction", params: [ "messageId" : action.messageId, "type" : action.actionType.asKey(), "title": action.actionTitle, "action" : action.action])
            PushDataHelper.lastPushChangeAction(action: action)
        })
        
        EDNAPushX.initWithLaunchOptions(options: launchOptions, appId: appId, settings: pushXSettings)        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        EDNAPushX.setNotificationDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        EDNAPushX.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
    }
}

