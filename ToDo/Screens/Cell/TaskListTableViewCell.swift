//
//  TaskListTableViewCell.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 21.02.24.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: UI Elements
    let mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        configureMainStack()
        configureTaskLabel()
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
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func configureTaskLabel() {
        mainStack.addArrangedSubview(taskLabel)
    }
    
    
}

#Preview {
    TaskListViewController()
}
