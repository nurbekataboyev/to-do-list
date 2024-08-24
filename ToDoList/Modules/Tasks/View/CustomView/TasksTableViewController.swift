//
//  TasksTableViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    enum Section: Hashable { case id(String) }
    private var dataSource: UITableViewDiffableDataSource<Section, Task>!
    
    public var tasks: [Task] = [] { didSet { updateData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDataSource()
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = true
        tableView.layer.masksToBounds = false
        tableView.addShadow()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.contentInset = .init(top: -20, left: 0, bottom: 100, right: 0)
        tableView.sectionHeaderHeight = 8
        tableView.sectionFooterHeight = 0
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Task>(
            tableView: tableView, cellProvider: { tableView, indexPath, task in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
                
                cell.configure(with: task)
                
                return cell
            })
    }
    
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        
        tasks.forEach {
            let section = Section.id($0.id ?? UUID().uuidString)
            snapshot.appendSections([section])
            snapshot.appendItems([$0], toSection: section)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
}
