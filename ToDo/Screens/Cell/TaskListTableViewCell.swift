//
//  TaskListTableViewCell.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 21.02.24.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var isChecked: Bool = false {
        didSet {
            updateCheckmarkImage()
        }
    }
    var onCheckmarkTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    // MARK: UI Elements
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
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func configureMainStack() {
        addSubview(mainStack)
        setupMainStackConstraints()
        setupMainStackMargins()
    }
    
    private func setupMainStackConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupMainStackMargins() {
        mainStack.spacing = 12
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func configureTaskLabel() {
        mainStack.addArrangedSubview(doneIcon)
        mainStack.addArrangedSubview(taskLabel)
    }
    
    private func updateCheckmarkImage() {
        doneIcon.image = UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle")
        doneIcon.tintColor = isChecked ? .checkmark : .accentWhite
    }
    
    private func configureDoneIcon() {
        doneIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        doneIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func configureDeleteIcon() {
        mainStack.addArrangedSubview(deleteIcon)
        deleteIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        deleteIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    @objc private func handleIconTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        if doneIcon.frame.contains(tapLocation) {
            isChecked.toggle()
            onCheckmarkTapped?()
        } else if deleteIcon.frame.contains(tapLocation) {
            print("Delete icon tapped")
            onDeleteTapped?()
        }
    }
}

#Preview {
    TaskListViewController()
}
