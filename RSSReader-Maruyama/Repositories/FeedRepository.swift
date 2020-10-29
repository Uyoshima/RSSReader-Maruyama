//
//  FeedRepository.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit

class FeedRepository {
    
    private let userDefaults = UserDefaults()
    private let databaseName = UserRepository().databaseName()
    
    let ALL_FEEDS: [Feed] = {
        return [.yahoo_Topic, .yahoo_Domestic, .yahoo_world, .yahoo_business]
    }()
    
    func saveSubscribe(_ feeds: [Feed]) -> Bool {
        do {
            let feedsData = try JSONEncoder().encode(feeds)
            userDefaults.set(feedsData, forKey: databaseName)
            return true
        } catch {
            return false
        }
    }

    func loadSubscribeFeed() -> [Feed] {
        guard let feeds = userDefaults.data(forKey: databaseName) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Feed].self, from: feeds)
        } catch {
            return []
        }
    }
}
