//
//  TDTextView.swift
//  ToDoList
//
//  Created by Nurbek on 25/08/24.
//

import UIKit
import SnapKit

final class TDTextView: UITextView {
    
    private var placeholderLabel: TDLabel
    
    init(placeholder: String, style: UIFont.TextStyle, weight: UIFont.Weight = .medium) {
        placeholderLabel = TDLabel(style: style, weight: weight, color: .secondaryLabel)
        super.init(frame: .zero, textContainer: .none)
        
        configureTextView(placeholder: placeholder, style: style, weight: weight)
        layout()
    }
    
    
    private func configureTextView(placeholder: String, style: UIFont.TextStyle, weight: UIFont.Weight) {
        backgroundColor = .systemBackground
        layer.cornerRadius = Constants.CornerRadius.medium
        font = .setFont(style: style, weight: weight)
        textColor = .label
        
        let verticalPadding = Constants.Padding.medium
        let horizontalPadding = verticalPadding - 5
        textContainerInset = .init(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        autocorrectionType = .no
        addShadow()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil)
        
        addSubview(placeholderLabel)
        
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = .max
    }
    
    
    private func layout() {
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Padding.medium)
            $0.leading.equalToSuperview().offset(Constants.Padding.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Padding.medium)
        }
    }
    
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    
    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TDTextView: UITextViewDelegate {
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}
