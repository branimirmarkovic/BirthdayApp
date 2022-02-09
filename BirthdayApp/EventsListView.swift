//
//  EventsListView.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 7.2.22..
//

import SwiftUI
import Combine

struct EventsListView: View {
    let viewModel: EventsViewModel
    @State var events:[Event] = []
    var body: some View {
        List(events, id: \.id) { event in
            Text(event.person.name)
        }
    }
    
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        bind()
        self.viewModel.load()
        
    }
    
    private func bind() {
        viewModel.onChange = {  events in 
            self.events = events
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsViewComposer.eventsView(store: MockStore())
    }
    
     struct MockStore: Store {
        let events = [
            Event(id: UUID(), type: .birthday, person: Person(name: "Bane"), date: Date())
            ]
        func load() -> AnyPublisher<[Event], Error> {
            Just(events)
                .mapError{ _ in  NSError(domain: "", code: 0)}
                .eraseToAnyPublisher()
        }
        
        func insert(event: Event) -> AnyPublisher<Void, Error> {
            Just(())
                .mapError{ _ in  NSError(domain: "", code: 0)}
                .eraseToAnyPublisher()
        }
        
        func update(event: Event) -> AnyPublisher<Void, Error> {
            Just(())
                .mapError{ _ in  NSError(domain: "", code: 0)}
                .eraseToAnyPublisher()
        }
        
        func delete(event: Event) -> AnyPublisher<Void, Error> {
            Just(())
                .mapError{ _ in  NSError(domain: "", code: 0)}
                .eraseToAnyPublisher()
        }
        
        
    }
}
