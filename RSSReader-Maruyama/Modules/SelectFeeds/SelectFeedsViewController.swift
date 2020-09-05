//
//  SelectFeedsViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/05.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectFeedsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let feedsList: [Feed] = FeedManager().feedsList()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingNavigationItem()
        settingTableView()
    }
    
    private func settingNavigationItem() {
        self.navigationItem.hidesBackButton = true
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didPushSave))
        saveButton.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func settingTableView() {
        tableView.allowsMultipleSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "FeedTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    
    private func saveSelectedFeeds(selectedIndexPaths: [IndexPath]) {
        let feedManager = FeedManager()
        var selectFeeds: [Feed] = []
                
        for indexPath in selectedIndexPaths {
            selectFeeds.append(self.feedsList[indexPath.row])
        }
        feedManager.setSubscribeFeeds(feeds: selectFeeds)
        

    }
    
    @objc fileprivate func didPushSave() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        saveSelectedFeeds(selectedIndexPaths: selectedIndexPaths)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
}

extension SelectFeedsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableCell
        let feed = feedsList[indexPath.row]
        cell.setContents(feed: feed)
        
        return cell
    }
    
}

extension SelectFeedsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
