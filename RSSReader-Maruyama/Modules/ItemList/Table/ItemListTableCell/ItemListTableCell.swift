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
        
        let textColor = getTextColor(isAlreadyRead: item.isAlreadyRead)
        pubDateLabel.textColor     = textColor
        titleLabel.textColor       = textColor
        descriptionLabel.textColor = textColor
    
        setReadLaterLabel(isReadLater: item.isReadLater)
        
        setFontSize()
    }
    
    private func setFontSize() {
        let fontSize = UserSetting.sharedObject.getFontSize()
        
        pubDateLabel.font     = UIFont.systemFont(ofSize: fontSize.pubTextSize())
        titleLabel.font       = UIFont.systemFont(ofSize: fontSize.titleSize())
        descriptionLabel.font = UIFont.systemFont(ofSize: fontSize.textSize())
    }
    
    func setReadLaterLabel(isReadLater: Bool) {
        if isReadLater {
            readLaterImageView.isHidden = false
        } else {
            readLaterImageView.isHidden = true
        }
    }
    
    func getTextColor(isAlreadyRead: Bool) -> UIColor {
        if isAlreadyRead {
            return UIColor(named: "text-alreadyRead")!
        } else {
            return UIColor(named: "text-normal")!
        }
    }
}
