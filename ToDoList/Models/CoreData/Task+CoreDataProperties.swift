//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var message: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completed: Bool

}

extension Task : Identifiable {

}
