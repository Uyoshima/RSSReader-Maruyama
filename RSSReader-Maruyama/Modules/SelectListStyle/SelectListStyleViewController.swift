//
//  SelectListStyleViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/28.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectListStyleViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let segmentedTitles: [String] = ["TableView", "CollectionView"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingSegmentedControl()
        setNavBarButton()
    }
    
    private func settingSegmentedControl() {
        for i in 0 ..< segmentedTitles.count {
            segmentedControl.setTitle(segmentedTitles[i], forSegmentAt: i)
        }
        
        let currentStyle = UserSetting.sharedObject.getListStyle()
        switch currentStyle {
        case .table:
            segmentedControl.selectedSegmentIndex = 0
            break
        case .collection:
            segmentedControl.selectedSegmentIndex = 1
            break
        }
    }
    
    private func setNavBarButton() {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(didPushSaveButton(_:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @objc private func didPushSaveButton(_ sender: Any) {
        let userSetting = UserSetting.sharedObject
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            userSetting.set(listStyle: .table)
            break
        case 1:
            userSetting.set(listStyle: .collection)
            break
        default:
            return
        }
        NotificationCenter.default.post(name: Notification.Name.changeListStyle, object: nil)
    }
    
}
