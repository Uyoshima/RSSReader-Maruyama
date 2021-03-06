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
    
    @IBOutlet weak var tableView: UITableView!
    
    private enum SettingDataSource {
        case subscription
        case listStyle
        case fontSize
        case rssInterval
        case filterSetting
        
        func title() -> String {
            switch self {
            case .subscription:  return "購読フィードの編集"
            case .listStyle:     return "表示形式の変更"
            case .fontSize:      return "文字サイズの変更"
            case .rssInterval:   return "RSS取得間隔の変更"
            case .filterSetting: return "表示記事の設定"
            }
        }
        
        func viewController() -> UIViewController {
            switch self {
            case .subscription:
                return UIStoryboard(name:"SelectFeed", bundle: nil).instantiateInitialViewController()!
            case .listStyle:
                return UIStoryboard(name: "SelectListStyle", bundle: nil).instantiateInitialViewController()!
            case .fontSize:
                return UIStoryboard(name: "SelectFontSize", bundle: nil).instantiateInitialViewController()!
            case .rssInterval:
                return UIStoryboard(name: "SelectRSSInterval", bundle: nil).instantiateInitialViewController()!
            case .filterSetting:
                return UIStoryboard(name: "SelectListFilter", bundle: nil).instantiateInitialViewController()!
            }
        }
    }
    
    private let cellData: [SettingDataSource] = [.subscription, .listStyle, .fontSize, .rssInterval, .filterSetting]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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

extension SettingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellData[indexPath.row].title()
        
        return cell
    }
}

extension SettingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = cellData[indexPath.row].viewController()
        navigationController?.pushViewController(vc, animated: true)
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
