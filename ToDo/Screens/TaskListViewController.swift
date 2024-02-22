//
//  ViewController.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import UIKit

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
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        setupUI()
        
        // Fetch tasks
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
            // TODO: Handle Delete Tap
        }
        
        return cell
    }
}

extension TaskListViewController: TaskViewModelDelegate {
    
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
        if let urlError = error as? URLError {
            switch urlError.code {
            case .badURL:
                showAlert(title: "Error", message: "Invalid URL. Please check your configuration.")
            case .badServerResponse:
                showAlert(title: "No Internet Connection", message: "Please check your internet connection and try again.")
            default:
                showAlert(title: "Network Error", message: "An unexpected network error occurred.")
            }
        } else if error is DecodingError {
            showAlert(title: "Data Error", message: "There was a problem processing the received data.")
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
