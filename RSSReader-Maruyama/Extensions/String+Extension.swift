//
//  String+Extension.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/18.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

extension String {
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var fileName: String {
        return self.lastPathComponent.components(separatedBy: ".").first ?? ""
    }
}
