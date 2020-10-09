//
//  FacebookAuthenticationStrategy.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAuthenticationStrategy: AuthenticationStrategy {
    var delegate: AuthenticationDelegate
    var presentingViewController: UIViewController
    
    init(delegate: AuthenticationDelegate, presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.delegate = delegate
    }
    
    func login() {
        let loginManager = LoginManager()
        let permission: [Permission] = [.publicProfile, .email]
        
        loginManager.logIn(permissions: permission, viewController: presentingViewController) { (result) in
            switch result {
            case .success:
                self.didsuccessLogin(AccessToken.current)
                break
                
            case .failed(let error):
                self.didFailureLogin(error)
                break
                
            case .cancelled:
                break
            }
        }
    }
    
    private func didsuccessLogin(_ accessToken: AccessToken?) {
        guard let accessToken = AccessToken.current else {
            didFailureLogin(AuthenticationServiceAuthError.unkownID)
            return
        }
        delegate.didLogin(.success(User(id: accessToken.userID, type: .facebook)))
    }
    
    private func didFailureLogin(_ error: Error) {
        Logger.debug("Facebookログイン失敗 [\(error.localizedDescription)]")
        delegate.didLogin(.failure(error))
    }
    
    func logout(_ user: User) {
        let manager = FBSDKLoginKit.LoginManager()
        manager.logOut()
        delegate.didLogout(.success(()))
    }
}
