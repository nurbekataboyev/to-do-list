//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

protocol TaskViewProtocol: AnyObject {
    
}

class TaskViewController: UIViewController {
    
    public var presenter: TaskPresenterProtocol?
    
    private var viewMode: TaskViewMode
    
    init(viewMode: TaskViewMode) {
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = (viewMode == .create) ?
        "Новая задача"
        :
        "Редактировать"
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonHandler))
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonHandler))
        navigationItem.rightBarButtonItem = (viewMode == .create) ?
        saveButton
        :
        doneButton
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TaskViewController {
    
    @objc func saveButtonHandler() {
        
    }
    
    
    @objc func doneButtonHandler() {
        
    }
    
}


extension TaskViewController: TaskViewProtocol {
    
    
    
}
