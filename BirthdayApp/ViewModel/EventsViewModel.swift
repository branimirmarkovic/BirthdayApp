//
//  EventsViewModel.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 4.2.22..
//

import Foundation

typealias Observer<T> = (T) -> Void

protocol EventsLoader {
    func load(completion: @escaping (Result<[Event], Error>) -> Void)
}


class EventsViewModel {
    
    private let loader: EventsLoader
    var events: [Event] = [] {
        didSet {
            onChange?(events)
        }
    }
    private var errorMessage: String?
    private var isLoading: Bool = false
    
    enum ActionStates {
        case loading
        case loaded([Event])
        case error(String)
    }
    
    var onChange: Observer<[Event]>?
    var onError: Observer<String>?
    var onLoad: Observer<Void>?
    
    
    init (loader: EventsLoader) {
        self.loader = loader
    }
    
    public func load() {
        self.onLoad?(())
        self.loader.load { result in 
            switch result {
            case .success(let events):
                self.events = events
            case .failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }
    
    private func errorMessage(for error: Error) -> String {
        "Something went wrong"
    }
}

import Combine

extension EventsViewModel {
    var errorMessagePublisher: AnyPublisher<String,Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
}








