//
//  UIView+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    
    public func addShadow(withOpacity opacity: Float = 0.125, radius: CGFloat = 2.5, color: CGColor = UIColor.black.cgColor) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color
        layer.shadowOffset = .zero
    }
    
}
