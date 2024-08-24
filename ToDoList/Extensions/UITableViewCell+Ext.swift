//
//  UITableViewCell+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    
    final class InsetsGroupedLayer: CALayer {
        override var cornerRadius: CGFloat {
            get { Constants.CornerRadius.medium }
            set {}
        }
    }
    
}