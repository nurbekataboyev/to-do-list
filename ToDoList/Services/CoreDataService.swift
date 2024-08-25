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
    private let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        context = container.viewContext
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
    
    
    public func fetchTasks() -> AnyPublisher<[Task], TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let fetchRequest = Task.fetchRequest()
                    
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
    
    
    public func saveTask(_ task: TaskModel) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
                    let taskContext = Task(context: self.context)
                    taskContext.id = task.id
                    taskContext.title = task.title
                    taskContext.description_ = task.description
                    taskContext.completed = task.completed
                    taskContext.createdAt = task.createdAt
                    
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
    
    
    public func updateTask(_ task: Task) -> AnyPublisher<Void, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                self.context.perform {
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
    
    
    public func deleteTask(_ task: Task) -> AnyPublisher<Void, TDError> {
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
