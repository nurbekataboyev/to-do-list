//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit
import SnapKit

protocol TaskViewProtocol: AnyObject {
    func displayError(_ error: TDError)
}

final class TaskViewController: UIViewController {
    
    public var presenter: TaskPresenterProtocol?
    
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    private var titleView = TaskInputView(type: .title)
    private var descriptionView = TaskInputView(type: .description)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        layout()
    }
    
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = (presenter?.viewMode == .create) ?
        "Add Task"
        :
        "Edit Task"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonHandler))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonHandler))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandler))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = (presenter?.viewMode == .create) ?
        saveButton
        :
        doneButton
        
        let keyboardDismissGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(keyboardDismissGesture)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(descriptionView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.layoutMargins = .init(top: 25, left: 25, bottom: 0, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        titleView.delegate = self
        descriptionView.delegate = self
        
        if case .edit(let task) = presenter?.viewMode {
            titleView.task = task
            descriptionView.task = task
        }
    }
    
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.snp.edges)
            $0.width.equalTo(scrollView.snp.width)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TaskViewController {
    
    @objc func cancelButtonHandler() {
        presenter?.close()
    }
    
    
    @objc func saveButtonHandler() {
        presenter?.createTask()
    }
    
    
    @objc func doneButtonHandler() {
        presenter?.updateTask()
    }
    
}


extension TaskViewController: TaskInputDelegate {
    
    func textDidChange(to text: String, for type: TaskInputType) {
        presenter?.updateText(to: text, for: type)
    }
    
}


extension TaskViewController: TaskViewProtocol {
    
    func displayError(_ error: TDError) {
        presentAlert(message: error.rawValue)
    }
    
}
