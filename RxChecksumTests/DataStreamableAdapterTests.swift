//
//  DataStreamableAdapterTests.swift
//  RxChecksum_Tests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import RxChecksum

class DataStreamableAdapterTests: XCTestCase {
    
    func testExpectedSize() {
        guard let data = "ABCD_EFGH".data(using: .utf8) else {
            XCTFail("Fail to create test data")
            return
        }
        let adapter = DataStreamableAdapter(data: data)
        
        XCTAssertNotNil(adapter.expectedSize)
        XCTAssertEqual(adapter.expectedSize!, data.count)
    }
    
    func testPartByPartReading() {
        
        continueAfterFailure = false
        
        guard let data = "ABCD_EFGH".data(using: .utf8) else {
            XCTFail("Fail to create test data")
            return
        }
        let adapter = DataStreamableAdapter(data: data)
        
        XCTAssertFalse(adapter.eof())
        
        let part1 = adapter.read(amount: 4)
        XCTAssertNotNil(part1)
        XCTAssertEqual(String(data: part1!, encoding: .utf8), "ABCD")
        
        XCTAssertFalse(adapter.eof())
        
        let part2 = adapter.read(amount: 1)
        XCTAssertNotNil(part2)
        XCTAssertEqual(String(data: part2!, encoding: .utf8), "_")
        
        XCTAssertFalse(adapter.eof())
        
        let part3 = adapter.read(amount: 4)
        XCTAssertNotNil(part3)
        XCTAssertEqual(String(data: part3!, encoding: .utf8), "EFGH")
        
        XCTAssertTrue(adapter.eof())
        
        let part4 = adapter.read(amount: 1)
        XCTAssertNil(part4)
        
        XCTAssertTrue(adapter.eof())
    }
    
}
