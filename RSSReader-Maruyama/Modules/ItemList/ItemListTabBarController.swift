//
//  ItemListTabBarController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class ItemListTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loginChack() {
            performSegue(withIdentifier: "login", sender: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginViewController), name: .didLogOut, object: nil)
    }
    
    
    func loginChack() -> Bool {
          let userDataManager = UserDataManager()
          return userDataManager.exists()
    }

    
    @objc fileprivate func showLoginViewController() {
        performSegue(withIdentifier: "login", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "login" {
            let loginViewController = segue.destination as! UINavigationController
            loginViewController.modalPresentationStyle = .overFullScreen
        }
    }

}
