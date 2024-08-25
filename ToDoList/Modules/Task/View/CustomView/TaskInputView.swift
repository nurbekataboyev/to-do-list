//
//  TaskInputView.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit
import SnapKit

protocol TaskInputDelegate: AnyObject {
    func textDidChange(to text: String, for type: TaskInputType)
}

class TaskInputView: UIView {
    
    public weak var delegate: TaskInputDelegate?
    
    private var type: TaskInputType
    public var task: TaskModel? { didSet { updateText() } }
    
    private var titleLabel = TDLabel(alignment: .center, style: .title3, weight: .semibold)
    private var textContainerView = UIView()
    private var textView: TDTextView
    
    init(type: TaskInputType) {
        self.type = type
        
        let placeholder = (type == .title) ?
        "Напишите здесь название..."
        :
        "Напишите здесь описание..."
        
        let style = (type == .title) ?
        UIFont.TextStyle.headline
        :
        UIFont.TextStyle.callout
        
        textView = TDTextView(placeholder: placeholder, style: style)
        
        super.init(frame: .zero)
        
        configureViews()
        layout()
    }
    
    
    private func configureViews() {
        addSubviews(titleLabel, textContainerView)
        textContainerView.addSubview(textView)
        
        let title = (type == .title) ?
        "Название"
        :
        "Описание"
        titleLabel.text = title
        
        textContainerView.addShadow()
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonHandler))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        textView.delegate = self
    }
    
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        textContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalTo(textContainerView.snp.edges)
        }
    }
    
    
    private func updateText() {
        let text = (type == .title) ?
        task?.title
        :
        task?.description_
        textView.text = text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TaskInputView {
    
    @objc func doneButtonHandler() {
        textView.resignFirstResponder()
    }
    
}


extension TaskInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let editedText = textView.text ?? ""
        delegate?.textDidChange(to: editedText, for: type)
    }
    
}