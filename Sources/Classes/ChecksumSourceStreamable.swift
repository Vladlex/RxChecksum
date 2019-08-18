//
//  Seekable.swift
//  Pods-RxChecksum_Tests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

/**
 Protocol describing any instance that can be seek and read chunk by chunk.
 */
public protocol ChecksumSourceStreamable {
    
    var expectedSize: Int? { get }
    
    func read(amount: Int) throws -> Data?
    
    func eof() -> Bool
}
