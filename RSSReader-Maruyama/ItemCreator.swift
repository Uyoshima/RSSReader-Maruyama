//
//  ItemCreator.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/16.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class ItemCreator: NSObject {
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'"
        return dateFormatter
    }()
    
    func createItems(feed: Feed, xmlData: Data) -> [Item] {
        var items:[Item] = []
        let xml = XML.parse(xmlData)
        
        for xmlItem in xml.rss.channel.item {
            let item = createItem(feed: feed, xmlItem: xmlItem)
            items.append(item)
        }
        
        let itemRepository = ItemRepository()
        itemRepository.deleteItemIfDontNeed(feed: feed, newItems: items)
        itemRepository.save(items: items)
        
        return itemRepository.get(feed: feed)
    }
    
    private func createItem(feed: Feed, xmlItem: XML.Accessor) -> Item {
        var item = Item(feed: feed,
                        title: xmlItem["title"].text ?? "タイトルなし",
                        url: xmlItem["link"].text ?? "",
                        description_item: xmlItem["description"].text ?? "概要文なし",
                        pubDate: dateFormatter.date(from: xmlItem["pubDate"].text!) ?? Date(),
                        createDate: Date())
        
        let itemRepository = ItemRepository()
        item = itemRepository.replaceItemIfAlreadyHave(item: item)
        return item
    }
}
