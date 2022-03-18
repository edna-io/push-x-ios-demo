//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by Anton Bulankin on 25.09.2020.
//  Copyright © 2020 edna. All rights reserved.
//

import UserNotifications
import EDNAPushXNE

class NotificationService: UNNotificationServiceExtension {
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        EDNAPushXNE.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        EDNAPushXNE.serviceExtensionTimeWillExpire()
    }
}
