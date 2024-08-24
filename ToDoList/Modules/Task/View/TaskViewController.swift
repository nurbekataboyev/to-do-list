//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

class TaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "Тест"
    }
    
}
