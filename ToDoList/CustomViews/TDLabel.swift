//
//  TDLabel.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

class TDLabel: UILabel {
    
    init(alignment: NSTextAlignment = .left, style: UIFont.TextStyle, weight: UIFont.Weight = .regular, color: UIColor = .label) {
        super.init(frame: .zero)
        
        configureLabel(alignment: alignment, style: style, weight: weight, color: color)
    }
    
    
    private func configureLabel(alignment: NSTextAlignment, style: UIFont.TextStyle, weight: UIFont.Weight, color: UIColor) {
        textAlignment = alignment
        font = .setFont(style: style, weight: weight)
        textColor = color
        
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
