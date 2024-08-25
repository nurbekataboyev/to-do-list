//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol TaskInteractorInput {
    
}

protocol TaskInteractorOutput: AnyObject {
    
}

class TaskInteractor: TaskInteractorInput {
    
    public weak var output: TaskInteractorOutput?
    private let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
}
