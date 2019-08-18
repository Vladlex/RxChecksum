//
//  DisposeFlag.swift
//  RxChecksum
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

public final class DisposeFlag {
    
    public var disposed: Bool {
        get { return perform { _disposed} }
        set { perform { _disposed = newValue } }
    }
    
    private var _disposed = false
    
    private let lock = NSLock()
    
    private func perform<Result>(closure: () -> Result) -> Result {
        lock.lock(); defer { lock.unlock() }
        return closure()
    }
    
}
