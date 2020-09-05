//
//  LoginChecker.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
    
    private let UD_USER_DATA_KEY = "userdata"
    lazy var userDefault = UserDefaults.standard

    
    func isLoggedIn() -> Bool {
        let user = userDefault.object(forKey: UD_USER_DATA_KEY ) as? Data
        
        if user != nil {
            return true
        } else {
            return false
        }
    }
    
    func saveUserData(userData: User) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: userData, requiringSecureCoding: false)
        self.userDefault.set(data, forKey: UD_USER_DATA_KEY)
    }
    
    func removeUserData() {
        self.userDefault.removeObject(forKey: UD_USER_DATA_KEY)
    }
}
