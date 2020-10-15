//
//  SelectListStyleViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/14.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

/// 記事の表示スタイルの変更を行うViewController
/// segmentedControl:  tableView, collectoinViewの切り替えが出来る。
class SelectListStyleViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        let currentStyle = UserSetting.sharedObject.getListStyle()
        switch currentStyle {
        case .table:
            segmentedControl.selectedSegmentIndex = 0
            break
        case .collection:
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func getSelectListStyle() -> ItemListStyle {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return .table
        case 1:
            return .collection
        default:
            return .table
        }
    }
}

extension SelectListStyleViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is SettingListViewController {
            let userSetting = UserSetting.sharedObject
            userSetting.set(listStyle: getSelectListStyle())
            NotificationCenter.default.post(name: Notification.Name.changeListStyle, object: nil)
        }
    }
}
