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
    var displayedTasks = [TodoTask]()
    var allTasks = [TodoTask]()
    
    // MARK: UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.layer.cornerRadius = 5
        stack.layer.masksToBounds = true
        
        return stack
    }()
    
    private let taskFooterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        stack.backgroundColor = .cell
        
        return stack
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryText
        
        return label
    }()
    
    private let clearTasksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Tasks", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(.secondaryText, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let taskFilterStack = TaskFilterStackView()
    
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
        setupMainStackView()
        setupTaskList()
        viewModel.delegate = self
        taskFilterStack.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerStackView)
        view.addSubview(taskInputField)
        view.addSubview(mainStackView)
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
    
    private func setupMainStackView() {
        mainStackView.addArrangedSubview(taskList)
        mainStackView.addArrangedSubview(taskFooterStackView)
        mainStackView.addArrangedSubview(taskFilterStack)
        mainStackView.setCustomSpacing(16, after: taskFooterStackView)
        setupTaskFooter()
        
        setupMainStackViewConstraints()
    }
    
    private func setupMainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainStackView.topAnchor.constraint(equalTo: taskInputField.bottomAnchor, constant: 16),
        ])
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
        taskList.showsVerticalScrollIndicator = false
        taskList.backgroundColor = .cell
        
        taskList.translatesAutoresizingMaskIntoConstraints = false
        
        taskList.heightAnchor.constraint(equalToConstant: 368).isActive = true
    }
    
    private func setupTaskFooter() {
        taskFooterStackView.addArrangedSubview(itemCountLabel)
        taskFooterStackView.addArrangedSubview(clearTasksButton)
        setupClearButton()
    }
    
    private func setupTaskListDelegates() {
        taskList.delegate = self
        taskList.dataSource = self
    }
    
    private func setupClearButton() {
        clearTasksButton.addAction(UIAction(handler: { [weak self] _ in
            self?.clearTasksAction()
        }), for: .touchUpInside)
    }
    
    private func clearTasksAction() {
        Task {
            await viewModel.deleteAllTask()
        }
        setupItemsLeftLabel()
    }
    
    private func setupItemsLeftLabel() {
        let itemCount = allTasks.filter { !$0.done }.count
        itemCountLabel.text = "\(itemCount) items left"
    }

    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayedTasks.isEmpty {
            taskList.backgroundView = EmptyStateView()
        } else {
            taskList.backgroundView = nil
        }
        return displayedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskListTableViewCell
        cell.selectionStyle = .none
        
        let task = displayedTasks[indexPath.row]
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
            self?.setupItemsLeftLabel()
        }
    }
    
    func tasksDidUpdate(tasks: [TodoTask]) {
        DispatchQueue.main.async { [weak self] in
            self?.displayedTasks = tasks.reversed()
            self?.allTasks = tasks.reversed()
            self?.taskList.reloadData()
            self?.setupItemsLeftLabel()
        }
    }
    
    func taskDidAdd() {
        Task {
            await viewModel.getTasks()
        }
        DispatchQueue.main.async { [weak self] in
            self?.taskList.reloadData()
            self?.setupItemsLeftLabel()
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

extension TaskListViewController: TaskFilterStackViewDelegate {
    func taskFilterStackView(_ stackView: TaskFilterStackView, didSelectFilter filter: TaskFilterMode) {
        switch filter {
        case .all:
            filterTasks(by: nil)
        case .active:
            filterTasks(by: false)
        case .done:
            filterTasks(by: true)
        }
    }
}

extension TaskListViewController {
    func filterTasks(by isDone: Bool?) {
        if let isDone = isDone {
            displayedTasks = allTasks.filter { $0.done == isDone }
        } else {
            displayedTasks = allTasks
        }

        DispatchQueue.main.async { [weak self] in
            self?.taskList.reloadData()
        }
    }

}


#Preview {
    TaskListViewController()
}
