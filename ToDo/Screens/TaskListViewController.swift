//
//  ViewController.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import UIKit
import NetSwiftly

class TaskListViewController: UIViewController {
    // MARK: Properties
    let viewModel = TaskViewModel()
    var tasks = [TodoTask]()
    
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setupUI()
        
        Task {
            await viewModel.getTasks()
        }
    }
    
    // MARK: UI Setup
    private func setupUI() {
        addSubviews()
        setupBackgroundImageView()
        setupHeaderStackView()
        setupTaskInputField()
        setupTaskList()
        viewModel.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerStackView)
        view.addSubview(taskInputField)
        view.addSubview(taskList)
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView.image = UIImage(resource: isDarkMode() ? .bgDark : .bgLight)
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
        logoLabel.font = UIFont.boldSystemFont(ofSize: 28)
        logoLabel.textColor = .white
    }
    
    private func setupDarkModeSwitch() {
        setupDarkModeSwitchConstraints()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSwitch))
        darkModeSwitch.isUserInteractionEnabled = true
        darkModeSwitch.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleSwitch() {
        
        if isDarkMode() {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        
        updatedDarkModeSwitchAppearance()
        setupBackgroundImageView()
    }
    
    private func updatedDarkModeSwitchAppearance() {
        
        if isDarkMode() {
            darkModeSwitch.image = UIImage(systemName: "sun.max.fill")
        } else {
            darkModeSwitch.image = UIImage(systemName: "moon.fill")
        }
        
    }
    
    private func setupDarkModeSwitchConstraints() {
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            darkModeSwitch.heightAnchor.constraint(equalToConstant: 24),
            darkModeSwitch.widthAnchor.constraint(equalToConstant: 24)
        ])
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
        taskList.separatorColor = UIColor.accentWhite
        taskList.layer.cornerRadius = 5
        taskList.showsVerticalScrollIndicator = false
        taskList.layer.masksToBounds = true
        taskList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        taskList.contentOffset = CGPoint(x: 0, y: 0)
        taskList.backgroundColor = .cell
        
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
        if tasks.isEmpty {
            taskList.backgroundView = EmptyStateView()
        } else {
            taskList.backgroundView = nil
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskListTableViewCell
        cell.selectionStyle = .none
        
        let task = tasks[indexPath.row]
        cell.configure(task: task)
        
        cell.onCheckmarkTapped = {
            Task {
                await self.viewModel.toggleTask(with: task.id)
            }
        }
        
        cell.onDeleteTapped = {
            Task {
                await self.viewModel.deleteTask(with: task.id)
            }
        }
        
        return cell
    }
}

extension TaskListViewController: TaskViewModelDelegate {
    func taskDidDelete() {
        Task {
            await viewModel.getTasks()
        }
        DispatchQueue.main.async { [weak self] in
            self?.taskList.reloadData()
        }
    }
    
    func tasksDidUpdate(tasks: [TodoTask]) {
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks.reversed()
            self?.taskList.reloadData()
        }
    }
    
    func taskDidAdd() {
        Task {
            await viewModel.getTasks()
        }
        DispatchQueue.main.async { [weak self] in
            self?.taskList.reloadData()
        }
    }
    
    func tasksFetchFailed(with error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverMessage(let message):
                showAlert(title: "Error", message: message)
            default:
                showAlert(title: "Error", message: "Something went wrong. Please try again.")
            }
        } else {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func taskDidToggle() {
        Task {
            await viewModel.getTasks()
        }
        DispatchQueue.main.async { [weak self] in
            self?.taskList.reloadData()
        }
    }
    
}

extension TaskListViewController {
    
    func setupTaskInputField() {
        setupTaskInputFieldConstraints()
        
        taskInputField.onDoneButtonTap = { [weak self] in
            guard let enteredTask = self?.taskInputField.text, !enteredTask.isEmpty else {
                return
            }
            
            guard let isDone = self?.taskInputField.isChecked else {
                return
            }
            
            let enteredTaskBody = TaskData(todoTask: enteredTask, done: isDone)
            
            Task {
                await self?.viewModel.addTask(with: enteredTaskBody)
            }
            
            self?.taskInputField.text = ""
            
            self?.taskInputField.resignFirstResponder()
        }
    }
}




#Preview {
    TaskListViewController()
}
