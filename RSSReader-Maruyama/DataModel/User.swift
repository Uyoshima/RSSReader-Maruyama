//
//  User.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    
    let userID: String!
    
    init(userID: String!) {
        self.userID = userID
    }
}
