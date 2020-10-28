//
//  SelectFontSizeViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/28.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectFontSizeViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSegmentedControl() 
        setNavBarButton()
    }

    private func settingSegmentedControl() {
        let currentFontSize = UserSetting.sharedObject.getFontSize()
        segmentedControl.selectedSegmentIndex = currentFontSize.rawValue
    }

    
    private func setNavBarButton() {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(didPushSaveButton(_:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @objc private func didPushSaveButton(_ sender: Any) {
        let userSetting = UserSetting.sharedObject
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            userSetting.set(fontSize: .small)
            break
        case 1:
            userSetting.set(fontSize: .midum)
            break
        default:
            userSetting.set(fontSize: .big)
            return
        }
        NotificationCenter.default.post(name: Notification.Name.changeFontSize, object: nil)
    }
    
}
