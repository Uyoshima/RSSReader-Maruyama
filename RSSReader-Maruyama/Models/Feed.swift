//
//  Feed.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit
import RealmSwift

enum Feed: Int, Codable {
    case yahoo_Topic = 0
    case yahoo_Domestic = 1
    case yahoo_world = 2
    case yahoo_business = 3
    
    func url() -> String {
        switch self {
        case .yahoo_Topic:
            return "https://news.yahoo.co.jp/rss/topics/top-picks.xml"
        case .yahoo_Domestic:
            return "https://news.yahoo.co.jp/rss/topics/domestic.xml"
        case .yahoo_world:
            return "https://news.yahoo.co.jp/rss/topics/world.xml"
        case .yahoo_business:
            return "https://news.yahoo.co.jp/rss/topics/business.xml"
        }
    }
    
    func title() -> String {
        switch self {
        case .yahoo_Topic:
            return "主要"
        case .yahoo_Domestic:
            return "国内"
        case .yahoo_world:
            return "海外"
        case .yahoo_business:
            return "ビジネス"
        }
    }
    
    func icon() -> UIImage {
        switch self {
        case .yahoo_Topic,
             .yahoo_Domestic,
             .yahoo_world,
             .yahoo_business:
            return UIImage(named: "yahoo")!
        }
    }
}
