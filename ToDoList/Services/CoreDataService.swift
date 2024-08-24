//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation
import Combine
import CoreData

protocol CoreDataServiceProtocol {
    func saveContext() throws
    
    func fetchTasks() -> AnyPublisher<[Task], TDError>
    func saveTask(_ task: TaskModel) -> AnyPublisher<Void, TDError>
    func updateTask(_ task: Task) -> AnyPublisher<Void, TDError>
    func deleteTask(_ task: Task) -> AnyPublisher<Void, TDError>
}

class CoreDataService: CoreDataServiceProtocol {
    
    private let container: NSPersistentContainer
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        mainContext = container.viewContext
        backgroundContext = container.newBackgroundContext()
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
    
    
    public func fetchTasks() -> AnyPublisher<[Task], TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let fetchRequest = Task.fetchRequest()
                
                do {
                    let tasks = try self.backgroundContext.fetch(fetchRequest)
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
        .eraseToAnyPublisher()
    }
    
    
    public func saveTask(_ task: TaskModel) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                let taskContext = Task(context: self.backgroundContext)
                taskContext.id = task.id
                taskContext.title = task.title
                taskContext.message = task.message
                taskContext.createdAt = task.createdAt
                taskContext.completed = task.completed
                
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
        .eraseToAnyPublisher()
    }
    
    
    public func updateTask(_ task: Task) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
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
        .eraseToAnyPublisher()
    }
    
    
    public func deleteTask(_ task: Task) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            backgroundContext.perform {
                self.backgroundContext.delete(task)
                
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
        .eraseToAnyPublisher()
    }
    
}
