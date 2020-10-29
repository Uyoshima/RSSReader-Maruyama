//
//  LoginChecker.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class UserRepository {
    lazy var userDefaults = UserDefaults.standard
    
    func exists() -> Bool {
        let user = userDefaults.data(forKey: UserDefaults.Keys.userData.rawValue)
        
        return user != nil
    }
    
    func load() -> User? {
        guard let userData = userDefaults.data(forKey: UserDefaults.Keys.userData.rawValue) else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: userData)
    }
    
    func databaseName() -> String {
        let user = UserRepository().load()!
        return "\(user.type.rawValue)_\(user.id)"
    }
    
    func save(user: User) {
        let userData = try? JSONEncoder().encode(user)
        userDefaults.set(userData, forKey: UserDefaults.Keys.userData.rawValue)
    }
    
    func delete() {
        userDefaults.removeObject(forKey: UserDefaults.Keys.userData.rawValue)
    }
}
