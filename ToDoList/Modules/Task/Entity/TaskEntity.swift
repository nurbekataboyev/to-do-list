//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

enum TaskViewMode: Equatable {
    case create
    case edit(task: Task)
}
