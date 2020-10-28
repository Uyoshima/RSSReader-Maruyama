//
//  SelectRSSIntervalViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/28.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SelectRSSIntervalViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    private let maxInterval_min: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let currentInterval_min = UserSetting.sharedObject.getRssInterval_min()
        pickerView.selectRow(currentInterval_min - 1, inComponent: 0, animated: false)
    }
}

// MARK: - Extension
extension SelectRSSIntervalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxInterval_min
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)分"
    }
}

extension SelectRSSIntervalViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newInterval = Double(row + 1) * 60
        UserSetting.sharedObject.set(rssInterval_sec: newInterval)
    }
}
