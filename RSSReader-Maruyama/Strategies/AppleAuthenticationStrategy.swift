//
//  AppleAuthenticationStrategy.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/02.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import AuthenticationServices

class AppleAuthenticationStrategy: NSObject, AuthenticationStrategy {
    var delegate: AuthenticationDelegate
    var presentingViewController: UIViewController
    var handler: ((Result<User, Error>) -> Void)?
    
    init(delegate: AuthenticationDelegate, presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.delegate = delegate
    }
    
    func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func logout(_ user: User) {
    }
}

extension AppleAuthenticationStrategy: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.presentingViewController.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        var userID: String
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            userID = appleIDCredential.user
            
        case let passwordCredential as ASPasswordCredential:
            userID = passwordCredential.user
            
        default:
            delegate.didLogin(.failure(SocialServiceAuthError.unkownID))
            return
        }
        Logger.debug("Appleログイン完了 ユーザーID [\(userID)]")
        delegate.didLogin(.success(User(id: userID, type: .apple)))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Logger.error("Appleログイン失敗 [\(error.localizedDescription)]")
        delegate.didLogout(.failure(error))
    }
}
