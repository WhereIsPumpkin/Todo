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
}
