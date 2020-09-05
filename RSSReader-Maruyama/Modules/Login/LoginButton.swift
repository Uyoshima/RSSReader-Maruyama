//
//  LoginButton.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/04.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

class LoginButton: UIButton
{

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
        
     self.clearsContextBeforeDrawing = true
     self.translatesAutoresizingMaskIntoConstraints = false
     self.heightAnchor.constraint(equalToConstant: 45).isActive = true
     self.layer.masksToBounds = true
     self.layer.cornerRadius = 8
     self.layer.borderWidth = 1.5
     self.layer.borderColor = UIColor.black.cgColor
     self.backgroundColor = .white
     self.setTitleColor(.black, for: .normal)
     self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
     self.setTitle(text, for: .normal)
     let iconView = UIImageView()
     self.addSubview(iconView)
     iconView.contentMode = .scaleAspectFit
     iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
     iconView.translatesAutoresizingMaskIntoConstraints = false
     iconView.image = UIImage(named: icon)
     iconView.widthAnchor.constraint(equalToConstant: 25).isActive = true
     iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
    }

}
