//
//  LoginButton.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
     
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
     
    func custom(text: String, icon: String) {
        clearsContextBeforeDrawing = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitle(text, for: .normal)
        
        let iconView = UIImageView()
        addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(named: icon)
        iconView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    }

}
