//
//  TasksPresenterTests.swift
//  ToDoListTests
//
//  Created by Nurbek on 27/08/24.
//

import XCTest
@testable import ToDoList

final class TasksPresenterTests: XCTestCase {
    
    private var presenter: TasksPresenter!
    private var mockView: MockTasksView!
    private var mockInteractor: MockTasksInteractor!
    private var mockRouter: MockTasksRouter!
    
    override func setUpWithError() throws {
        super.setUp()
        
        mockView = MockTasksView()
        mockInteractor = MockTasksInteractor()
        mockRouter = MockTasksRouter()
        presenter = TasksPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    
    override func tearDownWithError() throws {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        
        super.tearDown()
    }
    
    
    func testViewDidLoadSuccess() {
        // act
        presenter.viewDidLoad()
        
        // assert
        XCTAssertTrue(mockView.displayLoadingScreenCalled, "Loading screen should be shown")
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "Interactor should fetch tasks")
    }
    
    
    func testCreateTaskSuccess() {
        // act
        presenter.createTask()
        
        // assert
        XCTAssertTrue(mockRouter.showTaskCalled, "Router should navigate to task creation screen")
        XCTAssertEqual(mockRouter.passedMode, .create, "Router should navigate to task creation mode")
    }
    
    
    func testShowDetailsSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        // act
        presenter.showDetails(for: task)
        
        // assert
        XCTAssertTrue(mockRouter.showTaskCalled, "Router should navigate to task detail screen")
        XCTAssertEqual(mockRouter.passedMode, .edit(task: task), "Router should navigate to task edit mode with correct task")
        XCTAssertEqual(mockRouter.passedTask, task, "Tasks should be equal")
    }
    
    
    func testUpdateStatusSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        // act
        presenter.updateStatus(for: task)
        
        // assert
        XCTAssertTrue(mockInteractor.updateTaskCalled, "Interactor should update the task status")
        XCTAssertEqual(mockInteractor.fetchedTask?.id, task.id, "Interactor should be called with the correct task")
    }
    
    
    func testDeleteTaskSuccess() {
        // arrange
        let task = TaskEntity(
            id: UUID().uuidString,
            title: "Test Title",
            description: "Test Description",
            completed: true,
            createdAt: Date())
        
        // act
        presenter.deleteTask(task)
        
        // assert
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "Interactor should delete the task")
        XCTAssertEqual(mockInteractor.fetchedTask, task, "Interactor should delete the task")
    }
    
    
    func testDidFetchTasksSuccess() {
        // arrange
        let tasks: [TaskEntity] = [
            TaskEntity(
                id: UUID().uuidString,
                title: "Test Title",
                description: "Test Description",
                completed: true,
                createdAt: Date()),
            TaskEntity(
                id: UUID().uuidString,
                title: "Test Title",
                description: "Test Description",
                completed: true,
                createdAt: Date())
        ]
        
        // act
        presenter.didFetch(tasks: tasks)
        
        // assert
        XCTAssertTrue(mockView.displayTasksCalled, "View should display tasks")
        XCTAssertEqual(mockView.tasks, tasks, "View should display the correct/fetched tasks")
        XCTAssertFalse(mockView.isLoading, "Loading screen should be dismissed after fetching tasks")
    }
    
    
    func testDidFailSuccess() {
        // arrange
        let error = TDError.somethingWentWrong
        
        // act
        presenter.didFail(with: error)
        
        // assert
        XCTAssertTrue(mockView.displayErrorCalled, "View should display error")
        XCTAssertEqual(mockView.error, error, "View should display the correct error message")
        XCTAssertFalse(mockView.isLoading, "Loading screen should be dismissed after an error")
    }
    
}


// MARK: - MOCKS FOR TASKS
class MockTasksView: TasksViewProtocol {
    
    public var displayTasksCalled: Bool = false
    public var displayErrorCalled: Bool = false
    public var displayLoadingScreenCalled: Bool = false
    public var tasks: [TaskEntity] = []
    public var error: TDError?
    public var isLoading: Bool = false
    
    public func displayTasks(_ tasks: [TaskEntity]) {
        displayTasksCalled = true
        self.tasks = tasks
    }
    
    
    public func displayError(_ error: TDError) {
        displayErrorCalled = true
        self.error = error
    }
    
    
    public func displayLoadingScreen(_ display: Bool) {
        displayLoadingScreenCalled = true
        isLoading = display
    }
    
}


class MockTasksInteractor: TasksInteractorInput {
    
    public var fetchTasksCalled: Bool = false
    public var updateTaskCalled: Bool = false
    public var deleteTaskCalled: Bool = false
    public var fetchedTask: TaskEntity?
    
    public func fetchTasks() {
        fetchTasksCalled = true
    }
    
    
    public func updateTask(_ task: TaskEntity) {
        updateTaskCalled = true
        fetchedTask = task
    }
    
    
    public func deleteTask(_ task: TaskEntity) {
        deleteTaskCalled = true
        fetchedTask = task
    }
    
}


class MockTasksRouter: TasksRouterProtocol {
    
    public var showTaskCalled: Bool = false
    public var passedMode: TaskViewMode?
    public var passedTask: TaskEntity?
    
    public func showTask(for mode: TaskViewMode, animated: Bool) {
        showTaskCalled = true
        passedMode = mode
        
        if case .edit(let task) = mode {
            passedTask = task
        }
    }
    
    
    static func configureModule() -> UIViewController {
        return UIViewController()
    }
    
}
