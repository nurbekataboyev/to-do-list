//
//  CoreDataServiceTests.swift
//  ToDoListTests
//
//  Created by Nurbek on 26/08/24.
//

import XCTest
import Combine
import CoreData
@testable import ToDoList

final class CoreDataServiceTests: XCTestCase {
    
    private var persistentContainer: NSPersistentContainer!
    private var coreDataService: CoreDataServiceProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        super.setUp()
        
        persistentContainer = NSPersistentContainer(name: "ToDoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error {
                XCTFail("Failed to load in-memory store: \(error.localizedDescription)")
            }
        }
        
        coreDataService = CoreDataService(persistentContainer: persistentContainer)
        cancellables = []
    }
    
    
    override func tearDownWithError() throws {
        persistentContainer = nil
        coreDataService = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    
    func testFetchTasksSuccess() {
        // arrange
        let expectedTasks: [TaskEntity] = [
            TaskEntity(title: "Test Title", description: "Test Description", completed: true),
            TaskEntity(title: "Test Title", description: "Test Description", completed: false),
            TaskEntity(title: "Test Title", description: "Test Description", completed: true)
        ]
        
        let expectation = expectation(description: "Fetch tasks successfully")
        let dispatchGroup = DispatchGroup()
        
        // act
        expectedTasks.forEach {
            dispatchGroup.enter()
            
            coreDataService.saveTask($0)
                .sink { completion in
                    
                    switch completion {
                    case .finished:
                        dispatchGroup.leave()
                    case .failure(let error):
                        XCTFail("Fetch tasks failed with error: \(error.rawValue)")
                    }
                    
                } receiveValue: { _ in }
                .store(in: &cancellables)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) { [weak self] in
            guard let self else { return }
            
            coreDataService.fetchTasks()
                .sink { completion in
                    
                    if case .failure(let error) = completion {
                        XCTFail(error.rawValue)
                    }
                    
                } receiveValue: { fetchedTasks in
                    
                    // assert
                    XCTAssertEqual(fetchedTasks.count, expectedTasks.count, "Tasks count should be equal")
                    XCTAssertEqual(fetchedTasks.first?.title, expectedTasks.first?.title, "Task titles should be equal")
                    XCTAssertEqual(fetchedTasks.first?.description, expectedTasks.first?.description, "Task descriptions should be equal")
                    
                    expectation.fulfill()
                    
                }
                .store(in: &cancellables)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    
    func testSaveTaskSuccess() {
        // arrange
        let taskToSave: TaskEntity = TaskEntity(
            title: "Test Title",
            description: "Test Description",
            completed: false)
        
        let expectation = expectation(description: "Save task successfully")
        
        // act
        coreDataService.saveTask(taskToSave)
            .sink { completion in
                
                if case .failure(let error) = completion {
                    XCTFail("Fetch tasks failed with error: \(error.rawValue)")
                }
                
            } receiveValue: { savedTask in
                
                // assert
                XCTAssertEqual(savedTask.title, taskToSave.title, "Titles should be equal")
                XCTAssertEqual(savedTask.description, taskToSave.description, "Descriptions should be equal")
                
                expectation.fulfill()
                
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    
    func testUpdateTaskSuccess() {
        // arrange
        let taskToSave: TaskEntity = TaskEntity(
            title: "Test Title",
            description: "Test Description",
            completed: true)
        
        let expectation = expectation(description: "Update task successfully")
        
        // act
        coreDataService.saveTask(taskToSave)
            .sink { completion in
                
                if case .failure(let error) = completion {
                    XCTFail("Update task failed with error: \(error.rawValue)")
                }
                
            } receiveValue: { [weak self] savedTask in
                guard let self else { return }
                
                var taskToUpdate = savedTask
                taskToUpdate.title = "Test Title Updated"
                taskToUpdate.description = "Test Description Updated"
                
                coreDataService.updateTask(taskToUpdate)
                    .sink { [weak self] completion in
                        guard let self else { return }
                        
                        switch completion {
                        case .finished:
                            
                            coreDataService.fetchTask(taskToUpdate)
                                .sink { completion in
                                    
                                    if case .failure(let error) = completion {
                                        XCTFail(error.rawValue)
                                    }
                                    
                                } receiveValue: { updatedTask in
                                    
                                    // assert
                                    XCTAssertEqual(updatedTask, taskToUpdate, "Tasks should be equal")
                                    expectation.fulfill()
                                    
                                }
                                .store(in: &cancellables)
                            
                        case .failure(let error):
                            XCTFail(error.rawValue)
                        }
                        
                    } receiveValue: { _ in }
                    .store(in: &cancellables)
                
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    
    func testDeleteTaskSuccess() {
        // arrange
        let taskToSave: TaskEntity = TaskEntity(
            title: "Test Title",
            description: "Test Description",
            completed: true)
        
        let expectation = expectation(description: "Delete task successfully")
        
        // act
        coreDataService.saveTask(taskToSave)
            .sink { completion in
                
                if case .failure(let error) = completion {
                    XCTFail("Delete task failed with error: \(error.rawValue)")
                }
                
            } receiveValue: { [weak self] savedTask in
                guard let self else { return }
                
                coreDataService.deleteTask(savedTask)
                    .sink { [weak self] completion in
                        guard let self else { return }
                        
                        switch completion {
                        case .finished:
                            
                            coreDataService.fetchTask(savedTask)
                                .sink { completion in
                                    
                                    if case .failure(let error) = completion {
                                        XCTFail(error.rawValue)
                                    }
                                    
                                } receiveValue: { deletedTask in
                                    
                                    // assert
                                    XCTAssertNil(deletedTask, "Deleted task should be nil")
                                    expectation.fulfill()
                                    
                                }
                                .store(in: &cancellables)
                            
                        case .failure(let error):
                            XCTFail(error.rawValue)
                        }
                        
                    } receiveValue: { _ in }
                    .store(in: &cancellables)
                
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
}
