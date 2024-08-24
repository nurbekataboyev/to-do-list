//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TasksPresenterProtocol {
    func viewDidLoad()
}

class TasksPresenter: TasksPresenterProtocol {
    
    public weak var view: TasksViewProtocol?
    private let interactor: TasksInteractorInput
    
    init(view: TasksViewProtocol,
         interactor: TasksInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        view?.displayLoadingScreen(true)
        interactor.fetchTasks()
    }
    
}


extension TasksPresenter: TasksInteractorOutput {
    
    func didFetch(tasks: [Task]) {
        view?.displayTasks(tasks)
        view?.displayLoadingScreen(false)
    }
    
    
    func didFail(with error: TDError) {
        view?.displayError(error)
        view?.displayLoadingScreen(false)
    }
    
}
