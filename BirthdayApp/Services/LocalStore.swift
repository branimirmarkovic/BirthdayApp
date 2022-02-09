//
//  LocalStore.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 1.2.22..
//

import Foundation
import Combine

protocol Store {
    func load() -> AnyPublisher<[Event], Error>
    func insert(event: Event) -> AnyPublisher<Void, Error>
    func update(event: Event) -> AnyPublisher<Void, Error>
    func delete(event: Event) -> AnyPublisher<Void, Error>
}

extension DefaultFileManager: Store {
    
    func load<Object: Decodable>() -> AnyPublisher<[Object], Error> {
        read()
            .decode(type: [Object].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func insert<Object: Codable>(event: Object) -> AnyPublisher<Void, Error> {
        load()
            .append([event])    
            .encode(encoder: JSONEncoder())
            .flatMap(self.write)
            .eraseToAnyPublisher()
    }
    
    func update<Object:Codable>(event: Object) -> AnyPublisher<Void, Error> where Object: Equatable {
        load()
            .flatMap { $0.publisher}
            .map { $0 == event ? event : $0}
            .collect()
            .encode(encoder: JSONEncoder())
            .flatMap(self.write)
            .eraseToAnyPublisher()
    }
    
    func delete<Object: Codable>(event: Object) -> AnyPublisher<Void, Error> where Object: Equatable {
        load()
            .flatMap { $0.publisher}
            .filter { $0 != event } 
            .collect()
            .encode(encoder: JSONEncoder())
            .flatMap(self.write)
            .eraseToAnyPublisher()
    }
}

