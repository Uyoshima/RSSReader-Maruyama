//
//  ItemListTableCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

class ItemListTableCell:UITableViewCell, ItemListCell {
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readLaterImageView: UIImageView!
    
    var item: Item!
    var indexPath: IndexPath!

    func setContents(item: Item, indexPath: IndexPath) {
        self.item = item
        pubDateLabel.text = item.pubDate.toString("yyyy年MM月dd日 HH:mm:ss")
        titleLabel.text = item.title
        descriptionLabel.text = item.description_item
        
        setReadLaterLabel(isReadLater: item.isReadLater)
        
        let color = getTextColorStyle(isAlreadyRead: item.isAlreadyRead)
        setTextColor(color)
    }
    
    func getTextColorStyle(isAlreadyRead: Bool) -> UIColor {
        if isAlreadyRead {
            return UIColor(named: "text-alreadyRead")!
        } else {
            return UIColor(named: "text-normal")!
        }
    }
    
    func setTextColor(_ color: UIColor) {
        pubDateLabel.textColor = color
        titleLabel.textColor = color
        descriptionLabel.textColor = color
    }
    
    func setReadLaterLabel(isReadLater: Bool) {
        if isReadLater {
            readLaterImageView.isHidden = false
        } else {
            readLaterImageView.isHidden = true
        }
    }
}
