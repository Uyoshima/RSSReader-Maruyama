//
//  LoginChecker.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class UserDataManager {
    
    private let USER_DATA_KEY = "userData"
    lazy var userDefaults = UserDefaults.standard

    func exists() -> Bool {
        let user = userDefaults.data(forKey: USER_DATA_KEY)
        
        return user != nil
    }
    
    func load() -> User? {
        guard let userData = userDefaults.data(forKey: USER_DATA_KEY) else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: userData)
    }
    
    func save(user: User) {
        let userData = try? JSONEncoder().encode(user)
        userDefaults.set(userData, forKey: USER_DATA_KEY)
    }
    
    func delete() {
        userDefaults.removeObject(forKey: USER_DATA_KEY)
    }
    
}
