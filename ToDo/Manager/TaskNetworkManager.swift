//
//  TaskNetworkManager.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
}

class TaskNetworkManager {
    static let shared = TaskNetworkManager()
    private let baseURL = "http://localhost:3000/api/"
    
    private init() {}
    
    func fetchTasks() async throws -> [TodoTask] {
        guard let url = URL(string: baseURL + "getTasks") else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        let decodedData = try JSONDecoder().decode([TodoTask].self, from: data)
        return decodedData
    }
    
    func addTask(with taskData: TaskData) async throws {
        guard let url = URL(string: baseURL + "addTask") else { throw URLError(.badURL) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let jsonData = try JSONEncoder().encode(taskData)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw error
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 201 else {
                throw "Unexpected Response"
            }
        } catch {
            throw error
        }
    }
    
    func toggleTask(with id: String) async throws {
        guard let url = URL(string: baseURL + "toggleTask/\(id)") else { throw URLError(.badURL) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.patch.rawValue
        
        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 201 else {
                throw "Unexpected Response"
            }
        } catch {
            throw error
        }
        
    }
    
}

extension String: Error {}
