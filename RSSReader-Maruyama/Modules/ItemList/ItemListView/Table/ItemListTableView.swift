//
//  ItemListTableView.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/13.
//

import UIKit

class ItemListTableView: UITableView, ItemListViewProtocol {
    var itemListDataSource: ItemListDataSource!
    var itemListDelegate: ItemListDelegate!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetting()
    }
    
    internal func initialSetting() {
        delegate   = self
        dataSource = self
        let cellNib = UINib(nibName: "ItemListTableCell", bundle: nil)
        register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    /// 引数のViewと自信にtop.left.botom.rightのconstantを0に設定する
    /// - Parameter view: addSubViewされているView
    func addFillConstraint(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    /// TableViewCellのswipe action「後で読む」を 生成し返す
    /// - Parameter indexPath: スワイプされたcellのindexPath
    /// - Returns:ItemListDelegateのaddReadLaterAt(indexPath:_)処理を走らすアクションを返す。
    private func createAddReadLaterAction(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let action = UIContextualAction(style: .normal, title: "後で読む登録", handler: { (action, view, complitionHander) in
            guard let aDelegate = self.itemListDelegate else { return }
            let cell = self.cellForRow(at: indexPath) as! ItemListTableCell
            cell.setReadLaterLabel(isReadLater: true)
            aDelegate.addReadLaterAt(indexPath: indexPath)
            
            complitionHander(true)
        })
        action.backgroundColor = .systemGreen
        action.image = UIImage(named: "label")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    /// TableViewCellのswipe action「後で読む解除」を 生成し返す
    /// - Parameter indexPath: スワイプされたcellのindexPath
    /// - Returns:ItemListDelegateのremoveReadLaterAt(indexPath:_)処理を走らすアクションを返す。
    private func createRemoveReadLateAction(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let action = UIContextualAction(style: .normal, title: "後で読む解除", handler: { (action, view, complitionHander) in
            guard let aDelegate = self.itemListDelegate else { return }
            let cell = self.cellForRow(at: indexPath) as! ItemListTableCell
            cell.setReadLaterLabel(isReadLater: false)
            aDelegate.removeReadLaterAt(indexPath: indexPath)
            complitionHander(true)
        })
        action.backgroundColor = .systemRed
        action.image = UIImage(named: "label")
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Extensions

extension ItemListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let aDataSource = itemListDataSource else {
            return 0
        }
        return aDataSource.numberOfItemInsection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemListTableCell
        let item = itemListDataSource.itemList(itemForRowAt: indexPath)
        cell.setContents(item: item, indexPath: indexPath)
        
        return cell
    }
}

extension ItemListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let aDelegate = itemListDelegate else { return }
        aDelegate.itemList(didSelectedRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = (tableView.cellForRow(at: indexPath) as! ItemListCell).item!
        if item.isReadLater {
            return createRemoveReadLateAction(indexPath: indexPath)
        } else {
            return createAddReadLaterAction(indexPath: indexPath)
        }
    }
}
