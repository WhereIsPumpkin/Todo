//
//  TaskNetworkManager.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 19.02.24.
//

import Foundation

func fetchTasks() async throws -> [Task] {
    guard let url = URL(string: "http://localhost:3000/api/getTasks") else { throw URLError(.badURL) }
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    
    let decodedData = try JSONDecoder().decode([Task].self, from: data)
    return decodedData
}

