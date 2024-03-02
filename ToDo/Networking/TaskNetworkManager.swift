//
//  TaskNetworkManager.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import Foundation
import NetSwiftly

class TaskNetworkManager {
    
    static let shared = TaskNetworkManager()
    private let baseURL = NetworkConfiguration.baseURL
    private let builder: URLRequestBuilder
    
    private init() {
        guard let baseURL = URL(string: self.baseURL) else {
            fatalError("Invalid base URL")
        }
        self.builder = URLRequestBuilder(baseURL: baseURL)
    }
    
    
    func fetchTasks() async throws -> [TodoTask] {
        
        let request = builder.get("/getTasks")
        
        do {
            let response: TasksResponse = try await NetSwiftly.shared.performRequest(request: request, responseType: TasksResponse.self)
            return response.data
        } catch {
            throw error
        }
    }
    
    
    func addTask(with taskData: TaskData) async throws -> Bool {
        var request = builder.post("/addTask")
        
        do {
            try request.setJSONBody(taskData)
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            return true
        } catch {
            throw error
        }
    }
    
    
    func toggleTask(with id: String) async throws -> Bool {
        let request = builder.patch("/toggleTask/\(id)")
        
        do {
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            return true
        } catch {
            throw error
        }
    }
    
    func deleteTask(with id: String) async throws {
        let request = builder.delete("/deleteTask/\(id)")
        
        do {
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
        } catch {
            throw error
        }
    }
    
    func deleteAllTask() async throws {
        let request = builder.delete("/deleteAllTask")
        
        do {
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
        } catch {
            throw error
        }
        
    }
}
