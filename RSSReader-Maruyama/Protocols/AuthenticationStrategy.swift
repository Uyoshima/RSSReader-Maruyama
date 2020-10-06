//
//  AuthenticationStrategy.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

protocol AuthenticationStrategy {
    var delegate: AuthenticationDelegate { get }
    func login()
    func logout(_ user: User)
}
