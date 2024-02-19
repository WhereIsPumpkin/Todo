//
//  ViewController.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import UIKit

class TaskListViewController: UIViewController {
    
    // MARK: UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// Header Elements
    private let headerStackView = UIStackView()
    private let logoLabel = UILabel()
    private let darkModeSwitch: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "moon.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    /// Task Elements
    private let mainStackView = UIStackView()
    private let taskInputField = TaskInputTextField(placeholderKey: "Create a new todo...")
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    // MARK: UI Setup
    private func setupUI() {
        addSubviews()
        setupBackgroundImageView()
        setupHeaderStackView()
        setupMainStackView()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerStackView)
        view.addSubview(mainStackView)
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView.image = UIImage(resource: .bgLight)
        setupBackgroundImageViewConstraints()
    }
    
    private func setupBackgroundImageViewConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupHeaderStackView() {
        headerStackView.axis = .horizontal
        setupHeaderStackConstraints()
        configureHeaderStackMargins()
        addHeaderStackSubViews()
        configureHeaderStackViews()
    }
    
    private func setupHeaderStackConstraints() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func configureHeaderStackMargins() {
        headerStackView.isLayoutMarginsRelativeArrangement = true
        headerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func addHeaderStackSubViews() {
        headerStackView.addArrangedSubview(logoLabel)
        headerStackView.addArrangedSubview(darkModeSwitch)
    }
    
    private func configureHeaderStackViews() {
        setupLogoLabel()
        setupDarkModeSwitch()
    }
    
    private func setupLogoLabel() {
        logoLabel.text = "T O D O"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 24)
        logoLabel.textColor = .white
    }
    
    private func setupDarkModeSwitch() {
        setupDarkModeSwitchConstraints()
        // TODO: Handle DarkMode switch
    }
    
    private func setupDarkModeSwitchConstraints() {
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            darkModeSwitch.heightAnchor.constraint(equalToConstant: 24),
            darkModeSwitch.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupMainStackView() {
        setupMainStackLayout()
        configureMainStackMargins()
        setupMainStackConstraints()
        setupTaskInputField()
    }
    
    private func setupMainStackLayout() {
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(taskInputField)
    }
    
    private func configureMainStackMargins() {
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func setupMainStackConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 32),
            mainStackView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
    }
    
    private func setupTaskInputField() {
        taskInputField.layer.cornerRadius = 5
  
        
    }

}

#Preview {
    TaskListViewController()
}
