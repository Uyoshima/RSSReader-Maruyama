//
//  LoginViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/03.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButtonStackView: UIStackView!
    private lazy var authenticationService: AuthenticationService = {
        let authenticationStrategyLocator = AuthenticationStrategyLocator()
        authenticationStrategyLocator.add(type: .apple, strategy: AppleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .google, strategy: GoogleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .facebook, strategy: FacebookAuthenticationStrategy(delegate: self, presentingViewController: self))
        
        return AuthenticationService(locator: authenticationStrategyLocator)
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.addTarget(self, action: #selector(didPushLoginButtonApple), for: .touchUpInside)
        appleLoginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return appleLoginButton
    }()
    
    private let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonStackView.addArrangedSubview(appleLoginButton)
    }
    
    private func didLoginSuccess(user: User) {
        userRepository.save(user: user)
        dismiss(animated: true, completion: nil)
    }
    
    private func didLoginFailed(errorMessage: String) {
        let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        showAlert(title: "ログインエラー", message: "error: \(errorMessage)", actions: [closeAction])
    }
    
    // MARK : - Button Action
    
    @objc func didPushLoginButtonApple() {
        authenticationService.login(.apple)
    }
    
    @IBAction func didPushLoginButtonGoogle() {
        authenticationService.login(.google)
    }
    
    @IBAction func didPushLoginButtonFacebook() {
        authenticationService.login(.facebook)
    }
    
}

// MARK: - Extensions

extension LoginViewController: AuthenticationDelegate {
    func didLogin(_ result: Result<User, Error>) {
        switch result {
        case .success(let user):
            self.didLoginSuccess(user: user)
        case .failure(let error):
            self.didLoginFailed(errorMessage: error.localizedDescription)
        }
    }
    
    func didLogout(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            let userRepository = UserRepository()
            userRepository.delete()
            break
        case .failure(_):
            break
        }
    }
}
