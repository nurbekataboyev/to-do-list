//
//  UIStackView+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
