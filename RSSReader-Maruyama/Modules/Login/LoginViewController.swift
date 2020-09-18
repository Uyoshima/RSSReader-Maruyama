//
//  LoginViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButtonStackView: UIStackView!
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.addTarget(self, action: #selector(didPushLoginButtonApple), for: .touchUpInside)
        appleLoginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return appleLoginButton
    }()
    
    private let SELECT_FEEDS_SEGUE_ID = "selectFeeds"
    
    private let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonStackView.addArrangedSubview(appleLoginButton)
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    private func didLoginSuccessAction(userID: String) {
        userRepository.save(user: User(id: userID))
        dismiss(animated: true, completion: nil)
    }
    
    private func didLoginFailed(errorMessage: String) {
        let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        self.showAlert(title: "ログインエラー", message: "error: \(errorMessage)", actions: [closeAction])
    }
    
}

// MARK: - Extensions
// MARK: - Facebook Login

extension LoginViewController {
    @IBAction func didPushLoginButtonFacebook() {
        let loginManager = LoginManager()
        let permission: [Permission] = [.publicProfile, .email]
        loginManager.logIn(permissions: permission, viewController: self) { (result) in
            switch result {
            case .success:
                self.successLoginWithFacebook()
            case .failed(let error):
                Logger.error("Facebookログイン失敗 [\(error.localizedDescription)]")
                self.didLoginFailed(errorMessage: error.localizedDescription)
            default: break
            }
        }
    }
    
    func successLoginWithFacebook() {
        if let accessToken = AccessToken.current {
            Logger.debug("Facebookログイン完了 ユーザーID [\(accessToken.userID)]")
            didLoginSuccessAction(userID: accessToken.userID)
        }
        else {
            Logger.error("Facebookログイン失敗 ユーザーID不明")
            didLoginFailed(errorMessage: "Facebookログイン失敗 ユーザーID不明")
        }
    }
}

// MARK: - Apple SignIn

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    @objc func didPushLoginButtonApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        var userID: String
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            userID = appleIDCredential.user
            
        case let passwordCredential as ASPasswordCredential:
            userID = passwordCredential.user
            
        default:
            didLoginFailed(errorMessage: "Appleログイン失敗 ユーザーID不明")
            return
        }
        Logger.debug("Appleログイン完了 ユーザーID [\(userID)]")
        didLoginSuccessAction(userID: userID)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Logger.error("Appleログイン失敗 [\(error.localizedDescription)]")
        didLoginFailed(errorMessage: error.localizedDescription)
    }
}

// MARK: - Google SignIn

extension LoginViewController: GIDSignInDelegate {
    
    @IBAction func didPushLoginButtonGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            Logger.debug("Googleログイン完了 ユーザーID [\(user.userID ?? "ユーザーID nil")]")
            didLoginSuccessAction(userID: user.userID)
        } else {
            Logger.error("Googleログイン失敗 [\(error.localizedDescription)]")
            didLoginFailed(errorMessage: error.localizedDescription)
        }
    }
}
