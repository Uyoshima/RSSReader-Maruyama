//
//  ItemViewController.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/13.
//

import UIKit
import WebKit


/// 記事のWebページを表示するクラス。
/// webView: 記事のWebページを表示するView
/// backButton: webViewの「前のページ」ボタン
/// forwardButton: webViewの「次のページ」ボタン
/// readLaterButton: 表示している記事(item)を「後で読む」に追加・削除するボタン
class WebViewController: UIViewController {
    private var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var readLaterButton: UIBarButtonItem!
    
    var item: Item!
    var observations = [NSKeyValueObservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemGreen
        setWebView()
        setObservations()
        // 後で読むボタンの状態をセット。
        setReadLaterButton(state: item.isReadLater)

        // 記事自体を既読状態にして、「既読ボタン」を既読状態にする。
        changeAlreadyRead(value: true)
        
        // web内の戻る、進む、ボタンの状態の初期値を設定。
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        // webViewに記事のURLをセットし表示。
        let urlRequest = URLRequest(url: URL(string: item.url)!)
        webView.load(urlRequest)
    }
    
    
    /// 表示している記事(item)を既読・未読状態に変更
    /// - Parameter value: true -> 既読、 false -> 未読
    private func changeAlreadyRead(value: Bool) {
        let itemRepository = ItemRepository()
        itemRepository.setAlreadyRead(item: item)
        NotificationCenter.default.post(name: Notification.Name.changeAlreadyReadValue, object: nil)
    }
    
    /// readLaterButonの画像をBool値で切り替える
    /// - Parameter isReadLater: itemのisReadLaterを渡す。
    private func setReadLaterButton(state isReadLater: Bool) {
        if isReadLater {
            readLaterButton.image = UIImage(named: "label")
        } else {
            readLaterButton.image = UIImage(named: "label-border")
        }
    }
    
    /// webViewを初期化してviewにaddSubViewする。
    private func setWebView() {
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    /// WebViewの .canGoBack、.canGoForwardの値を監視し、変更があれば backButton、forwadButtonのisEnabledを変更する
    private func setObservations() {
        observations.append(webView.observe(\.canGoBack, options: .new){ _, change in
            if let value = change.newValue {
                DispatchQueue.main.async {
                    self.backButton.isEnabled = value
                }
            }
        })

        observations.append(webView.observe(\.canGoForward, options: .new){ _, change in
            if let value = change.newValue {
                 DispatchQueue.main.async {
                self.forwardButton.isEnabled = value
                }
            }
        })
    }
    
    @IBAction func didPushBackPageButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func didPushForwardPageButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func didPushReadLaterButton(_ sender: Any) {
        item.isReadLater = !item.isReadLater
        setReadLaterButton(state: item.isReadLater)
    }

    @IBAction func didPushShareButton(_ sender: Any) {
    }
    
    @IBAction func didPushClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: UIWebViewDelegate {
}
