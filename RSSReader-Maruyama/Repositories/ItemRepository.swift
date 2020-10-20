//
//  ItemRepository.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/12.
//

import UIKit
import RealmSwift

class ItemRepository {
    
    private let realm = try! Realm()
    
    private let isReadLaterPredicate = NSPredicate(format: "isReadLater == true")
    private let isNotReadLaterPredicate = NSPredicate(format: "isReadLater == false")
    
    func get(feed: Feed) -> [Item] {
        let items = realm.objects(Item.self).filter("feedRawValue =\(feed.rawValue)")
        var tmp: [Item] = []
        for item in items {
            tmp.append(item)
        }
        return tmp
    }
    
    func save(items: [Item]) {
        try! realm.write {
            realm.add(items)
        }
    }
    
    func addReadLater(item: Item) {
        try! realm.write {
            item.isReadLater = true
            realm.add(item)
        }
    }
    
    func removeReadLater(item: Item) {
        try! realm.write {
            item.isReadLater = false
        }
    }
    
    func deleteOtherThanReadLater() {
        let deleteItems = realm.objects(Item.self).filter(isNotReadLaterPredicate)
        try! realm.write {
            realm.delete(deleteItems)
        }
    }
    
    func hasItem(_ item: Item) -> Bool {
        let predicate = NSPredicate(format: "url == %@", item.url)
        let results = realm.objects(Item.self).filter(predicate)
        
        if results.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    /// 既に保存されている記事かを確認する。
    /// - Parameter item: 確認したいItem
    /// - Returns: 持っている→DBのオブジェクト、持っていない→引数のItem
    func replaceItemIfAlreadyHave(item: Item) -> Item {
        let predicate = NSPredicate(format: "url == %@", item.url)
        let results = realm.objects(Item.self).filter(predicate)
        
        if results.count == 0 {
            return item
        } else {
            return results.first!
        }
    }
    
    func getAllReadLaterItems() -> [Item] {
        let results = realm.objects(Item.self).filter(isReadLaterPredicate)
        
        var items: [Item] = []
        for item in results {
            items.append(item)
        }
        
        return items
    }
}
