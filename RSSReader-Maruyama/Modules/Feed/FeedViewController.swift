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
    
    @IBOutlet weak var scrollTabView: ScrollTabView!
    private var itemListViewPageController: ItemListViewPageController!
    private var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemListViewPageController = children.first! as? ItemListViewPageController
        itemListViewPageController.delegate = self
        itemListViewPageController.scrollToPage(0)
        
        // scrollTabViewの要素、選択処理をこのViewControllerで行う。
        scrollTabView.delegate = self
        scrollTabView.dataSouce = self
        
        let feedRepository = FeedRepository()
        let subscribeFeed = feedRepository.loadSubscribeFeed()
        setupViewContent(feeds: subscribeFeed)
        scrollTabView.selectCell(at: IndexPath(item: 0, section: 0))
        
        // 購読フィードに変更が合った場合、changeSubscribeFeeds(notification:)を走らせる。
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeSubscribeFeeds(notification:)),
                                               name: Notification.Name.changeSubscribeFeeds,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loginChack() {
            showLoginView()
            return
        }
    }
    
    private func setupViewContent(feeds: [Feed]) {
        setTitles(feeds: feeds)
        scrollTabView.reloadData()
        scrollTabView.selectCell(at: IndexPath(item: 0, section: 0))
        itemListViewPageController.settingViewControllers()
        itemListViewPageController.reloadInputViews()
    }
    
    private func setTitles(feeds: [Feed]) {
        titles = []
        for feed in feeds {
            titles.append(feed.title())
        }
    }
    
    /// 購読フィードが上書きされた時に呼ばれる。
    @objc func changeSubscribeFeeds(notification: Notification) {
        let feedRepository = FeedRepository()
        let subscribeFeed = feedRepository.loadSubscribeFeed()
        setupViewContent(feeds: subscribeFeed)
    }
    
    // 以下、ログアウト関係
    
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
        scrollTabView.selectCell(at: IndexPath(row: pageIndex!, section: 0))
    }
}

extension FeedViewController: ScrollTabViewDataSource {
    func scrollTabViewSetSubTitles() -> [String] {
        return titles
    }
}

extension FeedViewController: ScrollTabViewDelegate {
    func scrollTabView(_ view: ScrollTabView, didSelectIndexPath indexPath: IndexPath) {
        itemListViewPageController.scrollToPage(indexPath.row)
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

