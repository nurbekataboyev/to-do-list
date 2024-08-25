//
//  TaskPresenter.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TaskPresenterProtocol {
    
}

class TaskPresenter: TaskPresenterProtocol {
    
    public weak var view: TaskViewProtocol?
    private let interactor: TaskInteractorInput
    
    init(view: TaskViewProtocol,
         interactor: TaskInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
}


extension TaskPresenter: TaskInteractorOutput {
    
    
    
}
