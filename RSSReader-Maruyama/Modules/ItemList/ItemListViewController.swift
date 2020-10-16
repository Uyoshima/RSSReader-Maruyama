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
    
    private var itemListTableView: ItemListTableView!
    private var feed: Feed = .yahoo_Topic
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        addTableView()
        getItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loginChack() {
            showLoginView()
        }
    }
    
    private func createTableView() {
        itemListTableView = ItemListTableView(frame: view.frame, style: .plain)
        itemListTableView.itemListDelegate = self
        itemListTableView.itemListDataSource = self
    }
    
    private func addTableView() {
        view.addSubview(itemListTableView)
        itemListTableView.addFillConstraint(to: view)
    }
    
    private func getItem() {
        for i in 0..<10 {
            let item = Item(feed: .yahoo_Topic,
                            title: "記事のタイトル\(i)",
                            url: "",
                            description_item: "説明文が入ります。説明文が入ります。説明文が入ります。説明文が入ります。説明文が入ります。",
                            pubDate: Date(),
                            createDate: Date())
            items.append(item)
        }
        itemListTableView.reloadData()
    }
    
    // 以下、ログイン、ログアウト関係
    
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

// MARK: - Extension

extension ItemListViewController: ItemListDataSource {
    func numberOfItemInsection(section: Int) -> Int {
        return items.count
    }
    
    func itemList(itemForRowAt indexPath: IndexPath) -> Item {
        return items[indexPath.row]
    }
}

extension ItemListViewController: ItemListDelegate {
    func itemList(didSelectedRowAt indexPath: IndexPath) {
        // TODO: 選択された記事のWebページを表示する。
    }
    
    func addReadLaterAt(indexPath: IndexPath) {
        // TODO: indexPathの記事を「後で読む」にする。
    }
    
    func removeReadLaterAt(indexPath: IndexPath) {
        // TODO: 選択された記事に「後で読む」を解除する。

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
