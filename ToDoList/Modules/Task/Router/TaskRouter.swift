//
//  TaskRouter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

protocol TaskRouterProtocol {
    static func configureModule(for mode: TaskViewMode) -> UIViewController
}

class TaskRouter: TaskRouterProtocol {
    
    static func configureModule(for mode: TaskViewMode) -> UIViewController {
        let view = TaskViewController(viewMode: mode)
        
        let coreDataService = CoreDataService()
        let interactor = TaskInteractor(coreDataService: coreDataService)
        
        let presenter = TaskPresenter(
            view: view,
            interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
    
}
