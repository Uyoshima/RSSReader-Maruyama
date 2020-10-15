//
//  ScrollTabViewCell.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//

import UIKit


/// ScrollTabViewで使用されるCell
class ScrollTabViewCell: UICollectionViewCell {
    @IBOutlet weak var textlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGreen.cgColor
        layer.cornerRadius = 4
        
        let selectedView = UIView(frame: frame)
        selectedView.backgroundColor = .systemGreen
        selectedBackgroundView = selectedView
        textlabel.textColor = UIColor(named: "tab-text")
    }
    
    func setTextColor(_ color: UIColor) {
        textlabel.textColor = color
    }
}
