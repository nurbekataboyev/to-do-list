//
//  TaskRouter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

protocol TaskRouterProtocol {
    static func configureModule(for mode: TaskViewMode, managementDelegate: TaskManagementDelegate?) -> UIViewController
    
    func close(animated: Bool)
}

class TaskRouter: TaskRouterProtocol {
    
    public weak var viewController: UIViewController?
    
    static func configureModule(for mode: TaskViewMode, managementDelegate: TaskManagementDelegate?) -> UIViewController {
        let view = TaskViewController()
        
        let coreDataService = CoreDataService()
        let interactor = TaskInteractor(coreDataService: coreDataService)
        
        let router = TaskRouter()
        
        let presenter = TaskPresenter(
            view: view,
            interactor: interactor,
            router: router,
            viewMode: mode,
            managementDelegate: managementDelegate)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    
    public func close(animated: Bool) {
        viewController?.dismiss(animated: animated)
    }
    
}
