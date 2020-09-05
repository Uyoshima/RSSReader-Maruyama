//
//  ItemListViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class ItemListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    @IBAction func didPushLogout(_ sender: Any) {
        let userDataManager = UserDataManager()
        userDataManager.removeUserData()
        
        // ログアウト
        logoutFromFacebook()
        logoutFromGoogle()
        
        NotificationCenter.default.post(name: .didLogOut, object: nil)
    }
    
    
    private func logoutFromFacebook() {
        let manager = FBSDKLoginKit.LoginManager()
        manager.logOut()
    }
    
    private func logoutFromGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
    }
}
