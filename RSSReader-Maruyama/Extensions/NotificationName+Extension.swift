//
//  NotificationName+Extension.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

extension Notification.Name {
    static let changeSubscribeFeeds   = Notification.Name("changeSubscribeFeeds")
    static let changeListStyle        = Notification.Name("changeListStyle")
    static let changeReadLaterValue   = Notification.Name("changeReadLaterValue")
    static let changeAlreadyReadValue = Notification.Name("changeAlreadyReadValue")
    static let changeFontSize         = Notification.Name("changeFontSize")
    static let changeFilterSetting    = Notification.Name("changeFilterSetting")
}
