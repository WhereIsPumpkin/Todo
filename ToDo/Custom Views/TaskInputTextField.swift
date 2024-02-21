//
//  TaskInputTextField.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 20.02.24.
//

import UIKit

class TaskInputTextField: UITextField {
    
    var isChecked: Bool = false {
        didSet {
            updateCheckmarkImage()
        }
    }
    
    init(placeholderKey: String) {
        super.init(frame: .zero)
        let localizedPlaceholder = NSLocalizedString(placeholderKey, comment: "Placeholder text for the custom styled text field")
        commonInit(placeholder: localizedPlaceholder)
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(placeholder: String) {
        setupTextFieldAppearance(withPlaceholder: placeholder)
        setupLeftCheckmarkImageView()
        addTextChangeObserver()
    }
    
    private func setupTextFieldAppearance(withPlaceholder placeholder: String) {
        self.placeholder = placeholder
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.autocapitalizationType = .none
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.returnKeyType = .done
        self.clearButtonMode = .whileEditing
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func setupLeftCheckmarkImageView() {
        let leftImageView = UIImageView(frame: CGRect(x: 16, y: 14, width: 24, height: 24))
        leftImageView.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle")
        leftImageView.tintColor = isChecked ? .checkmark : .accentWhite
        leftImageView.contentMode = .scaleAspectFit
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 52))
        paddingView.addSubview(leftImageView)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    private func updateCheckmarkImage() {
        if let leftImageView = self.leftView?.subviews.first as? UIImageView {
            leftImageView.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle")
            leftImageView.tintColor = isChecked ? .checkmark : .accentWhite
        }
    }
    
    private func addTextChangeObserver() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        // TODO: Handle Text Change
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.leftView?.addGestureRecognizer(tapGesture)
        self.leftView?.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        isChecked.toggle()
    }
}

#Preview {
    TaskListViewController()
}
