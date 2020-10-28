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
    
    init() {
        listStyle = .table
    }
    
    func getListStyle() -> ItemListStyle {
        return listStyle
    }
    
    func set(listStyle: ItemListStyle) {
        self.listStyle = listStyle
        save()
    }
    
    private func save() {
        let userDefault = UserDefaults.standard
        let data = try! JSONEncoder().encode(self)
        userDefault.set(data, forKey: UserDefaults.Keys.userSetting.rawValue)
    }
}
