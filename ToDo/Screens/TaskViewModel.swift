//
//  TaskListViewModel.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import Foundation

protocol TaskViewModelDelegate: AnyObject {
    func tasksDidUpdate(tasks: [TodoTask])
    func tasksFetchFailed(with error: Error)
    func taskDidAdd()
    func taskDidToggle()
}

final class TaskViewModel {
    var tasks = [TodoTask]()
    weak var delegate: TaskViewModelDelegate?

    func getTasks() async {
        do {
            self.tasks = try await TaskNetworkManager.shared.fetchTasks()
            delegate?.tasksDidUpdate(tasks: tasks)
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
    
    func addTask(with TaskBody: TaskData) async {
        do {
            try await TaskNetworkManager.shared.addTask(with: TaskBody)
            delegate?.taskDidAdd()
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
    
    func toggleTask(with id: String) async {
        do {
            try await TaskNetworkManager.shared.toggleTask(with: id)
            delegate?.taskDidToggle()
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
    
}


