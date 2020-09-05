//
//  FeedManager.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/05.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class FeedManager: NSObject {
    
    private let UD_SUBSCRIBE_DATA_KEY: String = {
        let manager = UserDataManager()
        return manager.getUserData().userID
    }()
    
    private let feedList: [Feed] = {
        let yahoo = "yahoo"
        let pickup      = Feed(name: "トピックス", url: "https://news.yahoo.co.jp/rss/topics/top-picks.xml", logoName: yahoo)
        let domestic    = Feed(name: "国内", url: "https://news.yahoo.co.jp/rss/topics/domestic.xml", logoName: yahoo)
        let world       = Feed(name: "国際", url: "https://news.yahoo.co.jp/rss/topics/world.xml", logoName: yahoo)
        let business    = Feed(name: "ビジネス", url: "https://news.yahoo.co.jp/rss/topics/business.xml", logoName: yahoo)
        
        return [pickup, domestic, world, business]
    }()

    func feedsList() -> [Feed]
    {
       return feedList
    }
    
    
    func setSubscribeFeeds(feeds:[Feed])
    {
        let datas = feeds.map{ try! JSONEncoder().encode($0) }
        
        let userDefault = UserDefaults.standard
        userDefault.set(datas, forKey: UD_SUBSCRIBE_DATA_KEY)
    }
    
    func getSubscribeFeeds() -> [Feed]
    {
        let userDefault = UserDefaults.standard
        
        guard let datas = userDefault.array(forKey: UD_SUBSCRIBE_DATA_KEY) as? [Data] else { return [Feed]() }
        
        let feeds = datas.map{ try! JSONDecoder().decode(Feed.self, from: $0) }
                
        return feeds
    }
    
    

}
