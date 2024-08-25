//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit
import Combine
import CoreData

protocol CoreDataServiceProtocol {
    func saveContext() throws
    
    func fetchTasks() -> AnyPublisher<[TaskModel], TDError>
    func saveTask(_ task: TaskEntity) -> AnyPublisher<TaskModel, TDError>
    func updateTask(_ task: TaskModel) -> AnyPublisher<Void, TDError>
    func deleteTask(_ task: TaskModel) -> AnyPublisher<Void, TDError>
}

class CoreDataService: CoreDataServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    public func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw TDError.somethingWentWrong
            }
        }
    }
    
    
    public func fetchTasks() -> AnyPublisher<[TaskModel], TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let fetchRequest = TaskModel.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    
                    do {
                        let tasks = try self.context.fetch(fetchRequest)
                        DispatchQueue.main.async {
                            promise(.success(tasks))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                    }
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    public func saveTask(_ taskEntity: TaskEntity) -> AnyPublisher<TaskModel, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let task = TaskModel(context: self.context)
                    task.id = taskEntity.id
                    task.title = taskEntity.title
                    task.description_ = taskEntity.description
                    task.completed = taskEntity.completed
                    task.createdAt = taskEntity.createdAt
                    
                    do {
                        try self.saveContext()
                        DispatchQueue.main.async {
                            promise(.success((task)))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                    }
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    public func updateTask(_ task: TaskModel) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    guard let existingTask = self.context.object(with: task.objectID) as? TaskModel else {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                        return
                    }
                    
                    existingTask.title = task.title
                    existingTask.description_ = task.description_
                    existingTask.completed = task.completed
                    
                    do {
                        try self.saveContext()
                        DispatchQueue.main.async {
                            promise(.success(()))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                    }
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    public func deleteTask(_ task: TaskModel) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    self.context.delete(task)
                    
                    do {
                        try self.saveContext()
                        DispatchQueue.main.async {
                            promise(.success(()))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                    }
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
}
