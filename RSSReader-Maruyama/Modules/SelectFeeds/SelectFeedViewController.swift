//
//  SelectFeedViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit

class SelectFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var tableDataSource: SelectFeedTableDataSource!
    private var tableDelegate = SelectFeedTableDelegate()
    
    private let feedRepository = FeedRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSource = SelectFeedTableDataSource(tableView, feeds: feedRepository.ALL_FEEDS, cellIdentifier: "cell")
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
        
        let subscribeFeeds = feedRepository.loadSubscribeFeed()
        for feed in subscribeFeeds {
            tableView.selectRow(at: IndexPath(row: feed.rawValue, section: 0), animated: false, scrollPosition: .none)
        }
        
        setNavBarButton()
    }
    
    private func setNavBarButton() {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(didPushSaveButton(sender:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @objc private func didPushSaveButton(sender: Any) {
        let selectedFeeds = getSelectedFeeds()
        if selectedFeeds.count == 0 {
            let closeAction = UIAlertAction(title: "閉じる", style: .default)
            showAlert(title: "フィード未選択", message: "フィードを選択してくだいさい。", actions: [closeAction])
            return
        }
        saveFeedToSubscribe(selectedFeeds)
    }
    
    /// フィードをFeedRepositoryを使用して保存します。
    /// - Parameter feeds: 保存したいフィード配列
    private func saveFeedToSubscribe(_ feeds: [Feed]) {
        let isSuccess = feedRepository.saveSubscribe(feeds)
        if isSuccess {
            navigationController?.dismiss(animated: true, completion: nil)
            postNotification(name: Notification.Name.changeSubscribeFeeds)
        } else {
            let closeAction = UIAlertAction(title: "閉じる", style: .default)
            showAlert(title: "エラー", message: "保存失敗", actions: [closeAction])
        }
    }
    
    /// TableViewで選択されているフィードを返します。
    /// - Returns: 選択しているFeedを配列で返します。
    private func getSelectedFeeds() -> [Feed] {
        var selectedRows = tableView.indexPathsForSelectedRows
        selectedRows?.sort()
        
        guard let sortedIntexPaths = selectedRows else {
            return []
        }
        
        var selectedFeeds: [Feed] = []
        for indexPath in sortedIntexPaths {
            selectedFeeds.append(feedRepository.ALL_FEEDS[indexPath.row])
        }
        
        return selectedFeeds
    }
    
    private func postNotification(name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
    }
}
