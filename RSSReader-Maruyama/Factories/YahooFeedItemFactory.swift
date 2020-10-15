//
//  YahooTopicItemFactory.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/08.
//

import UIKit
import SwiftyXMLParser

class YahooFeedItemFactory: ItemFactoryProtocol {
    private var aCreated: (([Item])->Void)!
    
    func create(feed: Feed, created: @escaping (([Item])->Void)) {
        self.aCreated = created
        
        // 「後で読む」記事以外のitemが保存されているか確認。
        let itemRepository = ItemRepository()
        var items = itemRepository.getItemsOtherThanReadLater(feed: feed)
        
        Logger.debug("feed.title() = \(feed.title())")
        Logger.debug("「後で読む」以外のitem数 = \(items.count)")

        // 保存されていない場合、取得する。
        if items.count == 0 {
            fetchRssItems(feed: feed)
            Logger.debug("記事が無いので新しく取得")
            return
        }
    
        // RSS取得間隔を超えているか？
        let rssInterval = UserSetting.sharedObject.getRssInterval_sec()
        let isPassedInterval = hasIntervalPassed(from: (items.first?.createDate!)!, interval: rssInterval)
        
        Logger.debug("isPassedInterval = \(isPassedInterval)")
        
        if isPassedInterval {
            itemRepository.deleteOtherThanReadLater()
            fetchRssItems(feed: feed)
            Logger.debug("「後で読む」以外を削除して、新しい記事を取得")
            return
        }
        
        // 更新の必要がない場合は全ての記事を返す
        items = itemRepository.getItems(feed: feed)
        
        Logger.debug("Realmのデータをそのまま帰す")
        created(items)
    }
    
    
    
    
    private func hasIntervalPassed(from: Date, interval: TimeInterval) -> Bool {
        let currentInterval = Date().timeIntervalSince(from)
        if  currentInterval > interval {
            return true
        } else {
            return false
        }
    }
    
    private func fetchRssItems(feed: Feed) {
        let downloader = FeedItemDownloader()
        downloader.fetch(feed) { (result) in
            switch result {
            case .success(let data):
                let items = self.createItem(feed: feed, xmlData: data)
                let itemRepository = ItemRepository()
                itemRepository.save(items: items)
                self.aCreated(itemRepository.getItems(feed: feed))
                return
            case .failure(_):
                self.aCreated([])
                return
            }
        }
    }
    
    private func createItem(feed: Feed, xmlData: Data) -> [Item] {
        var items:[Item] = []
        let xml = XML.parse(xmlData)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'"
        
        for xmlItem in xml.rss.channel.item {
            var item = Item(feed: feed,
                            title: xmlItem["title"].text ?? "タイトルなし",
                            url: xmlItem["link"].text ?? "",
                            description_item: xmlItem["description"].text ?? "概要文なし",
                            pubDate: dateFormatter.date(from: xmlItem["pubDate"].text!) ?? Date(),
                            createDate: Date())
            
            let itemRepository = ItemRepository()
            item = itemRepository.getItemIfAlreadyHave(item: item)
            items.append(item)
        }
        
        return items
    }
}
