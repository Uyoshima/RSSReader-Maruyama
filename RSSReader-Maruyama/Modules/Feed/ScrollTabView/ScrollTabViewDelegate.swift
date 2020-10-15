//
//  ScrollTabViewDelegate.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/09.
//

import UIKit

/// ScrollTabViewの選択を受け取りたいクラスにて実装
protocol ScrollTabViewDelegate {
    
    /// ScrollTabViewにて選択されたcellのIndexPathを渡す。
    /// - Parameters:
    ///   - view: 選択されたcellを表示しているScrollTabView
    ///   - indexPath: 選択されたCellのIndexPath
    func scrollTabView(_ view: ScrollTabView, didSelectIndexPath indexPath: IndexPath)
}
