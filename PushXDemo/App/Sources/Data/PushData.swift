//
//  PushData.swift
//  PushXCEDemoA
//
//  Created by Алексей Химунин on 15.02.2022.
//

import CoreData
import EDNAPushX

@objc(PushData)
public class PushData: NSManagedObject {

}

extension PushData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PushData> {
        return NSFetchRequest<PushData>(entityName: "Push")
    }
    
    @NSManaged public var action: String?
    @NSManaged public var actionTitle: String?
    @NSManaged public var actionType: String?
    @NSManaged public var userInfo: Data?
    @NSManaged public var shortMessage: String?
    @NSManaged public var messageId: String?
    @NSManaged public var hasFullContent: Bool
    @NSManaged public var complexMessageId: String?
    @NSManaged public var chlSentAt: Date?
}

extension PushData : Identifiable {

}

extension PushData {
    static func getPushData(context: NSManagedObjectContext, messageId: String) -> PushData?{
        let fetchRequest: NSFetchRequest<PushData>
        fetchRequest = PushData.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "messageId = %@", messageId
        )
        
        var result = [PushData]()
        do {
            result = try context.fetch(fetchRequest)
        }catch{
            
        }
        if result.count > 0 {
            return result.first
        }
        return nil
    }
    
    static func insertOrUpdatePushData(context: NSManagedObjectContext, messageId: String) -> PushData{
        if let pushData = getPushData(context: context, messageId: messageId){
            return pushData
        }else{
            return PushData(context: context)
        }
    }
    
    static func isExist(context: NSManagedObjectContext, pushData: EDNAPushData) -> Bool{
        let pushData = getPushData(context: context, messageId: pushData.messageId)

        return pushData != nil
    }
    
    @discardableResult static func insert(context: NSManagedObjectContext, pushData: EDNAPushData) -> PushData{
        let newItem = PushData.insertOrUpdatePushData(context: context, messageId: pushData.messageId)
        newItem.messageId = pushData.messageId
        newItem.chlSentAt = pushData.chlSentAt
        newItem.complexMessageId = pushData.complexMessageId
        newItem.hasFullContent = pushData.hasFullContent
        newItem.shortMessage = pushData.shortMessage
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: pushData.userInfo, options: .prettyPrinted)
            newItem.userInfo = jsonData
        } catch {
            
        }
        return newItem
    }
    
    static func allRows(context: NSManagedObjectContext) -> [PushData] {
        let request = self.fetchRequest()
        var results : [PushData]

         do {
             results = try context.fetch(request)
         } catch {
             results = [PushData]()
         }

        return results
    }
    
    static func clearAll(context: NSManagedObjectContext) {
        let request = self.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
        } catch _ {
            
        }
    }
}

extension PushData {
    private func dictanaryFromData(data: Data?) -> [String: Any]?{
        if let data = data{
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dict
            } catch {
            }
        }
        return nil
    }
    
    private func actionFromData(actionStr: String?) -> [Any]?{
        if let actionStr = actionStr, let actionsData = actionStr.data(using: .utf8){
            do {
                let dict = try JSONSerialization.jsonObject(with: actionsData, options: []) as? [Any]
                return dict
            } catch {
            }
        }
        return nil
    }
    
    func asPushViewData() -> PushViewData{
        let messageId = self.messageId ?? "-"
        let date = self.chlSentAt ?? Date()
        
        let title: String?
        let body: String?
        let logoURL: String?
        let content: PushViewContentData?
        let action: PushViewActionType?
        var actionItems = [PushViewActionItemData]()
        var jsonStr: String? = nil
        if let userInfo = dictanaryFromData(data: self.userInfo){
            if let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? [String: String]{
                title = alert["title"]
                body = alert["body"]
            }else{
                title = nil
                body = nil
            }
            logoURL = userInfo["logoURL"] as? String
            let contentTitle = userInfo["bigContentTitle"] as? String
            let contentText = userInfo["bigContentText"] as? String
            let contentUrl = userInfo["bigContentLogoURL"] as? String
            content = PushViewContentData(title: contentTitle, text: contentText, url: contentUrl)
            
            let actions = actionFromData(actionStr: userInfo["actions"] as? String)
            if let actions = actions{
                for item in actions{
                    if let item = item as? [String: String]{
                        if let key = item["action"], let title = item["title"]{
                            actionItems.append(PushViewActionItemData(title: title, action: key))
                        }
                    }
                }
            }
            
            if let actionType = self.actionType{
                switch actionType{
                case "deeplink":
                    action = .deeplink(action: self.action)
                case "button":
                    action = .button(action: self.action, name: self.actionTitle)
                default:
                    action = nil
                }
            }else{
                action = nil
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
                jsonStr = String(decoding: jsonData, as: UTF8.self)
            } catch {
                print(error.localizedDescription)
            }
            
        }else{
            title = nil
            body = nil
            logoURL = nil
            content = nil
            action = nil
        }
        
        return PushViewData(messageId: messageId, date: date, title: title, body: body, logoURL: logoURL, content: content, action: action, actions: actionItems, jsonStr: jsonStr)
    }
}

extension Array where Element == PushData {
    func asPushViewDatas() -> [PushViewData] {
        var items = [PushViewData]()
        for item in self{
            items.append(item.asPushViewData())
        }
        return items
    }
}

class PushDataHelper{
    static func add(pushData: EDNAPushData){
        let context = PushXContainer.shared.container.viewContext
        PushData.insert(context: context, pushData: pushData)
        PushXContainer.shared.save()
    }
    
    static func lastPushChangeAction(action: EDNAPushXAction){
        let context = PushXContainer.shared.container.viewContext
        let pushData = PushData.insertOrUpdatePushData(context: context, messageId: action.messageId)
        pushData.messageId = action.messageId
        pushData.action = action.action
        pushData.actionTitle = action.actionTitle
        pushData.actionType = action.actionType.asKey()
        PushXContainer.shared.save()
    }
}

extension EDNAPushXActionType{
    func asKey() -> String{
        switch self {
        case .deeplink:
            return "deeplink"
        case .button:
            return "button"
        }
    }
}
