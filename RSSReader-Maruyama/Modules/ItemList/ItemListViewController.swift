//
//  ItemListViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    private lazy var authenticationService: AuthenticationService = {
        let authenticationStrategyLocator = AuthenticationStrategyLocator()
        authenticationStrategyLocator.add(type: .apple, strategy: AppleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .google, strategy: GoogleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .facebook, strategy: FacebookAuthenticationStrategy(delegate: self, presentingViewController: self))
        
        return AuthenticationService(locator: authenticationStrategyLocator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loginChack() {
            showLoginView()
        }
    }
    
    private func loginChack() -> Bool {
        let userRepository = UserRepository()
        return userRepository.exists()
    }
    
    @IBAction func didPushLogout(_ sender: Any) {
        let userRepository = UserRepository()
        let user = userRepository.load()
        
        authenticationService.logout(user!)
    }
    
    private func showLoginView() {
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        loginViewController!.modalPresentationStyle = .overFullScreen
        present(loginViewController!, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ItemListViewController: AuthenticationDelegate {
    func didLogin(_ result: Result<User, Error>) {
    }
    
    func didLogout(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            let userRepository = UserRepository()
            userRepository.delete()
            showLoginView()
            break
        case .failure(let error):
            Logger.debug("ログアウトエラー： \(error.localizedDescription)")
            break
        }
    }
}
