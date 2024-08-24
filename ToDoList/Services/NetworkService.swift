//
//  NetworkService.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchTasks() -> AnyPublisher<ServerTasks, TDError>
}

class NetworkService: NetworkServiceProtocol {
    
    private var baseURL = "https://dummyjson.com/"
    private var endpoint = "todos"
    
    public func fetchTasks() -> AnyPublisher<ServerTasks, TDError> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            DispatchQueue.global(qos: .background).async {
                guard let url = URL(string: self.baseURL + self.endpoint) else {
                    DispatchQueue.main.async {
                        promise(.failure(.somethingWentWrong))
                    }
                    return
                }
                
                let request = URLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil,
                          let response = response as? HTTPURLResponse, response.statusCode == 200,
                          let data else {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let tasks = try decoder.decode(ServerTasks.self, from: data)
                        
                        DispatchQueue.main.async {
                            promise(.success(tasks))
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(.somethingWentWrong))
                        }
                    }
                }
                
                task.resume()
            }
        }
        .eraseToAnyPublisher()
    }
    
}
