//
//  Constants.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

struct Constants {
    
    struct Screen {
        static let width: CGFloat = UIScreen.main.bounds.width
        static let height: CGFloat = UIScreen.main.bounds.height
    }
    
    
    struct Padding {
        static let tiny: CGFloat = 5
        static let small: CGFloat = 8
        static let medium: CGFloat = 18
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 25
    }
    
    
    struct CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 15
    }
    
}

enum UserDefaultsKeys: String {
    case hasFetchedData
}


enum TDError: String, Error {
    case somethingWentWrong = "Couldn't complete your request. Please try again later!"
}
