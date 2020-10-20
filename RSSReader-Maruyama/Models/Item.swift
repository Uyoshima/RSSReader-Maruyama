//
//  Item.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit
import RealmSwift


/// 記事(Item)
/// feedRawValue: 保持しているfeedで検索をかけれるように実装。
/// feed: 自信が該当するFeed
/// title: yahooRSSの<title>の要素
/// url: yahooRSSの<link>の要素
/// description_item: yahooRSSの<description>の要素。
/// pubDate: yahooRSSの<pubDate>の要素
/// isReadLater: 「後で読む」に追加されている場合はtrue
/// isAlreadyRead: 「既読」の場合はtrue
/// createDate: 生成された際のDateを保持
class Item: Object {
    
    @objc private dynamic var feedRawValue = 0
    var feed: Feed {
        get { Feed(rawValue: feedRawValue) ?? .yahoo_Topic }
        set { feedRawValue = newValue.rawValue }
    }
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var description_item: String = ""
    @objc dynamic var pubDate: Date = Date()
    @objc dynamic var isReadLater: Bool = false
    @objc dynamic var isAlreadyRead: Bool = false
    @objc dynamic var createDate: Date!
    
    convenience init(feed: Feed, title: String, url: String, description_item: String, pubDate: Date, createDate: Date) {
        self.init()
        self.feed = feed
        self.title = title
        self.url = url
        self.description_item = description_item
        self.pubDate = pubDate
        self.createDate = createDate
    }
}
