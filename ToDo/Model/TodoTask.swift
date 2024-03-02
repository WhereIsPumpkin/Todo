//
//  Task.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 21.02.24.
//

import Foundation

struct TasksResponse: Decodable {
    let data: [TodoTask]
}

struct TodoTask: Identifiable, Decodable {
    var id: String
    var done: Bool
    var todoTask: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case done
        case todoTask
    }
}
