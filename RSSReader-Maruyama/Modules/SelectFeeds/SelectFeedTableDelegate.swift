//
//  SelectFeedTableDelegate.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/13.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectFeedTableDelegate: NSObject {
    
}

// MARK: - Extension

extension SelectFeedTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
