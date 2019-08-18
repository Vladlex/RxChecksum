//
//  LocalFileStreamableAdapter.swift
//  RxChecksum
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

public final class LocalFileStreamableAdapter: ChecksumSourceStreamable {
    
    private let url: URL
    
    private var fd: UnsafeMutablePointer<FILE>!
    
    private var bytesToRead: Int
    
    private let fileSize: Int
    
    deinit {
        fclose(fd)
    }
    
    public init(url: URL) throws {
        self.url = url
        
        guard let fd = fopen(url.path, "r") else {
            throw ChecksumError.resourceUnreachable(url)
        }
        self.fd = fd
        
        let cursor = ftello(fd)
        
        fseeko(fd, 0, SEEK_END)
        fileSize = Int(ftello(fd))
        
        fseeko(fd, cursor, SEEK_SET)
        
        bytesToRead = fileSize
    }
    
    public func read(amount: Int) -> Data? {
        var data = Data(count: amount)
        data.count = data.withUnsafeMutableBytes {
            fread($0, 1, amount, fd)
        }
        bytesToRead -= data.count
        return data
    }
    
    public func eof() -> Bool {
        return bytesToRead == 0
    }
    
    public var expectedSize: Int? {
        return fileSize
    }
    
}
