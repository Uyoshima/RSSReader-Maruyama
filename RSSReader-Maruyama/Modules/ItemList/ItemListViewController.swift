//
//  ItemListViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit


/// 記事(Item)を表示するViewControler。
/// feed: 表示するフィード
/// pageIndex：ItemListViewPageControllerのpageIndex
/// items：表示する記事
/// userSetting：表示するリストのスタイルを取得する。
/// itemListTableVIew：UITableViewを継承したカスタムクラス。(ItemListDelegate、ItemListDataSourceを保持し、処理はこのクラスで行う)
/// itemListCollectionView： CollectionViewを継承したカスタムラス。(ItemListDelegate、ItemListDataSourceを保持し、処理はこのクラスで行う)
///
class ItemListViewController: UIViewController {
    var feed: Feed!
    var pageIndex: Int!
    
    internal var items: [Item] = []
    private var userSetting = UserSetting.sharedObject
    
    private var itemListTableView: ItemListTableView!
    private var itemListCollectionView: ItemListCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeListStyle(notification:)), name: Notification.Name.changeListStyle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeItemValue(notification:)), name: Notification.Name.changeReadLaterValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeItemValue(notification:)), name: Notification.Name.changeAlreadyReadValue, object: nil)
        
        setListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.debug("ItemListViewController: viewWillApperar(:_)")
        Logger.debug("ItemListViewController: feed.title() = \(feed.title())")
        reloadListView()
    }
    
    @objc func changeListStyle(notification: Notification) {
        setListView()
        reloadListView()
    }
    
    @objc private func changeItemValue(notification: Notification) {
        reloadListView()
    }
    
    func set(_ feed: Feed, pageIndex index: Int) {
        self.feed = feed
        title = feed.title()
        pageIndex = index
        getItem()
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
        view.layoutIfNeeded()
    }
    
    private func removeAllSubViews() {
        for view in view.subviews {
            view.removeFromSuperview()
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
    
    private func getItem() {
        let factory = YahooFeedItemFactory()
        factory.create(feed: feed) { (items) in
            self.items = items
            self.reloadListView()
        }
    }
    
    // TODO : WebViewControllerへ遷移する。
    private func transitionToWebViewController(with item: Item) {
        let navigationController = UIStoryboard.init(name: "WebView", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        let webViewController = navigationController.viewControllers[0] as! WebViewController
        webViewController.item = item
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Extensions

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
        let item = items[indexPath.row]
        transitionToWebViewController(with: item)
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
