//
//  Task.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

struct TaskModel {
    var id: String
    var title: String
    var message: String
    var createdAt: Date
    var completed: Bool
}

struct ServerTasks: Codable {
    var tasks: [ServerTask]
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
    }
}

struct ServerTask: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}

extension ServerTask {
    
    public func toTaskModel() -> TaskModel {
        let taskModel = TaskModel(
            id: String(id),
            title: todo,
            message: "Default Message",
            createdAt: Date(),
            completed: completed)
        
        return taskModel
    }
    
}
