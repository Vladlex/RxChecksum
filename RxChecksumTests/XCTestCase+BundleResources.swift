//
//  XCTestCase+BundleResources.swift
//  RxChecksumTests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//  Copyright © 2019 Aleksei Gordeev. All rights reserved.
//

import Foundation
import XCTest

public extension XCTest {
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    var resources: Resources {
        return Resources(bundle: bundle)
    }
    
}

public struct Resources {
    
    public let bundle: Bundle
    
    public var hashTestFile: URL? {
        return bundle.url(forResource: "MD5HashTest", withExtension: "txt")
    }
}
