//
//  TaskPresenterTests.swift
//  ToDoListTests
//
//  Created by Nurbek on 27/08/24.
//

import XCTest
@testable import ToDoList

final class TaskPresenterTests: XCTestCase {
    
    private var presenter: TaskPresenter!
    private var viewMock: TaskViewMock!
    private var interactorMock: TaskInteractorMock!
    private var routerMock: TaskRouterMock!
    private var managementDelegateMock: TaskManagementDelegateMock!
    
    override func setUpWithError() throws {
        super.setUp()
        
        viewMock = TaskViewMock()
        interactorMock = TaskInteractorMock()
        routerMock = TaskRouterMock()
        managementDelegateMock = TaskManagementDelegateMock()
        
        presenter = TaskPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            viewMode: .create,
            managementDelegate: managementDelegateMock
        )
    }
    
    
    override func tearDownWithError() throws {
        presenter = nil
        viewMock = nil
        interactorMock = nil
        routerMock = nil
        managementDelegateMock = nil
        
        super.tearDown()
    }
    
    
    func testCreateTaskSuccess() {
        // arrange
        presenter = TaskPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            viewMode: .create,
            managementDelegate: managementDelegateMock
        )
        
        // act
        presenter.createTask()
        
        // assert
        XCTAssertTrue(interactorMock.didCreateTask, "Interactor should create the task")
        XCTAssertNotNil(interactorMock.createdTask, "Interactor should receive a non-nil task")
    }
    
    
    func testUpdateTaskSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        presenter = TaskPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            viewMode: .edit(task: task),
            managementDelegate: managementDelegateMock
        )
        
        // act
        presenter.updateTask()
        
        // assert
        XCTAssertTrue(interactorMock.didUpdateTask, "Interactor should update the task")
        XCTAssertNotNil(interactorMock.updatedTask, "Interactor should receive a non-nil task")
        XCTAssertEqual(interactorMock.updatedTask, task, "Interactor should receive the correct task to update")
    }
    
    
    func testUpdateTextForCreateModeSuccess() {
        // arrange
        presenter = TaskPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            viewMode: .create,
            managementDelegate: managementDelegateMock
        )
        
        let newTitle = "New Title"
        let newDescription = "New Description"
        
        // act
        presenter.updateText(to: newTitle, for: .title)
        presenter.updateText(to: newDescription, for: .description)
        presenter.createTask()
        
        // assert
        XCTAssertEqual(presenter.task?.title, newTitle, "Task titles should be equal")
        XCTAssertEqual(presenter.task?.description, newDescription, "Task descriptions should be equal")
    }
    
    
    func testUpdateTextForEditModeSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        presenter = TaskPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            viewMode: .edit(task: task),
            managementDelegate: managementDelegateMock
        )
        
        let newTitle = "New Title"
        let newDescription = "New Description"
        
        // act
        presenter.updateText(to: newTitle, for: .title)
        presenter.updateText(to: newDescription, for: .description)
        presenter.updateTask()
        
        // assert
        XCTAssertTrue(interactorMock.didUpdateTask, "Interactor should update the task")
        XCTAssertNotNil(interactorMock.updatedTask, "Interactor should receive a non-nil task")
        XCTAssertEqual(interactorMock.updatedTask?.title, newTitle, "Task titles should be equal")
        XCTAssertEqual(interactorMock.updatedTask?.description, newDescription, "Task descriptions should be equal")
    }
    
    
    func testCloseSuccess() {
        // act
        presenter.close()
        
        // assert
        XCTAssertTrue(routerMock.didClose, "Router should close")
    }
    
    
    func testDidCreateTaskSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        // act
        presenter.didCreate(task: task)
        
        // assert
        XCTAssertTrue(managementDelegateMock.didCreateTask, "Management delegate should be notified to create task")
        XCTAssertEqual(managementDelegateMock.receivedTask, task, "Management delegate should receive the correct created task")
        XCTAssertTrue(routerMock.didClose, "Router should close")
    }
    
    
    func testDidUpdateTaskSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "New Title",
            description: "New Description",
            completed: true,
            createdAt: Date())
        
        // act
        presenter.didUpdate(task: task)
        
        // assert
        XCTAssertTrue(managementDelegateMock.didUpdateTask, "Management delegate should be notified to update task")
        XCTAssertEqual(managementDelegateMock.receivedTask, task, "Management delegate should receive the correct updated task")
        XCTAssertTrue(routerMock.didClose, "Router should close")
    }
    
    
    func testDidFailSuccess() {
        // arrange
        let error = TDError.somethingWentWrong
        
        // act
        presenter.didFail(with: error)
        
        // assert
        XCTAssertTrue(viewMock.didDisplayError, "View should display error")
        XCTAssertEqual(viewMock.displayedError, error, "View should display the correct error message")
    }
    
}


// MARK: MOCKS FOR TASK
class TaskViewMock: TaskViewProtocol {
    
    public var didDisplayError: Bool = false
    public var displayedError: TDError?
    
    public func displayError(_ error: TDError) {
        didDisplayError = true
        displayedError = error
    }
    
}


class TaskInteractorMock: TaskInteractorInput {
    
    public var didCreateTask: Bool = false
    public var didUpdateTask: Bool = false
    public var createdTask: TaskEntity?
    public var updatedTask: TaskEntity?
    
    public func createTask(_ taskEntity: TaskEntity) {
        didCreateTask = true
        createdTask = taskEntity
    }
    
    
    public func updateTask(_ task: TaskEntity) {
        didUpdateTask = true
        updatedTask = task
    }
    
}


class TaskManagementDelegateMock: TaskManagementDelegate {
    
    public var didCreateTask: Bool = false
    public var didUpdateTask: Bool = false
    public var receivedTask: TaskEntity?
    
    public func didCreateTask(_ task: TaskEntity) {
        didCreateTask = true
        receivedTask = task
    }
    
    
    public func didUpdateTask(_ task: TaskEntity) {
        didUpdateTask = true
        receivedTask = task
    }
    
}


class TaskRouterMock: TaskRouterProtocol {
    
    public var didClose: Bool = false
    
    public func close(animated: Bool) {
        didClose = true
    }
    
    
    static func configureModule(for mode: TaskViewMode, managementDelegate: TaskManagementDelegate?) -> UIViewController {
        return UIViewController()
    }
    
}
