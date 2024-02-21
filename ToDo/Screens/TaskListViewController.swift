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
    private let taskInputField = TaskInputTextField(placeholderKey: "Create a new todo...")
    private let taskList = UITableView()
    
    let randomStrings = ["Buy groceries", "Call mom", "Finish homework", "Go for a run", "Read a book", "Cook dinner", "Write report", "Water plants", "Clean room", "Watch movie"]
    
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
        setupTaskInputField()
        setupTaskList()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerStackView)
        view.addSubview(taskInputField)
        view.addSubview(taskList)
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
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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
    
    private func setupTaskInputField() {
        setupTaskInputFieldConstraints()
    }
    
    private func setupTaskInputFieldConstraints() {
        taskInputField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskInputField.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 32),
            taskInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            taskInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    private func setupTaskList() {
        setupTaskListDelegates()
        taskList.register(TaskListTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        taskList.separatorColor = UIColor(red: 227/255, green: 228/255, blue: 241/255, alpha: 1)
        taskList.layer.cornerRadius = 5
        taskList.layer.masksToBounds = true
        taskList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            taskList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            taskList.topAnchor.constraint(equalTo: taskInputField.bottomAnchor, constant: 16),
            taskList.heightAnchor.constraint(equalToConstant: 368)
        ])
    }

    
    private func setupTaskListDelegates() {
        taskList.delegate = self
        taskList.dataSource = self
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskListTableViewCell
        
        let randomString = randomStrings[indexPath.row]
        cell.taskLabel.text = randomString
        
        return cell
    }

}

#Preview {
    TaskListViewController()
}
