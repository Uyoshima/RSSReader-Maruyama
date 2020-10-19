//
//  SettingListViewController.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/19.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class SettingListViewController: UIViewController {
    private lazy var authenticationService: AuthenticationService = {
        let authenticationStrategyLocator = AuthenticationStrategyLocator()
        authenticationStrategyLocator.add(type: .apple, strategy: AppleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .google, strategy: GoogleAuthenticationStrategy(delegate: self, presentingViewController: self))
        authenticationStrategyLocator.add(type: .facebook, strategy: FacebookAuthenticationStrategy(delegate: self, presentingViewController: self))
        
        return AuthenticationService(locator: authenticationStrategyLocator)
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let segmentedTitles: [String] = ["TableView", "CollectionView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingSegmentedControl()
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
    
    @IBAction func didPushSaveButton(_ sender: Any) {
        let userSetting = UserSetting.sharedObject
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            userSetting.set(listStyle: .table)
            break
        case 1:
            userSetting.set(listStyle: .collection)
            break
        default:
            break
        }
    }
    
    // 以下、ログイン関係
    
    private func showLoginView() {
        let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        loginViewController!.modalPresentationStyle = .overFullScreen
        present(loginViewController!, animated: true, completion: nil)
    }
    
    @IBAction func didPushLogout(_ sender: Any) {
        let userRepository = UserRepository()
        let user = userRepository.load()
        
        authenticationService.logout(user!)
    }

}

// ログアウト関係
extension SettingListViewController: AuthenticationDelegate {
    func didLogin(_ result: Result<User, Error>) {
    }
    
    func didLogout(_ result: Result<Void, Error>) {
        switch result {
        case .success():
            let userRepository = UserRepository()
            userRepository.delete()
            showLoginView()
            break
        case .failure(let error):
            Logger.debug("ログアウトエラー： \(error.localizedDescription)")
            break
        }
    }
}
