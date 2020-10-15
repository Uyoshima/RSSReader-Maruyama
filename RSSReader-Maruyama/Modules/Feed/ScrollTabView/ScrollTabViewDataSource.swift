//
//  ScrollTabViewDataSource.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/09.
//

import UIKit

/// ScrollTabViewのDataを扱いたいクラスにて実装
protocol ScrollTabViewDataSource {
    /// 実装しているクラスで、ScrollTabViewで表示したいタイトルの数を返す
    func scrollTabViewNumberOfTitles() -> Int
    
    /// 実装しているクラスで、ScrollTabViewでindexPathのCellで表示したいタイトルを返す
    func scrollTabView(_ tabView: ScrollTabView, titleForTabAt indexPath: IndexPath) -> String
}
