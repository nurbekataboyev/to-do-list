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
    case invalidURL = "We're having trouble connecting. Please try again."
    case invalidResponse = "We couldn't process your request. Please try again."
    case somethingWentWrong = "Oops, something went wrong. Please try again later."
}
