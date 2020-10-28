//
//  ItemListView.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/13.
//

import UIKit

protocol ItemListViewProtocol {
    var itemListDataSource: ItemListDataSource! { get }
    var itemListDelegate: ItemListDelegate! { get }
    
    func initialSetting()
    func addFillConstraint(to view: UIView)
    func itemListCellForRow(at indexPaht: IndexPath) -> ItemListCellProtocol
}
