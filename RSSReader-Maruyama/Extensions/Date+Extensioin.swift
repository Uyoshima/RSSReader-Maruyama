//
//  Date+Extensioin.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/18.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

extension Date {
    public func formatted(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func toString(_ dateFormat: String) -> String {
        let formtter = DateFormatter()
        formtter.locale = Locale(identifier: "ja_JP")
        formtter.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        formtter.dateFormat = dateFormat
        
        return formtter.string(from: self)
    }
}
