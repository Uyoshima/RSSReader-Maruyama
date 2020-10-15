//
//  ItemListCollectionCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit

protocol ItemListCollectionCellDelegate {
    func didPushReadLaterButton(with item: Item, indexPath: IndexPath)
}

class ItemListCollectionCell: UICollectionViewCell, ItemListCell {

    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var readLaterButton: UIButton!
    
    var delegate: ItemListCollectionCellDelegate!
    var item: Item!
    var indexPath: IndexPath!
    
    func setContents(item: Item, indexPath: IndexPath) {
        self.item = item
        self.indexPath = indexPath
        pubDateLabel.text = item.pubDate.toString("yyyy年MM月D日")
        titleLabel.text = item.title
        descriptionLabel.text = item.description_item
        
        setReadLaterButtonImage(item.isReadLater)
        
        wrapView.backgroundColor = UIColor(named: "card-background")
        wrapView.layer.cornerRadius = 10
        wrapView.layer.shadowColor = UIColor.black.cgColor
        wrapView.layer.shadowOffset = CGSize(width: 0, height: 0)
        wrapView.layer.shadowRadius = 3
        wrapView.layer.shadowOpacity = 0.2
        
        let textColor = getTextColorStyle(isAlreadyRead: item.isAlreadyRead)
        setTextColor(textColor)
    }

    private func setReadLaterButtonImage(_ isReadLater: Bool) {
        if isReadLater {
            readLaterButton.setImage(UIImage(named: "label")!, for: .normal)
        } else {
            readLaterButton.setImage(UIImage(named: "label-border")!, for: .normal)
        }
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
    
    @IBAction func didPushReadLaterButton(_ sender: Any) {
        guard let aDelegate = delegate else { return }
        aDelegate.didPushReadLaterButton(with: item, indexPath: indexPath)
        setReadLaterButtonImage(item.isReadLater)
    }
}
