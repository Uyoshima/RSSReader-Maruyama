//
//  User.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    let userID: String!
    
    func encode(with coder: NSCoder) {
        coder.encode(userID, forKey: "userID")
    }
    
    required init?(coder: NSCoder) {
        userID = coder.decodeObject(forKey: "userID") as! String
    }
    

    
    init(userID: String!) {
        self.userID = userID
    }
}
