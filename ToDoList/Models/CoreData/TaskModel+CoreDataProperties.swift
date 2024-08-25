//
//  TaskModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Nurbek on 26/08/24.
//
//

import Foundation
import CoreData

@objc(TaskModel)
public class TaskModel: NSManagedObject {

}

extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var description_: String?
    @NSManaged public var title: String?

}

extension TaskModel : Identifiable {

}
