//
//  ChecksumTests.swift
//  RxChecksumTests
//
//  Created by Aleksei Gordeev on 18/08/2019.
//  Copyright © 2019 Aleksei Gordeev. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxChecksum

class ChecksumTests: XCTestCase {
    
    func testFileChecksum() {
        
        let checksum = RxChecksum(queue: .global(qos: .userInitiated))
        
        guard let url = resources.hashTestFile else {
            XCTFail("Fail to discover test file")
            return
        }
        
        let expectChecksum = expectation(description: "Checksum calculated")
        let expectCompletion = expectation(description: "Observable completed")
        
        let disp = checksum.calculate(localFile: url).subscribe(onNext: { (event) in
            if case .calculated(let checksum) = event {
                expectChecksum.fulfill()
                XCTAssertEqual(checksum, "f238593ca991633c63c4a4cfe7d0e535")
            }
        }, onError: { (error) in
            XCTFail("Fail. \(error)")
            expectCompletion.fulfill()
        }, onCompleted: {
            expectCompletion.fulfill()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            disp.dispose()
        }
        wait(for: [expectChecksum, expectCompletion], timeout: 0.5)
    }
    
    func testOtherThanMD5AlgorithmsFileChecksums() {
        
        struct Case {
            var algorithm: DigestAlgorithm
            var expectedHash: String
            init(_ algorithm: DigestAlgorithm, _ hash: String) {
                self.algorithm = algorithm
                self.expectedHash = hash
            }
        }
        
        let cases: [Case] = [
            .init(.sha1, "8e78cf9d6dfe9778770859ee5fe0fbcbd4ffb54c"),
            .init(.sha224, "bd60b68b8abfa393bf891ded41f2e6e52a4de9fc779c2a31ec80ddf3"),
            .init(.sha256, "ae0ffd52c2fb1e49ec5f2cb41dd027c17eb6eb82ada92f5004cba35293002ac6"),
            .init(.sha384, "9b791f68d13c359cdead6440806b94312c60dc93fb1c741c9c07d4473746ca1a5c3f157c326b67e65e90ef635170182e"),
            .init(.sha512, "8f8ec651040752790a4316abfe0849c33645b28d220d502f00b9f467f609d9f5be11dba93b4ef047a301ee96899d4abbeb3a066612691bbb32afcfca71e67892"),
            ]
        
        let checksum = RxChecksum(queue: .global(qos: .userInitiated))
        
        guard let url = resources.hashTestFile else {
            XCTFail("Fail to discover test file")
            return
        }
        
        let expectsAllHashesCalculated = expectation(description: "All hashes have been calculated")
        
        let disposable = Observable
            .concat(Observable.from(cases))
            .flatMap { (caseItem) -> Observable<Void> in
                
                var options = Options.default
                options.algorithm = caseItem.algorithm
                
                return checksum
                    .calculate(localFile: url, options: options)
                    // Don't finish till the calcualted event comes
                    .flatMapLatest({ (event) -> Observable<Void> in
                        guard case .calculated(let hash) = event else {
                            return .never()
                        }
                        if hash != caseItem.expectedHash {
                            XCTFail("Algorithm '\(caseItem.algorithm)' failed. Expects '\(caseItem.expectedHash)', got '\(hash)'")
                        }
                        return .empty()
                    })
            }.subscribe(onCompleted: {
                expectsAllHashesCalculated.fulfill()
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            disposable.dispose()
        }
        
        wait(for: [expectsAllHashesCalculated], timeout: 1.0)
    }
    
}
