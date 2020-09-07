//
//  IconableButton.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/07.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import UIKit

@IBDesignable
class IconableButton: UIButton {

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        return imageView
    }()
    
    @IBInspectable var iconImage: UIImage? = nil {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat =  0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
   override func prepareForInterfaceBuilder() {
       super.prepareForInterfaceBuilder()
       setup()
   }
    
    private func setup() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
}
