//
//  ItemListTableCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

class ItemListTableCell:UITableViewCell, ItemListCellProtocol {
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: Item!
    var indexPath: IndexPath!

    func setContents(item: Item, indexPath: IndexPath) {
        self.item = item
        titleLabel.text = item.title
        descriptionLabel.text = item.description_item
    }
}
