//
//  DefaultFileManagerTests.swift
//  BirthdayAppTests
//
//  Created by Branimir Markovic on 4.2.22..
//

import XCTest
@testable import BirthdayApp

class DefaultFileManagerTests: XCTestCase {
    
    
    private let performanceLimit = 0.1

    func test_readData_success() {
        let sut = makeSut()
        let expectation = expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        
        let _ = sut.read().sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Expected state finished, got failure with: \(error)")
            }
            expectation.fulfill()
        } receiveValue: { _ in 
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: performanceLimit)
    }
    
    
    
    
    private func makeSut() -> DefaultFileManager {
        try! DefaultFileManager()
    }
    
    
}
