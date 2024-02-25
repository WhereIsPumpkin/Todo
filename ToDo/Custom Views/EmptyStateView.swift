//
//  EmptyStateView.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 26.02.24.
//

import UIKit

class EmptyStateView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no tasks yet.\nStart by adding one!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    let emptyTasksImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet") // Use an appropriate SF Symbol
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews() // Add the image view
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(messageLabel)
        addSubview(emptyTasksImage)
    }

    private func setupConstraints() {
        emptyTasksImage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyTasksImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyTasksImage.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16), // Spacing
            emptyTasksImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTasksImage.widthAnchor.constraint(equalToConstant: 80),

            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
