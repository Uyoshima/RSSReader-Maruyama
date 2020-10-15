//
//  Factory.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/08.
//

import UIKit

protocol ItemFactoryProtocol {
    func create(feed: Feed, created: @escaping (([Item])->Void))
}
