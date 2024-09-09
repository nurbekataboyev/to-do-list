//
//  TDButton.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

final class TDButton: UIButton {
    
    init(title: String? = nil, backgroundColor color: UIColor, textStyle style: UIFont.TextStyle = .headline) {
        super.init(frame: .zero)
        
        configureButton(title: title, backgroundColor: color, textStyle: style)
    }
    
    
    private func configureButton(title: String?, backgroundColor color: UIColor, textStyle style: UIFont.TextStyle) {
        setTitle(title, for: .normal)
        backgroundColor = color
        titleLabel?.font = .setFont(style: style, weight: .semibold)
        
        setTitleColor(.white, for: .normal)
        tintColor = .white
        titleLabel?.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = Constants.CornerRadius.medium
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
