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
    private var complitionHandler: (([Item])->Void)!
    
    /// 引数のFeedの記事を全て取得する。
    /// - Parameter feed: 取得する記事のフィード
    /// - Returns: 引数のFeedの記事を全て返す。「後で読む」に追加されている記事は後ろに追加される。
    func getItems(feed: Feed) -> [Item] {
        let feedItems = realm.objects(Item.self).filter("feedRawValue == %@", feed.rawValue).sorted(byKeyPath: "createDate")
        let notReadLaterItems = feedItems.filter(isNotReadLaterPredicate)
        let readlaterItems = feedItems.filter(isReadLaterPredicate)
        
        var items = Array(notReadLaterItems)
        items.append(contentsOf: Array(readlaterItems))

        return Array(items)
    }
    
    /// 「後で読む」以外の記事を取得する
    /// - Parameter feed:取得する記事のフィード
    /// - Returns: 後で読む」以外の記事を返す
    func getItemsOtherThanReadLater(feed: Feed) -> [Item] {
        let allitems = realm.objects(Item.self).filter("feedRawValue == %@", feed.rawValue)
        let otherTanReadLater = allitems.filter(isNotReadLaterPredicate).sorted(byKeyPath: "createDate", ascending: false)

        return Array(otherTanReadLater)
    }
    
    /// 「後で読む」以外の記事を全て削除する
    func deleteOtherThanReadLater() {
        let deleteItems = realm.objects(Item.self).filter(isNotReadLaterPredicate)
        try! realm.write {
            realm.delete(deleteItems)
        }
    }

    /// 引数のitemが既に保存されていれば、保存されている物を返す。
    /// - Parameter item: 保存されているか確認したい記事
    /// - Returns: 保存されている場合はそのitem、ない場合は引数のitem を返す。
    func getItemIfAlreadyHave(item: Item) -> Item {
        let predicateURL = NSPredicate(format: "url == %@", item.url)

        let results = realm.objects(Item.self).filter(predicateURL)
        let results2 = results.filter("feedRawValue == %@", item.feed.rawValue)
        
        if results2.count == 0 {
            return item
        } else {
            return results.first!
        }
    }
    
    func save(items: [Item]) {
        try! realm.write {
            realm.add(items)
        }
    }
    
    func addReadLater(item: Item) {
        try! realm.write {
            item.isReadLater = true
        }
    }
    
    func removeReadLater(item: Item) {
        try! realm.write {
            item.isReadLater = false
        }
    }
    
    func setAlreadyRead(item: Item) {
        try! realm.write {
            item.isAlreadyRead = true
        }
    }
}
