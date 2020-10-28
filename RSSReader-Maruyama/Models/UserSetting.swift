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

    private var listStyle: ItemListStyle
    private var fontSize: FontSize
    
    init() {
        listStyle = .table
        fontSize = .midum
    }
    
    func getListStyle() -> ItemListStyle {
        return listStyle
    }
    
    func getFontSize() -> FontSize {
        return fontSize
    }
    
    func set(listStyle: ItemListStyle) {
        self.listStyle = listStyle
        save()
    }
    
    func set(fontSize: FontSize) {
        self.fontSize = fontSize
        save()
    }
    
    private func save() {
        let userDefault = UserDefaults.standard
        let data = try! JSONEncoder().encode(self)
        userDefault.set(data, forKey: UserDefaults.Keys.userSetting.rawValue)
    }
}
