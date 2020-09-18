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
}
