//
//  UIViewController+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

extension UIViewController {
    
    public func presentAlert(withTitle title: String = "Something went wrong", message: String? = nil, actionTitle: String = "Okay", style: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: actionTitle, style: .default)
        alert.addAction(action)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            present(alert, animated: true)
        }
    }
    
}
