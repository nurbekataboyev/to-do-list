//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

protocol TasksRouterProtocol {
    static func configureModule() -> UIViewController
}

class TasksRouter: TasksRouterProtocol {
    
    static func configureModule() -> UIViewController {
        let loadingScreenManager = LoadingScreenManager()
        let view = TasksViewController(loadingScreenManager: loadingScreenManager)
        
        let networkService = NetworkService()
        let coreDataService = CoreDataService()
        let userDefaultsService = UserDefaultsService()
        let interactor = TasksInteractor(
            networkService: networkService,
            coreDataService: coreDataService,
            userDefaultsService: userDefaultsService)
        
        let presenter = TasksPresenter(
            view: view,
            interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
    
}
