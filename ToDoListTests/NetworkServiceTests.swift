//
//  NetworkServiceTests.swift
//  ToDoListTests
//
//  Created by Nurbek on 26/08/24.
//

import XCTest
import Combine
@testable import ToDoList

final class NetworkServiceTests: XCTestCase {
    
    private var networkService: NetworkServiceProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        super.setUp()
        
        networkService = NetworkService()
        cancellables = []
    }
    
    
    override func tearDownWithError() throws {
        networkService = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    
    func testFetchTasksSuccess() {
        let expectation = expectation(description: "Fetch tasks successfully")
        
        // act
        networkService.fetchTasks()
            .sink { completion in
                
                if case .failure(let error) = completion {
                    XCTFail("Fetch tasks failed with error: \(error.rawValue)")
                }
                
            } receiveValue: { serverTasks in
                
                // assert
                XCTAssertNotNil(serverTasks, "Server tasks should not be nill")
                XCTAssertFalse(serverTasks.tasks.isEmpty, "Server tasks should not be empty")
                
                expectation.fulfill()
                
            }
            .store(in: &cancellables)
        
        // fails when internet is slow or no internet because fetch is not completed
        // as timeout is 50 seconds
        waitForExpectations(timeout: 50)
    }
    
}
