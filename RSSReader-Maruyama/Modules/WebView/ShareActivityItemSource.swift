//
//  ShareActivityItemSource.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/10/28.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    private let url: URL

    init(_ url: URL) {
        self.url = url
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        url
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
         url
    }
}
