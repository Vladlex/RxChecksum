//
//  ChecksumError.swift
//  RxChecksum
//
//  Created by Aleksei Gordeev on 18/08/2019.
//

import Foundation

public enum ChecksumError: Error, Equatable {
    case stringEncodingFailed
    case resourceUnreachable(URL)
}
