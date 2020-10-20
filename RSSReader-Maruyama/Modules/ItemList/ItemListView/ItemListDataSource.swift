//
//  ItemListDataSource.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

protocol ItemListDataSource {
    func numberOfItemInsection(section: Int) -> Int
    func itemList(listCell: ItemListCellProtocol, itemForRowAt indexPath: IndexPath) -> ItemListCellProtocol
}
