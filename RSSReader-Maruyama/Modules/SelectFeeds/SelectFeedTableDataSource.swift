//
//  SelectFeedTableDataSource.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/13.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectFeedTableDataSource: NSObject {
    private var feeds: [Feed]
    private var cellIdentifier: String
    
    init(_ tableView: UITableView, feeds: [Feed], cellIdentifier: String) {
        self.feeds = feeds
        self.cellIdentifier = cellIdentifier
        
        let cellNib = UINib(nibName: "FeedTableCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func isSelected(_ tableView: UITableView, indexPath: IndexPath) -> Bool {
        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            return false
        }
        return indexPaths.contains(indexPath)
    }
}

// Extension
extension SelectFeedTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableCell
        let feed = feeds[indexPath.row]
        cell.setContents(feed)
        
        if isSelected(tableView, indexPath: indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
}
