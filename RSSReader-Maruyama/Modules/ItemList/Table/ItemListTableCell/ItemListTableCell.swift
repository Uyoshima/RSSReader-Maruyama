//
//  ItemListTableCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

class ItemListTableCell:UITableViewCell, ItemListCellProtocol {
    @IBOutlet weak var readLaterImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: Item!
    var indexPath: IndexPath!

    func setContents(item: Item, indexPath: IndexPath) {
        self.item = item
        pubDateLabel.text = item.pubDate.toString("yyyy年MM月dd日 HH:mm:ss")
        titleLabel.text = item.title
        descriptionLabel.text = item.description_item
        
        setReadLaterLabel(isReadLater: item.isReadLater)
    }
    
    func setReadLaterLabel(isReadLater: Bool) {
        if isReadLater {
            readLaterImageView.isHidden = false
        } else {
            readLaterImageView.isHidden = true
        }
    }
}
