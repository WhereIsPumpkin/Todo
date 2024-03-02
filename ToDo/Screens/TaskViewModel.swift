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
    func taskDidDelete()
    func taskDidToggle()
}

final class TaskViewModel {
    var tasks = [TodoTask]()
    weak var delegate: TaskViewModelDelegate?
    
    func getTasks() async {
        do {
            let fetchedTasks = try await TaskNetworkManager.shared.fetchTasks()
            self.tasks = fetchedTasks
            DispatchQueue.main.async {
                self.delegate?.tasksDidUpdate(tasks: fetchedTasks)
            }
        } catch {
            DispatchQueue.main.async {
                self.delegate?.tasksFetchFailed(with: error)
            }
        }
    }
    
    func addTask(with TaskBody: TaskData) async {
        do {
            let _ = try await TaskNetworkManager.shared.addTask(with: TaskBody)
            DispatchQueue.main.async {
                self.delegate?.taskDidAdd()
            }
        } catch {
            DispatchQueue.main.async {
                self.delegate?.tasksFetchFailed(with: error)
            }
        }
    }
    
    func toggleTask(with id: String) async {
        do {
            _ = try await TaskNetworkManager.shared.toggleTask(with: id)
            delegate?.taskDidToggle()
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
    
    func deleteTask(with id: String) async {
        do {
            _ = try await TaskNetworkManager.shared.deleteTask(with: id)
            delegate?.taskDidDelete()
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
    
    func deleteAllTask() async {
        do {
            _ = try await TaskNetworkManager.shared.deleteAllTask()
            delegate?.taskDidDelete()
        } catch {
            delegate?.tasksFetchFailed(with: error)
        }
    }
}
