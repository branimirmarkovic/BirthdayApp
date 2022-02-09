//
//  BirthdayAppApp.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 1.2.22..
//

import SwiftUI
import Combine

@main
struct BirthdayAppApp: App {
    var body: some Scene {
        return WindowGroup {
            EventsViewComposer.eventsView(store: EventsListView_Previews.MockStore())
        }
    }
}

struct EventsViewComposer {
    
    private class StoreAdapter: EventsLoader {
        
        private let store: Store
        private var cancellables: [AnyCancellable] = []
        
        init(store: Store) {
            self.store = store
        }
        
        func load(completion: @escaping (Result<[Event], Error>) -> Void) {
            store.load()
                .sink { completionResult in
                    switch completionResult {
                    case.failure(let error):
                        completion(.failure(error))
                    default:
                        break
                    }
                } receiveValue: { events in
                    completion(.success(events))
                }.store(in: &cancellables)
        }
    }
    
    static func eventsView(store: Store) -> EventsListView {
        EventsListView(viewModel: EventsViewModel(loader: StoreAdapter(store: store)))
    }
}

