//
//  FeedDownloadService.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/08.
//

import UIKit
import Alamofire

class ItemDownloader: NSObject {
    private var imtes: [Item] = []
    private var parseingItem: Item!
    
    func fetch(_ feed: Feed, responseData: @escaping ( (Result<Data, Error>)->Void) ) {
        AF.request(feed.url(), method: .get)
            .response { (dataResponse) in
                guard let data = dataResponse.data else {
                    responseData(.failure(dataResponse.error!))
                    return
                }
                responseData(.success(data))
            }
    }
}


