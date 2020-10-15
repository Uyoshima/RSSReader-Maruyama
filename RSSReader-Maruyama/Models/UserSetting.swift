//
//  AppSetting.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/12.
//

import UIKit

// TODO: 文字サイズ変更機能未実装のためコメントアウト
/// 設定するTextのFontSize
//enum TextFontSize: String, Codable {
//    case small = "小"
//    case medium = "中"
//    case big = "大"
//
//    func fontSizeForTitle() -> CGFloat {
//        switch self {
//        case .small: return 14.0
//        case .medium: return 18.0
//        case .big: return 22.0
//        }
//    }
//
//    func fontSizeForDescription() -> CGFloat {
//        switch self {
//        case .small: return 8.0
//        case .medium: return 12.0
//        case .big: return 16.0
//        }
//    }
//
//    func fontSizeForPubDate() -> CGFloat {
//        switch self {
//        case .small: return 7.0
//        case .medium: return 11.0
//        case .big: return 15.0
//        }
//    }
//}

enum ItemListStyle: String, Codable {
    case table = "tableView"
    case collection = "collectionView"
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

// TODO: 文字サイズ変更機能未実装のためコメントアウト
//    private var fontSize: TextFontSize
    private var listStyle: ItemListStyle = .table
    private var rssInterval_sec: Double = 180
    
// TODO: 文字サイズ変更機能未実装のためコメントアウト
//    func getFontSize() -> TextFontSize {
//        return fontSize
//    }
    
    func getListStyle() -> ItemListStyle {
        return listStyle
    }
    
    func getRssInterval_sec() -> Double {
        return rssInterval_sec
    }
    
    func getRssInterval_min() -> Int {
        return Int(rssInterval_sec / 60)
    }

    func set(listStyle: ItemListStyle) {
        self.listStyle = listStyle
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
    
    // TODO: 文字サイズ変更機能未実装のためコメントアウト
    //    func set(fontSize: TextFontSize) {
    //        self.fontSize = fontSize
    //        save()
    //    }
    
    private func save() {
        let userDefault = UserDefaults.standard
        let data = try! JSONEncoder().encode(self)
        userDefault.set(data, forKey: UserDefaults.Keys.userSetting.rawValue)
    }
}
