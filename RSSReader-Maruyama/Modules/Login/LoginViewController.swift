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

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var loginButtonStackView: UIStackView!
    private let SELECT_FEEDS_SEGUE_ID = "selectFeeds"
    
    fileprivate let userDataManager = UserDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButtons()
    }
    
    
//MARK:- Setup SignIn Button
    private func setupLoginButtons() {
                
        // Facebook
        let button_fb = LoginButton()
        button_fb.custom(text: "Facebookアカウントでログイン", icon: "fb")
        button_fb.addTarget(self, action: #selector(didPushLoginButtonFacebook), for: .touchUpInside)
        
        // Google
        let button_google = LoginButton()
        button_google.custom(text: "Googleアカウントでログイン", icon: "google")
        button_google.addTarget(self, action: #selector(didPushLoginButtonGoogle), for: .touchUpInside)
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Apple
        let button_apple = ASAuthorizationAppleIDButton()
        button_apple.addTarget(self, action: #selector(didPushLoginButtonApple), for: .touchUpInside)
        button_apple.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        loginButtonStackView.addArrangedSubview(button_fb)
        loginButtonStackView.addArrangedSubview(button_google)
        loginButtonStackView.addArrangedSubview(button_apple)
        
    }
    
    
//    MARK: Facebook SignIn Action
    @objc func didPushLoginButtonFacebook() {
        
        let loginManager = LoginManager()
        let permission: [Permission] = [ .publicProfile, .email ]
        loginManager.logIn(permissions: permission, viewController: self) { (result) in
            switch result {
            case .success:  self.successLoginWithFacebook()
            case .failed(_): break
            default: break
            }
        }
        
    }
    
    
    fileprivate func successLoginWithFacebook() {
        
        if let accessToken = AccessToken.current {
            print("\(accessToken.userID)")
            loginSuccessAction(userID: accessToken.userID)
        }
        
    }
    
    
    
//    MARK: Apple ID SignIn Action
    @objc func didPushLoginButtonGoogle() {
        
        GIDSignIn.sharedInstance()?.delegate = self
        // ログインを実行
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    
    
//    MARK: Apple ID SignIn Action
    @objc func didPushLoginButtonApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    
    fileprivate func loginSuccessAction(userID: String) {
        userDataManager.save(user: User(id: userID))
        // ログイン処理確認の画面遷移てテスト。実際はFeed選択画面へ
        // self.performSegue(withIdentifier: SELECT_FEEDS_SEGUE_IDENTIFIER, sender: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK:- Delegate
//MARK: Apple SignIn
extension LoginViewController: ASAuthorizationControllerDelegate
{
    
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding
{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}

//MARK: Google SignIn
extension LoginViewController: GIDSignInDelegate
{
    
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
