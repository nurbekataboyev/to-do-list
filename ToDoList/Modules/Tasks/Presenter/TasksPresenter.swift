//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TasksPresenterProtocol {
    func viewDidLoad()
    
    func updateStatus(for task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
    
    func createTask()
    func showDetails(for task: TaskEntity)
}

final class TasksPresenter: TasksPresenterProtocol {
    
    public weak var view: TasksViewProtocol?
    private let interactor: TasksInteractorInput
    private let router: TasksRouterProtocol
    
    private var tasks: [TaskEntity] = []
    
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
    
    
    public func updateStatus(for task: TaskEntity) {
        interactor.updateTask(task)
    }
    
    
    public func deleteTask(_ task: TaskEntity) {
        interactor.deleteTask(task)
    }
    
    
    public func createTask() {
        router.showTask(for: .create, animated: true)
    }
    
    
    public func showDetails(for task: TaskEntity) {
        router.showTask(for: .edit(task: task), animated: true)
    }
    
}


extension TasksPresenter {
    
    private func handleCreatedTask(_ task: TaskEntity) {
        tasks.insert(task, at: 0)
        view?.displayTasks(tasks)
    }
    
    
    private func handleUpdatedTask(_ task: TaskEntity) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        
        view?.displayTasks(tasks)
    }
    
    
    private func handleDeletedTask(_ task: TaskEntity) {
        tasks.removeAll(where: { $0.id == task.id })
        view?.displayTasks(tasks)
    }
    
}


extension TasksPresenter: TaskManagementDelegate {
    
    func didCreateTask(_ task: TaskEntity) {
        handleCreatedTask(task)
    }
    
    
    func didUpdateTask(_ task: TaskEntity) {
        handleUpdatedTask(task)
    }
    
}


extension TasksPresenter: TasksInteractorOutput {
    
    func didFetch(tasks: [TaskEntity]) {
        self.tasks = tasks
        
        view?.displayTasks(tasks)
        view?.displayLoadingScreen(false)
    }
    
    
    func didUpdate(task: TaskEntity) {
        handleUpdatedTask(task)
    }
    
    
    func didDelete(task: TaskEntity) {
        handleDeletedTask(task)
    }
    
    
    func didFail(with error: TDError) {
        // when error happens it updates the view with existing tasks, all ui changes are back to old state
        view?.displayTasks(tasks)
        
        view?.displayError(error)
        view?.displayLoadingScreen(false)
    }
    
}
