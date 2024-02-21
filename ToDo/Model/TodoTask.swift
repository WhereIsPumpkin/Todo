//
//  Task.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 21.02.24.
//

import Foundation

struct TodoTask: Identifiable, Decodable {
    var id: String
    var done: Bool
    var todoTask: String
}
