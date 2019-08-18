//
//  ChunkSize.swift
//  Pods-RxChecksum_Tests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

public struct ChunkSize: RawRepresentable, Hashable, Comparable {
    
    public typealias RawValue = Int
    
    public let rawValue: Int
    
    public var bytes: Int {
        return rawValue
    }
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public init(bytes: RawValue) {
        self.init(rawValue: bytes)
    }
    
    public static func kilobytes(_ kilobytes: Int) -> ChunkSize {
        return self.init(bytes: kilobytes * 1024)
    }
    
    public static func < (lhs: ChunkSize, rhs: ChunkSize) -> Bool {
        return lhs.bytes < rhs.bytes
    }
    
    /// 256 kb
    public static let `default` = kilobytes(256)
    
}
