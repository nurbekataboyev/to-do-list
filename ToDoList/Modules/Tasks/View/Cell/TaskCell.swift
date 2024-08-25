//
//  TaskCell.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit
import SnapKit

protocol TaskCellDelegate: AnyObject {
    func updateStatus(for task: TaskModel)
}

class TaskCell: UITableViewCell {
    
    public weak var delegate: TaskCellDelegate?
    
    private var task: TaskModel?
    
    private var textsStackView = UIStackView()
    private var titleLabel = TDLabel(style: .headline, weight: .semibold)
    private var descriptionLabel = TDLabel(style: .subheadline, weight: .medium, color: .secondaryLabel)
    private var dateLabel = TDLabel(style: .footnote, color: .secondaryLabel)
    private var statusContainerView = UIView()
    private var statusButton = TDButton(backgroundColor: .clear)
    
    public func configure(with task: TaskModel) {
        self.task = task
        
        titleLabel.text = task.title
        descriptionLabel.text = task.description_
        dateLabel.text = task.createdAt?.toCustomFormat()
        updateStatusButton(isCompleted: task.completed)
        
        layout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        updateStatusButton(isCompleted: false)
    }
    
    
    private func configureViews() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        contentView.addSubviews(textsStackView, statusContainerView)
        textsStackView.addArrangedSubview(titleLabel)
        textsStackView.addArrangedSubview(descriptionLabel)
        textsStackView.addArrangedSubview(dateLabel)
        statusContainerView.addSubview(statusButton)
        
        textsStackView.axis = .vertical
        textsStackView.spacing = 8
        
        titleLabel.numberOfLines = .max
        
        descriptionLabel.numberOfLines = .max
        
        let statusGesture = UITapGestureRecognizer(target: self, action: #selector(statusButtonHandler))
        statusContainerView.addGestureRecognizer(statusGesture)
        
        statusButton.layer.cornerRadius = Constants.CornerRadius.small
        statusButton.layer.borderColor = UIColor.systemGray3.cgColor
        statusButton.addTarget(self, action: #selector(statusButtonHandler), for: .touchUpInside)
    }
    
    
    private func layout() {
        textsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Padding.medium)
            $0.leading.equalToSuperview().offset(Constants.Padding.large)
            $0.trailing.equalTo(statusContainerView.snp.leading)
            $0.bottom.equalToSuperview().offset(-Constants.Padding.medium)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        statusContainerView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(85) // 35 button width, 50 for leading and trailing space
        }
        
        statusButton.snp.makeConstraints {
            $0.center.equalTo(statusContainerView.snp.center)
            $0.size.equalTo(35)
        }
    }
    
    
    private func updateStatusButton(isCompleted completed: Bool) {
        statusButton.backgroundColor = completed ? .appPrimary : .clear
        statusButton.layer.borderWidth = completed ? 0 : 1.5
        
        let image = completed ?
        UIImage(systemName: "checkmark")
        :
        nil
        statusButton.setImage(image, for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TaskCell {
    
    @objc func statusButtonHandler() {
        if let task {
            makeVibration()
            updateStatusButton(isCompleted: !task.completed)
            delegate?.updateStatus(for: task)
        }
    }
    
}
