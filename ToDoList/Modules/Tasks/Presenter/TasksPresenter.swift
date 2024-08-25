//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TasksPresenterProtocol {
    func viewDidLoad()
    
    func updateStatus(for task: Task)
    func deleteTask(_ task: Task)
    
    func createTask()
    func showDetails(for task: Task)
}

class TasksPresenter: TasksPresenterProtocol {
    
    public weak var view: TasksViewProtocol?
    private let interactor: TasksInteractorInput
    private let router: TasksRouterProtocol
    
    private var tasks: [Task] = []
    
    init(view: TasksViewProtocol,
         interactor: TasksInteractorInput,
         router: TasksRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    public func viewDidLoad() {
        view?.displayLoadingScreen(true)
        interactor.fetchTasks()
    }
    
    
    public func updateStatus(for task: Task) {
        task.completed.toggle()
        interactor.updateTask(task)
    }
    
    
    public func deleteTask(_ task: Task) {
        interactor.deleteTask(task)
    }
    
    
    public func createTask() {
        router.showTask(for: .create)
    }
    
    
    public func showDetails(for task: Task) {
        router.showTask(for: .edit(task: task))
    }
    
}


extension TasksPresenter: TasksInteractorOutput {
    
    func didFetch(tasks: [Task]) {
        self.tasks = tasks
        
        view?.displayTasks(tasks)
        view?.displayLoadingScreen(false)
    }
    
    
    func didUpdate(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        view?.displayTasks(tasks)
    }
    
    
    func didFail(with error: TDError) {
        view?.displayError(error)
        view?.displayLoadingScreen(false)
    }
    
}
