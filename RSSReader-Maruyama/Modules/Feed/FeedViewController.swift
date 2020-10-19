//
//  FeedViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/09.
//

import UIKit


class FeedViewController: UIViewController {
    private lazy var authenticationService: AuthenticationService = {
        let authenticationStrategyLocator = AuthenticationStrategyLocator()
        authenticationStrategyLocator.add(type: .apple, strategy: AppleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .google, strategy: GoogleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .facebook, strategy: FacebookAuthenticationStrategy(delegate: self, presentingViewController: self))
        
        return AuthenticationService(locator: authenticationStrategyLocator)
    }()
    
    private var itemListViewPageController: ItemListViewPageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemListViewPageController = children.first! as? ItemListViewPageController
        itemListViewPageController.delegate = self
        itemListViewPageController.scrollToPage(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loginChack() {
            showLoginView()
            return
        }
    }
    
    private func loginChack() -> Bool {
        let userRepository = UserRepository()
        return userRepository.exists()
    }
    
    private func showLoginView() {
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        loginViewController!.modalPresentationStyle = .overFullScreen
        present(loginViewController!, animated: true, completion: nil)
    }

    @IBAction func didPushLogout(_ sender: Any) {
        let userRepository = UserRepository()
        let user = userRepository.load()
        
        authenticationService.logout(user!)
    }
}

// MARK: - Extensions

extension FeedViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !finished {
            return
        }
        
        guard  let itemListViewController = pageViewController.viewControllers?.first as? ItemListViewController else {
            return
        }
        let pageIndex = itemListViewController.pageIndex
        itemListViewPageController.setCurrentPage(pageIndex!)
    }
}

// ログアウト関係
extension FeedViewController: AuthenticationDelegate {
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
