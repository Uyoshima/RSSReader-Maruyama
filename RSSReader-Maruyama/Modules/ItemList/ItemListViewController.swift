//
//  ItemListViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    private var itemListTableView: ItemListTableView!
    private var itemListCollectionView: ItemListCollectionView!
    
    private var userSetting = UserSetting.sharedObject
    private var feed: Feed = .yahoo_Topic
    var items: [Item] = []
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setListView()
        getItem()
        
        // 設定画面で表示スタイルの変更があった時のオブザーバー
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeListStyle(notification:)),
                                               name: Notification.Name.changeListStyle,
                                               object: nil)
        // 記事の「後で読む」に変更があった時のオブザーバー
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadListViewFromObserver(notification:)),
                                               name: Notification.Name.changeReadLaterValue,
                                               object: nil)
        // 記事が既読状態に変更された時のオブザーバー
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadListViewFromObserver(notification:)),
                                               name: Notification.Name.changeAlreadyReadValue,
                                               object: nil)
        
        // フォントサイズの変更された時のオブザーバー
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListViewFromObserver(notification:)),
                                               name: Notification.Name.changeFontSize,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadListView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setListView() {
        switch userSetting.getListStyle() {
        case .table:
            createTableView()
            addTableView()
            break
        case .collection:
            createCollectionView()
            addCollectionView()
            break
        }
    }
    
    private func createTableView() {
        itemListTableView = ItemListTableView(frame: view.frame, style: .plain)
        itemListTableView.itemListDelegate = self
        itemListTableView.itemListDataSource = self
    }
    
    private func createCollectionView() {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.minimumLineSpacing = 0
        itemListCollectionView = ItemListCollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        itemListCollectionView.itemListDelegate = self
        itemListCollectionView.itemListDataSource = self
    }
    
    private func addTableView() {
        removeAllSubViews()
        view.addSubview(itemListTableView)
        itemListTableView.addFillConstraint(to: view)
    }
    
    private func addCollectionView() {
        removeAllSubViews()
        view.addSubview(itemListCollectionView)
        itemListCollectionView.addFillConstraint(to: view)
    }
    
    private func removeAllSubViews() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func reloadListView() {
        switch userSetting.getListStyle() {
        case .table:
            guard let tableView = itemListTableView else { return }
            tableView.reloadData()
            break
        case .collection:
            guard let collectionView = itemListCollectionView else { return }
            collectionView.reloadData()
            break
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func changeListStyle(notification: Notification) {
        setListView()
        reloadListView()
    }
    
    @objc func reloadListViewFromObserver(notification: Notification) {
        reloadListView()
    }
    
    /// 自信のFeedの記事を取得、生成する。
    private func getItem() {
        let downloader = ItemDownloader()
        downloader.fetch(feed) { (result) in
            switch result {
            case .success(let xmlDate):
                let itemCreator = ItemCreator()
                let items = itemCreator.createItem(feed: self.feed, xmlData: xmlDate)
                self.successGetItems(items: items)
                break
                
            case .failure(let error):
                let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                self.showAlert(title: "取得エラー", message: "\(error.localizedDescription)", actions: [closeAction])
                break
            }
        }
    }
    
    private func successGetItems(items: [Item]) {
        let itemRepository = ItemRepository()
        itemRepository.save(items: items)
        self.items = itemRepository.get(feed: feed)
        self.reloadListView()
    }

    private func transitionToWebViewController(with item: Item) {
        let navigationController = UIStoryboard.init(name: "WebView", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigationController.modalPresentationStyle = .overFullScreen

        let webViewController = navigationController.viewControllers[0] as! WebViewController
        webViewController.item = item
        
        present(navigationController, animated: true, completion: nil)
    }
    
    /// 引数の要素をセットし、Itemの取得をする。
    /// - Parameters:
    ///   - feed: 表示するフィードの種類
    ///   - index: PageViewControllerのページ番号
    func set(_ feed: Feed, pageIndex index: Int) {
        self.feed = feed
        title = feed.title()
        pageIndex = index
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
    
    func itemList(listCell: ItemListCellProtocol, itemForRowAt indexPath: IndexPath) -> ItemListCellProtocol {
        let item = items[indexPath.row]
        listCell.setContents(item: item, indexPath: indexPath)
        
        return listCell
    }
}

extension ItemListViewController: ItemListDelegate {
    func itemList(didSelectedRowAt indexPath: IndexPath) {
        transitionToWebViewController(with: items[indexPath.row])
    }
    
    func addReadLaterAt(indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemRepository = ItemRepository()
        itemRepository.addReadLater(item: item)
    }
    
    func removeReadLaterAt(indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemRepository = ItemRepository()
        itemRepository.removeReadLater(item: item)
    }
}
