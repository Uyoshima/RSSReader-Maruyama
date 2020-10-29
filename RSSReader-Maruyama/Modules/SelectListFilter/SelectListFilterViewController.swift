//
//  SelectListFilterViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/29.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectListFilterViewController: UIViewController {

    @IBOutlet weak var unreadOnlySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarButton()
        settingSwitch()
    }
    
    private func settingSwitch() {
        let currentFilter = UserSetting.sharedObject.getFillter()
        switch currentFilter {
        case .all:
            unreadOnlySwitch.setOn(false, animated: false)
            break
        case .unread:
            unreadOnlySwitch.setOn(true, animated: false)
            break
        }
    }
    
    private func setNavBarButton() {
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(didPushSaveButton(_:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @objc private func didPushSaveButton(_ sender: Any) {
        let userSetting = UserSetting.sharedObject
        if unreadOnlySwitch.isOn {
            userSetting.set(filterSetting: .unread)
        } else {
            userSetting.set(filterSetting: .all)
        }
        NotificationCenter.default.post(name: NSNotification.Name.changeFilterSetting, object: nil)
    }

}
