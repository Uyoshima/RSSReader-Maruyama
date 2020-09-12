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
    
    fileprivate let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonStackView.addArrangedSubview(appleLoginButton)
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    fileprivate func loginSuccessAction(userID: String) {
        userRepository.save(user: User(id: userID))
        // ログイン処理確認の画面遷移てテスト。実際はFeed選択画面へ
        // self.performSegue(withIdentifier: SELECT_FEEDS_SEGUE_IDENTIFIER, sender: nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Facebook Login Action

extension LoginViewController {
     @IBAction func didPushLoginButtonFacebook() {
         let loginManager = LoginManager()
         let permission: [Permission] = [.publicProfile, .email]
         loginManager.logIn(permissions: permission, viewController: self) { (result) in
             switch result {
             case .success:  self.successLoginWithFacebook()
             case .failed(_): break
             default: break
             }
         }
     }
     
    func successLoginWithFacebook() {
         if let accessToken = AccessToken.current {
             print("\(accessToken.userID)")
             loginSuccessAction(userID: accessToken.userID)
         }
     }
}

// MARK: - Delegate
// MARK: - Apple SignIn

extension LoginViewController: ASAuthorizationControllerDelegate {
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
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
}

// MARK: - Google SignIn

extension LoginViewController: GIDSignInDelegate {
    
    @IBAction func didPushLoginButtonGoogle() {
        GIDSignIn.sharedInstance()?.delegate = self
        // ログインを実行
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            // ログイン成功
            loginSuccessAction(userID: user.userID)
        } else {
            // ログイン失敗した場合
            print("error: \(error!.localizedDescription)")
        }
    }
}
