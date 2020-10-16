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
}
