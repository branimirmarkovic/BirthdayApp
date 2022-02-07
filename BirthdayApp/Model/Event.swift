//
//  Event.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 1.2.22..
//

import Foundation

enum EventType: String, Codable, Equatable {
    case birthday = "Birthday"
}
struct Event: Codable, Equatable {
    var id: UUID
    var type: EventType
    var person: Person
    var date: Date
}

struct Person: Codable, Equatable {
    var name: String
}
