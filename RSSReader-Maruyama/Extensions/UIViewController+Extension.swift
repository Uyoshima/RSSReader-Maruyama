//
//  UIViewController+Extension.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/18.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions:[UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach{ alert.addAction($0) }
        
        present(alert, animated: true, completion: nil)
    }
}
