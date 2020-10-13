//
//  AuthenticationStrategy.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import Foundation

protocol AuthenticationStrategy {
    func login() -> UserModel
    func logout(_ user: User) -> Model
}

