//
//  GoogleAuthenticationStrategy.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleAuthenticationStrategy: NSObject, AuthenticationStrategy {
    var delegate: AuthenticationDelegate
    
    init(delegate: AuthenticationDelegate, presentingViewController: UIViewController) {
        self.delegate = delegate
        GIDSignIn.sharedInstance()?.presentingViewController = presentingViewController
    }
    
    func login() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logout(_ user: User) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signOut()
        delegate.didLogout(.success(()))
    }
}

// MARK: - Google SignIn
extension GoogleAuthenticationStrategy: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            Logger.debug("Googleログイン完了 ユーザーID [\(user.userID ?? "ユーザーID nil")]")
            delegate.didLogin(.success(User(id: user.userID, type: .google)))
        } else {
            Logger.debug("Googleログイン失敗 [\(error.localizedDescription)]")
            delegate.didLogin(.failure(error))
        }
    }
}
