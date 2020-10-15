//
//  ItemListCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

protocol ItemListCell {
    var indexPath: IndexPath! { get }
    var item: Item! { get }
    func setContents(item: Item, indexPath: IndexPath)
    func getTextColorStyle(isAlreadyRead: Bool) -> UIColor
    func setTextColor(_ color: UIColor)
}
