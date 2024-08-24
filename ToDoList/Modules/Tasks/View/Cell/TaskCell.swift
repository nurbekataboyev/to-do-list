//
//  TaskCell.swift
//  ToDoList
//
//  Created by Nurbek on 24/08/24.
//

import UIKit
import SnapKit

class TaskCell: UITableViewCell {
    
    private var textsStackView = UIStackView()
    private var titleLabel = TDLabel(style: .headline, weight: .semibold)
    private var messageLabel = TDLabel(style: .subheadline, weight: .medium, color: .secondaryLabel)
    private var dateLabel = TDLabel(style: .footnote, color: .secondaryLabel)
    private var statusButton = TDButton(backgroundColor: .clear)
    
    public func configure(with task: Task) {
        titleLabel.text = task.title
        messageLabel.text = task.message
        dateLabel.text = task.createdAt?.toCustomFormat()
        
        layout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
    }
    
    
    private func configureViews() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        
        addSubviews(textsStackView, statusButton)
        textsStackView.addArrangedSubview(titleLabel)
        textsStackView.addArrangedSubview(messageLabel)
        textsStackView.addArrangedSubview(dateLabel)
        
        textsStackView.axis = .vertical
        textsStackView.spacing = 8
        
        titleLabel.numberOfLines = .max
        
        messageLabel.numberOfLines = 2
        
        statusButton.layer.cornerRadius = Constants.CornerRadius.small
        statusButton.layer.borderColor = UIColor.systemGray3.cgColor
        statusButton.layer.borderWidth = 1.5
    }
    
    
    private func layout() {
        textsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Padding.medium)
            $0.leading.equalToSuperview().offset(Constants.Padding.large)
            $0.trailing.equalTo(statusButton.snp.leading).offset(-Constants.Padding.medium)
            $0.bottom.equalToSuperview().offset(-Constants.Padding.medium)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(textsStackView.snp.leading)
            $0.trailing.equalTo(textsStackView.snp.trailing)
        }
        
        statusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
            $0.size.equalTo(35)
        }
    }
    
    
    override class var layerClass: AnyClass {
        InsetsGroupedLayer.self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
