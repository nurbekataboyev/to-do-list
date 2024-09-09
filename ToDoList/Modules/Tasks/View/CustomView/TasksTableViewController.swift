//
//  TasksTableViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit

protocol TasksTableViewDelegate: AnyObject {
    func editTask(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
    func updateStatus(_ task: TaskEntity)
}

final class TasksTableViewController: UITableViewController {
    
    public weak var delegate: TasksTableViewDelegate?
    
    enum Section: Hashable { case tasks }
    private var dataSource: UITableViewDiffableDataSource<Section, TaskEntity>!
    
    public var tasks: [TaskEntity] = [] {
        didSet {
            let countHasChanged = oldValue.count != tasks.count
            updateData(animation: countHasChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDataSource()
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = true
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.separatorColor = .systemGray
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, TaskEntity>(
            tableView: tableView, cellProvider: { tableView, indexPath, task in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
                
                cell.configure(with: task)
                cell.delegate = self
                
                return cell
            })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    
    private func updateData(animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TaskEntity>()
        snapshot.appendSections([.tasks])
        snapshot.appendItems(tasks, toSection: .tasks)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            dataSource.apply(snapshot, animatingDifferences: animation)
        }
    }
    
}


extension TasksTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        delegate?.editTask(task)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = tasks[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { [weak self] _, _, _ in
            guard let self else { return }
            delegate?.editTask(task)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            guard let self else { return }
            
            tasks.removeAll(where: { $0.id == task.id })
            delegate?.deleteTask(task)
        }
        
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}


extension TasksTableViewController: TaskCellDelegate {
    
    func updateStatus(for task: TaskEntity) {
        delegate?.updateStatus(task)
    }
    
}
