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
        
        // 設定画面で表示スタイルの変更が合った時のオブザーバー
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeListStyle(notification:)),
                                               name: Notification.Name.changeListStyle,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    /// 自信のFeedの記事を取得、ListViewをリロードし表示する。
    private func getItem() {
        let downloader = ItemDownloader()
        downloader.fetch(feed) { (result) in
            switch result {
            case .success(let xmlDate):
                let itemCreator = ItemCreator()
                self.items = itemCreator.createItem(feed: self.feed, xmlData: xmlDate)
                self.reloadListView()
                break
                
            case .failure(let error):
                let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                self.showAlert(title: "取得エラー", message: "\(error.localizedDescription)", actions: [closeAction])
                break
            }
        }
    }

    /// 引数の要素をセットし、Itemの取得をする。
    /// - Parameters:
    ///   - feed: 表示するフィードの種類
    ///   - index: PageViewControllerのページ番号
    func set(_ feed: Feed, pageIndex index: Int) {
        self.feed = feed
        title = feed.title()
        pageIndex = index
        getItem()
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
        Logger.debug("生成するCellのIndexPath: \(indexPath)")
        Logger.debug("itemのReadlater: \(item.isReadLater)")

        listCell.setContents(item: item, indexPath: indexPath)
        return listCell
    }
}

extension ItemListViewController: ItemListDelegate {
    func itemList(didSelectedRowAt indexPath: IndexPath) {
        // TODO: 選択された記事のWebページを表示する。
    }
    
    func addReadLaterAt(indexPath: IndexPath) {
        // TODO: indexPathの記事を「後で読む」にする。
        Logger.debug("後で読むに追加したIndexPath: \(indexPath)")
        let item = items[indexPath.row]
        item.isReadLater = true
        reloadListView()
    }
    
    func removeReadLaterAt(indexPath: IndexPath) {
        // TODO: 選択された記事に「後で読む」を解除する。
        Logger.debug("後で読むを解除したIndexPath: \(indexPath)")
        let item = items[indexPath.row]
        item.isReadLater = false
        reloadListView()
    }
}
