//
//  Task.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

public struct TaskEntity: Hashable {
    var id: String?
    var title: String?
    var description: String?
    var completed: Bool
    var createdAt: Date?
}

struct ServerTasks: Codable, Equatable {
    var tasks: [ServerTask]
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
    }
}

struct ServerTask: Codable, Equatable {
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
    
    public func toTaskEntity() -> TaskEntity {
        let taskModel = TaskEntity(
            id: String(id),
            title: todo,
            description: "Default Description Message",
            completed: completed,
            createdAt: Date())
        
        return taskModel
    }
    
}
