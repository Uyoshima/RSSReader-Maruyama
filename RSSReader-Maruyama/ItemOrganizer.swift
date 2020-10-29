//
//  ItemOrganizer.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/29.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import RealmSwift

class ItemOrganizer: NSObject {
    
    private let isNotReadLaterPredicate = NSPredicate(format: "isReadLater == false")

    func deleteItemIfOldItem(feed: Feed, newItems: [Item]) {
        let realm = try! Realm()
        var deleteReserveItems = realm.objects(Item.self)
            .filter("feedRawValue =\(feed.rawValue)")
            .filter(isNotReadLaterPredicate)
        
        for item in newItems {
            let predicate = NSPredicate(format: "url != %@", item.url)
            deleteReserveItems = deleteReserveItems.filter(predicate)
        }
        
        try! realm.write {
            realm.delete(deleteReserveItems)
        }
    }
    
    func extractionUnread(items: [Item], filterSetting: FilterSetting) -> [Item] {
        
        if filterSetting == .all {
            return items
        }
        
        var returnItems: [Item] = []
        for item in items {
            if !item.isAlreadyRead {
                returnItems.append(item)
            }
        }
        return returnItems
    }
}
