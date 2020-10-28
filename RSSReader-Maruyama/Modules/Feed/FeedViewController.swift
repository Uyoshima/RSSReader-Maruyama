//
//  FeedViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/09.
//

import UIKit

class FeedViewController: UIViewController {
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
    
    @IBAction func didPushSettingListButton(_ sender: Any) {
        let settingListViewController = UIStoryboard(name: "SettingList", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(settingListViewController!, animated: true)
    }
    
    // 以下、ログイン関係
    
    private func loginChack() -> Bool {
        let userRepository = UserRepository()
        return userRepository.exists()
    }
    
    private func showLoginView() {
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        loginViewController!.modalPresentationStyle = .overFullScreen
        present(loginViewController!, animated: true, completion: nil)
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
