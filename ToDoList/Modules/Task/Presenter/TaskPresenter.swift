//
//  TaskPresenter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TaskPresenterProtocol {
    var viewMode: TaskViewMode { get set }
    
    func createTask()
    func updateTask()
    func updateText(to text: String, for type: TaskInputType)
    
    func close()
}

protocol TaskManagementDelegate: AnyObject {
    func didCreateTask(_ task: TaskEntity)
    func didUpdateTask(_ task: TaskEntity)
}

class TaskPresenter: TaskPresenterProtocol {
    
    public weak var view: TaskViewProtocol?
    private let interactor: TaskInteractorInput
    private let router: TaskRouterProtocol
    private weak var managementDelegate: TaskManagementDelegate?
    
    public var viewMode: TaskViewMode
    private(set) var task: TaskEntity?
    private(set) var newTask: TaskEntity?
    
    init(view: TaskViewProtocol,
         interactor: TaskInteractorInput,
         router: TaskRouterProtocol,
         viewMode: TaskViewMode,
         managementDelegate: TaskManagementDelegate?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.managementDelegate = managementDelegate
        
        self.viewMode = viewMode
        
        if case .edit(let task) = viewMode {
            self.task = task
        } else {
            newTask = TaskEntity(
                title: "",
                description: "",
                completed: false)
        }
    }
    
    
    public func createTask() {
        if let newTask {
            interactor.createTask(newTask)
        }
    }
    
    
    public func updateTask() {
        if let task {
            interactor.updateTask(task)
        }
    }
    
    
    public func updateText(to text: String, for type: TaskInputType) {
        let updatedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if viewMode == .create {
            type == .title ?
            (newTask?.title = updatedText)
            :
            (newTask?.description = updatedText)
        } else {
            type == .title ?
            (task?.title = updatedText)
            :
            (task?.description = updatedText)
        }
    }
    
    
    public func close() {
        router.close(animated: true)
    }
    
}


extension TaskPresenter: TaskInteractorOutput {
    
    func didCreate(task: TaskEntity) {
        managementDelegate?.didCreateTask(task)
        router.close(animated: true)
    }
    
    
    func didUpdate(task: TaskEntity) {
        managementDelegate?.didUpdateTask(task)
        router.close(animated: true)
    }
    
    
    func didFail(with error: TDError) {
        view?.displayError(error)
    }
    
}
