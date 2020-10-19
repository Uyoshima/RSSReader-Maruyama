//
//  ScrollTabViewDelegate.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/09.
//

import UIKit

protocol ScrollTabViewDelegate {
    func scrollTabView(_ view: ScrollTabView, didSelectIndexPath indexPath: IndexPath)
}
