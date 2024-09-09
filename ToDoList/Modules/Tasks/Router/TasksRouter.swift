//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit

protocol TasksRouterProtocol {
    static func configureModule() -> UIViewController
    
    func showTask(for mode: TaskViewMode, animated: Bool)
}

final class TasksRouter: TasksRouterProtocol {
    
    private weak var viewController: UIViewController?
    
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
        
        let router = TasksRouter()
        
        let presenter = TasksPresenter(
            view: view,
            interactor: interactor,
            router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    
    public func showTask(for mode: TaskViewMode, animated: Bool) {
        let managementDelegate = (viewController as? TasksViewController)?.presenter
        let taskViewController = TaskRouter.configureModule(
            for: mode,
            managementDelegate: managementDelegate as? TaskManagementDelegate)
        
        viewController?.present(
            UINavigationController(rootViewController: taskViewController),
            animated: animated)
    }
    
}
