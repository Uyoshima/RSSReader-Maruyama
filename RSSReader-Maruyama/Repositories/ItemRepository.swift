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
    
    func setAlreadyRead(item: Item) {
        try! realm.write {
            item.isAlreadyRead = true
        }
    }
    
    func removeReadLater(item: Item) {
        try! realm.write {
            item.isReadLater = false
        }
    }
    
    /// 既に保存されている記事かを確認する。
    /// - Parameter item: 確認したいItem
    /// - Returns: 持っている→DBのオブジェクト、持っていない→引数のItem
    func replaceItemIfAlreadyHave(item: Item) -> Item {
        let predicate = NSPredicate(format: "url == %@", item.url)
        let results = realm.objects(Item.self)
            .filter(predicate)
            .filter("feedRawValue =\(item.feed.rawValue)")
        
        if results.count == 0 {
            return item
        } else {
            return results.first!
        }
    }
    
    func getReadLaterItems() -> [Item] {
        let results = realm.objects(Item.self).filter(isReadLaterPredicate)
        
        var items: [Item] = []
        for item in results {
            items.append(item)
        }
        
        return items
    }
    
    func deleteItemIfDontNeed(feed: Feed, newItems: [Item]) {
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
    
    func newestItem(feed: Feed) -> Item? {
        let items = realm.objects(Item.self).filter("feedRawValue =\(feed.rawValue)").sorted(byKeyPath: "createDate", ascending: false)
        return items.first
    }
}
