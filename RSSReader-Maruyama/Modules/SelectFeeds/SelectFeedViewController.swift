//
//  SelectFeedViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit


/// 購読するFeedを選択、保存するViewController
/// tableView: 購読可能なFeedを表示。
/// tableDataSource: tableViewのdataSource
/// tableDelegate: tableViewのdelegate
/// feedRepository: Feedのリストや購読中のFeedの取得、保存を行う
/// isFromLoginView: LoginViewControllerかSettingListViewControllerのどちらで呼ばれたかを判断する為に使用。
class SelectFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var tableDataSource: SelectFeedTableDataSource!
    private var tableDelegate = SelectFeedTableDelegate()
    
    private let feedRepository = FeedRepository()
    
    var isFromLoginView: Bool = false
    
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
        navigationController?.navigationBar.tintColor = .systemGreen
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
        if !isSuccess {
            let closeAction = UIAlertAction(title: "閉じる", style: .default)
            showAlert(title: "エラー", message: "保存失敗", actions: [closeAction])
            return
        }
        
        postNotification(name: Notification.Name.changeSubscribeFeeds)
        if isFromLoginView {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
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
