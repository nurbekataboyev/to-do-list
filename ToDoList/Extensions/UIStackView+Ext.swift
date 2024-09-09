//
//  UIStackView+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
