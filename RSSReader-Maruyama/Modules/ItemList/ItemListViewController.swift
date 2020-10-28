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
    private var feed: Feed = .yahoo_Topic
    var items: [Item] = []
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        addTableView()
        getItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    /// 自信のFeedの記事を取得、ListViewをリロードし表示する。
    private func getItem() {
        let downloader = ItemDownloader()
        downloader.fetch(feed) { (result) in
            switch result {
            case .success(let xmlDate):
                let itemCreator = ItemCreator()
                self.items = itemCreator.createItem(feed: self.feed, xmlData: xmlDate)
                if self.itemListTableView != nil {
                    self.itemListTableView.reloadData()
                }
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
