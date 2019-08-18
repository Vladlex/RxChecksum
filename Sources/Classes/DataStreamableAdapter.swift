//
//  StreamableAdapters.swift
//  RxChecksum
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

internal final class DataStreamableAdapter: ChecksumSourceStreamable {
    
    private let data: Data
    
    private var bytesRead: Int = 0
    
    private var bytesLeft: Int {
        return data.count - bytesRead
    }
    
    public init(data: Data) {
        self.data = data
    }
    
    func read(amount: Int) -> Data? {
        guard bytesLeft > 0 else {
            return nil
        }
        let bytesToCopy = Swift.min(bytesLeft, amount)
        let range = bytesRead..<(bytesRead + bytesToCopy)
        let bytes = data[range]
        bytesRead = range.upperBound
        return bytes
    }
    
    func eof() -> Bool {
        return bytesLeft == 0
    }
    
    var expectedSize: Int? {
        return data.count
    }
    
}
