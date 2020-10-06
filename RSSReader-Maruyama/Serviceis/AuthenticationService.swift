//
//  AuthenticationService.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

enum AuthenticationType: String, Codable {
    case apple
    case facebook
    case google
}

enum SocialServiceAuthError: Error {
    case unkownID
    
    var localizedDescription: String {
        switch self {
        case .unkownID: return "ユーザーIDが不明です。"
        }
    }
}

struct AuthenticationService {
    let locator: AuthenticationStrategyLocator
    
    func login(_ type: AuthenticationType) {
        locator.get(type: type)?.login()
    }
    
    func logout(_ user: User) {
        locator.get(type: user.type)?.logout(user)
    }
}

protocol AuthenticationDelegate {
    func didLogin(_ result: Result<User, Error>)
    func didLogout(_ result: Result<Void, Error>)
}
