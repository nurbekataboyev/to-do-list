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
    
    func fetchTasks() -> AnyPublisher<[TaskEntity], TDError>
    func saveTask(_ task: TaskEntity) -> AnyPublisher<TaskEntity, TDError>
    func updateTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError>
    func deleteTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError>
}

class CoreDataService: CoreDataServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
    }
    
    
    public func saveContext() throws {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                throw TDError.somethingWentWrong
            }
        }
    }
    
    
    public func fetchTasks() -> AnyPublisher<[TaskEntity], TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let fetchRequest = TaskModel.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                do {
                    let tasks = try self.backgroundContext.fetch(fetchRequest)
                    let taskEntities = tasks.map { $0.toTaskEntity() }
                    
                    promise(.success(taskEntities))
                    
                } catch {
                    promise(.failure(.somethingWentWrong))
                }
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    public func saveTask(_ taskEntity: TaskEntity) -> AnyPublisher<TaskEntity, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let task = TaskModel(context: self.backgroundContext)
                task.id = taskEntity.id
                task.title = taskEntity.title
                task.description_ = taskEntity.description
                task.completed = taskEntity.completed
                task.createdAt = Date()
                
                do {
                    try self.saveContext()
                    promise(.success((task.toTaskEntity())))
                } catch {
                    promise(.failure(.somethingWentWrong))
                }
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    public func updateTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)
                fetchRequest.fetchLimit = 1
                
                do {
                    guard let existingTask = try self.backgroundContext.fetch(fetchRequest).first else {
                        promise(.failure(.somethingWentWrong))
                        return
                    }
                    
                    existingTask.title = task.title
                    existingTask.description_ = task.description
                    existingTask.completed = task.completed
                    
                    try self.saveContext()
                    promise(.success(()))
                    
                } catch {
                    promise(.failure(.somethingWentWrong))
                }
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    public func deleteTask(_ task: TaskEntity) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", task.id ?? "" as CVarArg)
                fetchRequest.fetchLimit = 1
                
                do {
                    guard let existingTask = try self.backgroundContext.fetch(fetchRequest).first else {
                        promise(.failure(.somethingWentWrong))
                        return
                    }
                    
                    self.backgroundContext.delete(existingTask)
                    try self.saveContext()
                    
                    promise(.success(()))
                    
                } catch {
                    promise(.failure(.somethingWentWrong))
                }
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
