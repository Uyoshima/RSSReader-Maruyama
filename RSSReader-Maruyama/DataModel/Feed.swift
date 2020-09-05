//
//  Feed.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/05.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class Feed: NSObject, Codable {

    var name: String!
    var url: String!
    var logoName: String!
    
    init(name: String!, url: String!, logoName: String) {
        self.name = name
        self.url = url
        self.logoName = logoName
    }

}
