//
//  LocalFileManager.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 4.2.22..
//

import Foundation
import Combine


protocol LocalFileManager {
    func read() -> AnyPublisher<Data,Error>
    func write(_ data: Data) -> AnyPublisher<Void,Error>
}


class DefaultFileManager {
    
    private enum FileNames {
        static let mainDirectory = "Database"
        static let databaseFile = "database.json"
    }
    
    enum Errors: Error {
        case invalidDocumentsDirectory
        case noDatabaseFile
        case cantCreateDatabaseFile
    }
    
    static let filePathKey = "main-file-path"
    
    private let fileManager : FileManager
    private var url: URL
    
    init(fileManager: FileManager = FileManager.default) throws {
            self.fileManager = fileManager
            self.url = try Self.setUp(fileManager: fileManager)
    }
    
    public func read() -> Result<Data, Error> {
        do {
            let data = try Data(contentsOf: self.url)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    public func write(_ data: Data) -> Result<Void, Error> {
        do {
            try data.write(to: self.url)
            return  .success(())
        } catch {
            return .failure(error)
        }
    } 
    
   
    
    private static func setUp(fileManager: FileManager) throws -> URL {
        if let url = UserDefaults.standard.url(forKey: Self.filePathKey) {
            if validateDatabaseFile(url, fileManager: fileManager) == true {
                return url
            } else {
                return try createDatabaseFile(fileManager: fileManager)
            }
        } else {
            return try createDatabaseFile(fileManager: fileManager)
        }
    }
    
    private static func validateDatabaseFile(_ url: URL, fileManager: FileManager) -> Bool {
        return fileManager.fileExists(atPath: url.path) 
    }
    
    private static func createDatabaseFile(fileManager: FileManager) throws -> URL {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first else {throw Errors.invalidDocumentsDirectory}
        let mainDirectory = documentsDirectory.appendingPathComponent(FileNames.mainDirectory)
        if !fileManager.fileExists(atPath: mainDirectory.path) {
            try fileManager.createDirectory(at: mainDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        let databaseFilePath = mainDirectory.appendingPathComponent(FileNames.databaseFile)
        if !fileManager.createFile(atPath: databaseFilePath.path,contents: nil) {
            throw Errors.cantCreateDatabaseFile
        }
        UserDefaults.standard.set(databaseFilePath, forKey: Self.filePathKey)
        return databaseFilePath
    }
    
}


@available (iOS 13.0, *)
extension DefaultFileManager: LocalFileManager {
    
    public func read() -> AnyPublisher<Data, Error> {
        Future  { promise in
            do {
                let data = try Data(contentsOf: self.url)
                return promise(.success(data))
            } catch {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func write(_ data: Data) -> AnyPublisher<Void, Error> {
        Future { promise in 
            do {
                try data.write(to: self.url)
                return  promise(.success(()))
            } catch {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
