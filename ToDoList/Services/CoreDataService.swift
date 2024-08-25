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
    func saveTask(_ task: TaskEntity) -> AnyPublisher<TaskEntity, TDError>
    func updateTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError>
    func deleteTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError>
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
    
    
    public func saveTask(_ taskEntity: TaskEntity) -> AnyPublisher<TaskEntity, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let task = TaskModel(context: self.context)
                    task.id = taskEntity.id
                    task.title = taskEntity.title
                    task.description_ = taskEntity.description
                    task.completed = taskEntity.completed
                    task.createdAt = Date()
                    
                    do {
                        try self.saveContext()
                        DispatchQueue.main.async {
                            promise(.success((task.toTaskEntity())))
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
    
    
    public func updateTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        guard let existingTask = try self.context.fetch(fetchRequest).first else {
                            DispatchQueue.main.async {
                                promise(.failure(.somethingWentWrong))
                            }
                            return
                        }
                        
                        existingTask.title = task.title
                        existingTask.description_ = task.description
                        existingTask.completed = task.completed
                        
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
    
    
    public func deleteTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        guard let existingTask = try self.context.fetch(fetchRequest).first else {
                            DispatchQueue.main.async {
                                promise(.failure(.somethingWentWrong))
                            }
                            return
                        }
                        
                        self.context.delete(existingTask)
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
