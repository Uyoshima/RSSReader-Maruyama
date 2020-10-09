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
        KeychainItem.deleteUserIdentifierFromKeychain()
        delegate.didLogout(.success(()))
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.maruyama.RSSReader-Maruyama", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}

extension AppleAuthenticationStrategy: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentingViewController.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        var userID: String
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            userID = userIdentifier
            saveUserInKeychain(userIdentifier)
            
        case let passwordCredential as ASPasswordCredential:
            userID = passwordCredential.user
            
        default:
            delegate.didLogin(.failure(AuthenticationServiceAuthError.unkownID))
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
