//
//  CompositionRoot.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 4.2.22..
//

import Foundation

typealias MainStore = EventLoader

class CompositionRoot {
    
    static func fileManager() -> LocalFileManager {
        do { return try DefaultFileManager() } 
        catch { fatalError("Cant create file manager, \(error)")}
    }
    
    static func mainStore() -> MainStore {
        LocalStore(fileManager: fileManager())
    }
    
    
    
}
