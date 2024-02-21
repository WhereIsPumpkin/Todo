//
//  TaskListTableViewCell.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 21.02.24.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var isChecked: Bool = false {
        didSet {
            updateCheckmarkImage()
        }
    }
    
    var onCheckmarkTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    // MARK: - UI Elements
    let mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var doneIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle")
        imageView.tintColor = isChecked ? .checkmark : .accentWhite
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var deleteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = UIColor(red: 73/255, green: 76/255, blue: 107/255, alpha: 0.5)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 73/255, green: 76/255, blue: 107/255, alpha: 1)
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(task: TodoTask) {
        taskLabel.text = task.todoTask
        isChecked = task.done
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        configureMainStack()
        configureTaskLabel()
        configureDoneIcon()
        configureDeleteIcon()
    }
    
    private func setupTapGesture() {
        contentView.isUserInteractionEnabled = true
        let tapGestureRecognizerDone = UITapGestureRecognizer(target: self, action: #selector(handleIconTap))
        contentView.addGestureRecognizer(tapGestureRecognizerDone)
    }
    
    // MARK: - Subview Configuration
    private func configureMainStack() {
        addSubview(mainStack)
        setupMainStackConstraints()
        setupMainStackMargins()
    }
    
    private func configureTaskLabel() {
        mainStack.addArrangedSubview(doneIcon)
        mainStack.addArrangedSubview(taskLabel)
    }
    
    private func configureDoneIcon() {
        doneIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func configureDeleteIcon() {
        mainStack.addArrangedSubview(deleteIcon)
        deleteIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    // MARK: - Layout Constraints
    private func setupMainStackConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupMainStackMargins() {
        mainStack.spacing = 12
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    // MARK: - Helper Methods
    private func updateCheckmarkImage() {
        doneIcon.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle")
        doneIcon.tintColor = isChecked ? .checkmark : .accentWhite
    }
    
    // MARK: - Gesture Recognizer
    @objc private func handleIconTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        if doneIcon.frame.contains(tapLocation) {
            isChecked.toggle()
            onCheckmarkTapped?()
        } else if deleteIcon.frame.contains(tapLocation) {
            onDeleteTapped?()
        }
    }
}


#Preview {
    TaskListViewController()
}
