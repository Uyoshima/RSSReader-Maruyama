//
//  AppSetting.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/12.
//

import UIKit

enum ItemListStyle: String, Codable {
    case table = "tableView"
    case collection = "collectionView"
}

enum FontSize: Int, Codable {
    case small = 0
    case midum = 1
    case big   = 2
    
    func titleSize() -> CGFloat {
        switch self {
        case .small: return 14.0
        case .midum: return 18.0
        case .big  : return 22.0
        }
    }
    
    func textSize() -> CGFloat {
        switch self {
        case .small: return 8.0
        case .midum: return 12.0
        case .big  : return 16.0
        }
    }
    
    func pubTextSize() -> CGFloat {
        switch self {
        case .small: return 7.0
        case .midum: return 11.0
        case .big  : return 15.0
        }
    }
}

class UserSetting: Codable {
    
    static let sharedObject: UserSetting = {
        let userDefaults = UserDefaults.standard
        
        guard let userSettingData = UserDefaults.standard.data(forKey: UserDefaults.Keys.userSetting.rawValue) else {
            let userSetting = UserSetting()
            let settingData = try! JSONEncoder().encode(UserSetting())
            userDefaults.set(settingData, forKey: UserDefaults.Keys.userSetting.rawValue)
            return userSetting
        }
        do {
            return try JSONDecoder().decode(UserSetting.self, from: userSettingData)
        } catch {
            let userSetting = UserSetting()
            let settingData = try! JSONEncoder().encode(UserSetting())
            userDefaults.set(settingData, forKey: UserDefaults.Keys.userSetting.rawValue)
            return userSetting

        }
    }()

    private var listStyle: ItemListStyle = .table
    private var fontSize: FontSize = .midum
    private var rssInterval_sec: Double = 180
    
    
    func hasIntervalPassed(from: Date, interval: TimeInterval) -> Bool {
        let currentInterval = Date().timeIntervalSince(from)
        if  currentInterval > interval {
            return true
        } else {
            return false
        }
    }
    
    // MARK : - getter
    
    func getListStyle() -> ItemListStyle {
        return listStyle
    }
    
    func getFontSize() -> FontSize {
        return fontSize
    }
    
    func getRssInterval_sec() -> Double {
        return rssInterval_sec
    }
    
    func getRssInterval_min() -> Int {
        return Int(rssInterval_sec / 60)
    }
    
    // MARK : - setter
    
    func set(listStyle: ItemListStyle) {
        self.listStyle = listStyle
        save()
    }
    
    func set(fontSize: FontSize) {
        self.fontSize = fontSize
        save()
    }
    
    func set(rssInterval_sec: Double) {
        self.rssInterval_sec = rssInterval_sec
        save()
    }
    
    func set(rssInterval_min: Double) {
        self.rssInterval_sec = Double(rssInterval_min * 60)
        save()
    }
    
    private func save() {
        let userDefault = UserDefaults.standard
        let data = try! JSONEncoder().encode(self)
        userDefault.set(data, forKey: UserDefaults.Keys.userSetting.rawValue)
    }
}
