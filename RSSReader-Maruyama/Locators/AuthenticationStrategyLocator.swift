//
//  AuthenticationStrategyLocator.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import Foundation

class AuthenticationStrategyLocator {
    private lazy var strategies: Dictionary<AuthenticationType, AuthenticationStrategy> = [:]
    
    public func add(type: AuthenticationType, strategy: AuthenticationStrategy) {
        strategies[type] = strategy
    }
    
    public func get(type: AuthenticationType) -> AuthenticationStrategy? {
        strategies[type]
    }
}
