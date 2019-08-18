//
//  LocalFileStreamableAdapterTests.swift
//  RxChecksumTests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//  Copyright © 2019 Aleksei Gordeev. All rights reserved.
//

import XCTest
@testable import RxChecksum

enum SetupError: Error, Equatable {
    case noFileInBundleDiscovered
}

class LocalFileStreamableAdapterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    func testExpectedSize() {
        
        let adapter: LocalFileStreamableAdapter
        do {
            adapter = try createAdapter()
        } catch {
            XCTFail("Fail to setup adapter. \(error)")
            return
        }
        
        XCTAssertNotNil(adapter.expectedSize)
        XCTAssertEqual(adapter.expectedSize!, 26)
    }
    
    func testReading() {
        
        let adapter: LocalFileStreamableAdapter
        do {
            adapter = try createAdapter()
        } catch {
            XCTFail("Fail to setup adapter. \(error)")
            return
        }
        
        let data1 = adapter.read(amount: 4)
        XCTAssertNotNil(data1)
        XCTAssertEqual(data1!, "Test".data(using: .utf8)!)
        
        XCTAssertFalse(adapter.eof())
        
        let data2 = adapter.read(amount: 1)
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2!, " ".data(using: .utf8)!)
        
        XCTAssertFalse(adapter.eof())
        
        let data3 = adapter.read(amount: 10000)
        XCTAssertNotNil(data3)
        XCTAssertEqual(data3!, "calculating MD5 Hash\n".data(using: .utf8)!)
        
        XCTAssertTrue(adapter.eof())
    }

    func testUnreachableFile() {
        let url = URL.init(fileURLWithPath: "my_file.text")
        XCTAssertThrowsError(try LocalFileStreamableAdapter(url: url), "Should throw an error for unreachable file") { (error) in
            guard let checksumError = error as? ChecksumError, checksumError == ChecksumError.resourceUnreachable(url) else {
                XCTFail("Unexpected error type. \(error)")
                return
            }
        }
    }
    
    func createAdapter() throws -> LocalFileStreamableAdapter {
        
        guard let url = self.resources.hashTestFile else {
            throw SetupError.noFileInBundleDiscovered
        }
        
        return try LocalFileStreamableAdapter(url: url)
    }
    
}
