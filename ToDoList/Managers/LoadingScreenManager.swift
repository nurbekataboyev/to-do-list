//
//  LoadingScreenManager.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

protocol LoadingScreenManagerProtocol {
    func showLoadingScreen(in viewController: UIViewController)
    func dismissLoadingScreen()
}

final class LoadingScreenManager: LoadingScreenManagerProtocol {
    
    private var containerView: UIView?
    
    public func showLoadingScreen(in viewController: UIViewController) {
        if containerView == nil {
            containerView = UIView(frame: viewController.view.bounds)
            guard let containerView else { return }
            
            containerView.backgroundColor = .systemBackground
            containerView.alpha = 0
            viewController.view.addSubview(containerView)
            
            UIView.animate(withDuration: 0.25) {
                containerView.alpha = 0.8
            }
            
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = .appPrimary
            activityIndicator.center = containerView.center
            containerView.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
        }
    }
    
    
    public func dismissLoadingScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
    
}
