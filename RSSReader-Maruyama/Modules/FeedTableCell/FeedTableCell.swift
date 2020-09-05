//
//  FeedTableCell.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/05.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setContents(feed: Feed) {
        self.logoImageView.image = UIImage(named: feed.logoName)
        self.nameLabel.text = feed.name
        self.urlLabel.text = feed.url
    }

}
