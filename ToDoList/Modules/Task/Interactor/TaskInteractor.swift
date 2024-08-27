//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation
import Combine

protocol TaskInteractorInput {
    func createTask(_ task: TaskEntity)
    func updateTask(_ task: TaskEntity)
}

protocol TaskInteractorOutput: AnyObject {
    func didCreate(task: TaskEntity)
    func didUpdate(task: TaskEntity)
    
    func didFail(with error: TDError)
}

class TaskInteractor: TaskInteractorInput {
    
    public weak var output: TaskInteractorOutput?
    private let coreDataService: CoreDataServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    
    public func createTask(_ task: TaskEntity) {
        coreDataService.saveTask(task)
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.output?.didFail(with: error)
                    }
                }
                
            } receiveValue: { [weak self] task in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.output?.didCreate(task: task)
                }
            }
            .store(in: &cancellables)
    }
    
    
    public func updateTask(_ task: TaskEntity) {
        coreDataService.updateTask(task)
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self.output?.didUpdate(task: task)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.output?.didFail(with: error)
                    }
                }
                
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
}
