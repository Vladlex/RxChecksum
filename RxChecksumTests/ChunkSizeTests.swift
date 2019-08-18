//
//  ChunkSizeTests.swift
//  RxChecksumTests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//  Copyright © 2019 Aleksei Gordeev. All rights reserved.
//

import XCTest
@testable import RxChecksum

class ChunkSizeTests: XCTestCase {
    
    func testKilobytesToBytes() {
        let chunk1 = ChunkSize.kilobytes(10)
        XCTAssertEqual(chunk1.bytes, 10240)
        
        let chunk2 = ChunkSize.kilobytes(101)
        XCTAssertEqual(chunk2.bytes, 101 * 1024)
        
    }
    
    func testChunkSizeComparable() {
        let chunks: [ChunkSize] = [
            .init(bytes: 1),
            .init(bytes: 10),
            .init(bytes: 100),
            .kilobytes(1),
            .kilobytes(2),
            .kilobytes(10)
        ]
        
        let shufflesChunks = chunks.shuffled()
        let sortedChunks = shufflesChunks.sorted()
        
        XCTAssertEqual(chunks, sortedChunks)
    }
    
}
