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
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions
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

// MARK: - Extensions
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
}

// MARK: - Extensions
// MARK: - Google SignIn

extension LoginViewController: GIDSignInDelegate {
    
    @IBAction func didPushLoginButtonGoogle() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            loginSuccessAction(userID: user.userID)
        } else {
            print("error: \(error!.localizedDescription)")
        }
    }
}
