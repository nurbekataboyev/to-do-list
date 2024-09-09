//
//  Date+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import Foundation

extension Date {
    
    public func toCustomFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL d, HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
}
