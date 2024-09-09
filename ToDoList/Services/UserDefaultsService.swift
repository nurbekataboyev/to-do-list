//
//  UserDefaultsService.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func setFetchStatus(_ hasFetchedData: Bool)
    func getFetchStatus() -> Bool
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    
    private let defaults = UserDefaults.standard
    private let key = UserDefaultsKeys.hasFetchedData.rawValue
    
    public func setFetchStatus(_ hasFetchedData: Bool) {
        defaults.setValue(hasFetchedData, forKey: key)
    }
    
    
    public func getFetchStatus() -> Bool {
        let hasFetchedData = defaults.bool(forKey: key)
        return hasFetchedData
    }
    
}
