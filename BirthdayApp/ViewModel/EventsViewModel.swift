//
//  EventsViewModel.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 4.2.22..
//

import Foundation


class EventsViewModel {
    
    private let loader: EventLoader
    private var events: [Event] = []
    
    init (loader: EventLoader) {
        self.loader = loader
    }
    
}
