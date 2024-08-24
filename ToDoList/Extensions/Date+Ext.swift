//
//  Date+Ext.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import Foundation

extension Date {
    
    func toCustomFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL d, HH:mm"
        
        return dateFormatter.string(from: self).capitalized
    }
    
}
