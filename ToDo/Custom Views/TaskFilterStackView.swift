//
//  TaskFilterStackView.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 02.03.24.
//

import UIKit

enum TaskFilterMode: String {
    case all = "All"
    case active = "Active"
    case done = "Done"
}

protocol TaskFilterStackViewDelegate: AnyObject {
    func taskFilterStackView(_ stackView: TaskFilterStackView, didSelectFilter filter: TaskFilterMode)
}

class TaskFilterStackView: UIStackView {
    
    private var selectedButton: UIButton?
    weak var delegate: TaskFilterStackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        backgroundColor = .cell
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        let allButton = createButton(title: "All")
        let activeButton = createButton(title: "Active")
        let doneButton = createButton(title: "Done")
        
        allButton.setTitleColor(.filter, for: .normal)
        selectedButton = allButton
        
        [allButton, activeButton, doneButton].forEach { [weak self] addButton in
            self?.addArrangedSubview(addButton)
        }
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let buttons = arrangedSubviews as? [UIButton] else { return }
        
        buttons.forEach { button in
            button.setTitleColor(.gray, for: .normal)
        }
        sender.setTitleColor(.filter, for: .normal)
        
        selectedButton = sender
        
        guard let title = sender.title(for: .normal) else { return }
        
        if let mode = TaskFilterMode(rawValue: title) {
            delegate?.taskFilterStackView(self, didSelectFilter: mode)
        }
    }
}

