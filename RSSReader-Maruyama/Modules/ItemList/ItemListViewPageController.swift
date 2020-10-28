//
//  ItemListPageViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/08.
//

import UIKit

protocol ItemListViewPageControllerDelegate {
    func itemListViewPageController(_ controller: ItemListViewPageController, didSelectedIndexPath indexPath: IndexPath)
}

/// ItemListViewControllerを管理する。
/// controllers: 管理するViewController配列
/// currentPageIndex: 現在表示している controllers のindex
class ItemListViewPageController: UIPageViewController {
    
    private var controllers: [UIViewController] = []
    private var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewControllers() //最初
    }
    
    func setCurrentPage(_ index: Int) {
        currentPageIndex = index
    }
    
    func scrollToPage(_ pageIndex: Int) {
        if currentPageIndex < pageIndex {
            setViewControllers([controllers[pageIndex]], direction: .forward, animated: true, completion: nil)
        } else if currentPageIndex > pageIndex {
            setViewControllers([controllers[pageIndex]], direction: .reverse, animated: true, completion: nil)
        }
        currentPageIndex = pageIndex
    }
    
    /// 管理するViewControllerをセット
    func settingViewControllers() {
        let feedRepository = FeedRepository()
        let subscribeFeeds = feedRepository.loadSubscribeFeed()
        if subscribeFeeds.count == 0 {
            return
        }
        controllers = createViewControllers(subscribeFeeds)
        setViewControllers([controllers[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    private func createViewControllers(_ feeds:[Feed]) -> [UIViewController] {
        controllers = []
        for i in 0..<feeds.count {
            let itemListViewController = ItemListViewController()
            itemListViewController.set(feeds[i], pageIndex: i)
            controllers.append(itemListViewController)
        }
        return controllers
    }
}
