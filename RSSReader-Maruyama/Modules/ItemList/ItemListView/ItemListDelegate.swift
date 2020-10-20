//
//  ItemListDelegate.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/08.
//

import UIKit

protocol ItemListDelegate {
    func itemList(didSelectedRowAt indexPath: IndexPath)
    func addReadLaterAt(indexPath: IndexPath)
    func removeReadLaterAt(indexPath: IndexPath)
}
