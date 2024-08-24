//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit
import SnapKit

protocol TasksViewProtocol: AnyObject {
    func displayTasks(_ tasks: [Task])
    func displayError(_ error: TDError)
    
    func displayLoadingScreen(_ display: Bool)
}

class TasksViewController: UIViewController {
    
    public var presenter: TasksPresenterProtocol?
    
    private var tableViewController = TasksTableViewController()
    private var loadingScreenManager: LoadingScreenManagerProtocol
    
    init(loadingScreenManager: LoadingScreenManagerProtocol) {
        self.loadingScreenManager = loadingScreenManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        layout()
        
        presenter?.viewDidLoad()
    }
    
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "Список Задач"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableViewController.tableView)
    }
    
    
    private func layout() {
        tableViewController.tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TasksViewController: TasksViewProtocol {
    
    func displayTasks(_ tasks: [Task]) {
        tableViewController.tasks = tasks
    }
    
    
    func displayError(_ error: TDError) {
        presentAlert(message: error.rawValue)
    }
    
    
    func displayLoadingScreen(_ display: Bool) {
        display ?
        loadingScreenManager.showLoadingScreen(in: self)
        :
        loadingScreenManager.dismissLoadingScreen()
    }
    
}
