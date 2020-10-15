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
        scrollTabView.delegate = self
        scrollTabView.dataSouce = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSubscribeFeeds(notification:)), name: Notification.Name.changeSubscribeFeeds, object: nil)
        
        let feedRepository = FeedRepository()
        let subscribeFeed = feedRepository.loadSubscribeFeed()
        setScrollTabView(feeds: subscribeFeed)
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
    
    private func setItemListViewPage(feeds: [Feed]) {
        itemListViewPageController.initPageViewController()
        itemListViewPageController.reloadInputViews()
    }
    
    private func setScrollTabView(feeds: [Feed]) {
        setTitles(feeds: feeds)
        scrollTabView.reloadData()
        scrollTabView.selectCell(at: IndexPath(item: 0, section: 0))
    }
    
    private func setTitles(feeds: [Feed]) {
        titles = []
        for feed in feeds {
            titles.append(feed.title())
        }
    }
    
    @objc func changeSubscribeFeeds(notification: Notification) {
        let feedRepository = FeedRepository()
        let subscribeFeed = feedRepository.loadSubscribeFeed()
        setScrollTabView(feeds: subscribeFeed)
        setItemListViewPage(feeds: subscribeFeed)
    }
    
    @IBAction func didPushSettingButton(_ sender: Any) {
        let navigationController = UIStoryboard(name: "SettingList", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
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
    func scrollTabViewNumberOfTitles() -> Int {
        return titles.count
    }

    func scrollTabView(_ tabView: ScrollTabView, titleForTabAt indexPath: IndexPath) -> String {
        return titles[indexPath.row]
    }
}

extension FeedViewController: ScrollTabViewDelegate {
    func scrollTabView(_ view: ScrollTabView, didSelectIndexPath indexPath: IndexPath) {
        itemListViewPageController.scrollToPage(indexPath.row)
    }
}
