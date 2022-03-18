//
//  PushViewData.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 15.02.2022.
//

import Foundation

struct PushViewActionItemData{
    let title: String
    let action: String
}

enum PushViewActionType{
    case deeplink(action: String?)
    case button(action: String?, name: String?)
}

struct PushViewContentData{
    let title: String?
    let text: String?
    let url: String?
}

struct PushViewData{
    let messageId: String
    let date: Date
    let title: String?
    let body: String?
    let logoURL: String?
    let content: PushViewContentData?
    let action: PushViewActionType?
    let actions: [PushViewActionItemData]
    let jsonStr: String?
}

extension PushViewData{
    var dateAsListStr: String?{
        let dateFormatter = DateFormatter()
        if DateUtils.stripTime(from: date) == DateUtils.stripTime(from: Date()) {
            dateFormatter.dateFormat = "HH:mm"
        }else{
            dateFormatter.dateFormat = "yyyy.MM.dd"
        }
        return dateFormatter.string(from: date)
    }
}

class DateUtils{
    static func stripTime(from originalDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: originalDate)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
