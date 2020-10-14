//
//  FeedTableCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/06.
//

import UIKit

class FeedTableCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setContents(_ feed: Feed) {
        iconImageView.image = feed.icon()
        titleLabel.text = feed.title()
    }
}
