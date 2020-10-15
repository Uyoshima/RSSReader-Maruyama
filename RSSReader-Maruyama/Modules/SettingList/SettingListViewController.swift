//
//  SettingViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit

/// SettingListViewControllerに表示するコンテンツ
private enum SettingCellContent {
    case changeList
    case rssTerm
    case subscriptionEdit
    // TODO: 文字サイズ変更機能未実装のためコメントアウト
    // case fontSizeSetting
    
    func title() -> String {
        switch self {
        case .changeList: return "一覧画面の表示の切り替"
        case .rssTerm: return "RSS取得間隔"
        case .subscriptionEdit: return "購読RSSの管理"
        // TODO: 文字サイズ変更機能未実装のためコメントアウト
        // case .fontSizeSetting: return "文字サイズ変更"
        }
    }
    
    func detail() -> String {
        let userSetting = UserSetting.sharedObject
        switch self {
        case .changeList:
            return userSetting.getListStyle().rawValue
        case .rssTerm:
            return "\(userSetting.getRssInterval_min())分"
        case .subscriptionEdit:
            return "購読フィードの編集"
        // TODO: 文字サイズ変更機能未実装のためコメントアウト
        //case .fontSizeSetting:
        //   return userSetting.getFontSize().rawValue
        }
    }
    
    func viewController() -> UIViewController? {
        switch self {
        case .changeList:
            return UIStoryboard(name: "SelectListStyle", bundle: nil).instantiateInitialViewController()
        case .subscriptionEdit:
            return UIStoryboard(name: "SelectFeed", bundle: nil).instantiateInitialViewController()
        case .rssTerm:
            return UIStoryboard(name: "SettingRssInterval", bundle: nil).instantiateInitialViewController()
        }
    }
}

/// アプリの設定項目を表示するViewController
/// tableView: 設定項目を表示するTableView
/// cellContents: tableViewに表示するコンテンツ
class SettingListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var cellContents: [SettingCellContent] = {
        return [.changeList, .rssTerm, .subscriptionEdit]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func didPushCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.detailTextLabel?.text = cellContents[indexPath.row].detail()
        cell.textLabel?.text = cellContents[indexPath.row].title()
        
        return cell
    }
}

extension SettingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = cellContents[indexPath.row].viewController() else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
