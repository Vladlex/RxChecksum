import Foundation
import CommonCrypto.CommonDigest
import RxSwift

public struct Options: Hashable {
    
    public static let `default` = Options()
    
    public var chunkSize: ChunkSize = .default
    
    public var algorithm: DigestAlgorithm = .md5
}

public enum ChecksumEvent: Equatable {
    case progress(Float)
    case calculated(String)
}

public protocol RxChecksumProtocol {
    func calculate(source: ChecksumSourceStreamable, options: Options) -> Observable<ChecksumEvent>
}

public final class RxChecksum: RxChecksumProtocol {
    
    private let queue: DispatchQueue
    
    public init(queue: DispatchQueue = .global(qos: .background)) {
        self.queue = queue
    }
    
    public func calculate(source: ChecksumSourceStreamable, options: Options) -> Observable<ChecksumEvent> {
        
        let queue = self.queue
        
        return Observable.create({ (observer) -> Disposable in
            
            let cc = CCWrapper(algorithm: options.algorithm)
            let flag = DisposeFlag()
            var chunkIdx = 0
            
            queue.async {
                let result: String
                do {
                    result = try autoreleasepool(invoking: { () -> String in
                        
                        while !source.eof() {
                            
                            guard let data = try source.read(amount: options.chunkSize.bytes) else { break }
                            
                            data.withUnsafeBytes({ (ptr: UnsafePointer<UInt8>) -> Void in
                                let uMutablePtr = UnsafeMutableRawPointer(mutating: ptr)
                                cc.update(data: uMutablePtr, length: CC_LONG(data.count))
                            })
                            
                            chunkIdx += 1
                            
                            if chunkIdx % 10 == 0, let total = source.expectedSize {
                                let progress = Swift.min(Float(chunkIdx * options.chunkSize.bytes) / Float(total), 1.0)
                                observer.onNext(.progress(progress))
                            }
                        }
                        
                        cc.final()
                        
                        return cc.hexString()!
                    })
                } catch {
                    observer.onError(error)
                    return
                }
                
                if !flag.disposed {
                    observer.onNext(.calculated(result))
                    observer.onCompleted()
                }
                
            }
            
            return Disposables.create { flag.disposed = true }
        })
    }
    
}

public extension RxChecksumProtocol {
    
    func calculate(options: Options, streamableProvider: @escaping () throws -> ChecksumSourceStreamable) -> Observable<ChecksumEvent> {
        return Observable.deferred({ () in
            let streamable = try streamableProvider()
            return self.calculate(source: streamable, options: options)
        })
    }
    
    func calculate(localFile: URL, options: Options = .default) -> Observable<ChecksumEvent> {
        return calculate(options: options, streamableProvider: { () -> ChecksumSourceStreamable in
            return try LocalFileStreamableAdapter(url: localFile)
        })
    }
    
    func calculate(data: Data, options: Options = .default) -> Observable<ChecksumEvent> {
        return calculate(options: options, streamableProvider: { () -> ChecksumSourceStreamable in
            return DataStreamableAdapter(data: data)
        })
    }
    
    func calculate(string: String, options: Options = .default, encoding: String.Encoding = .utf8) -> Observable<ChecksumEvent> {
        return calculate(options: options, streamableProvider: { () -> ChecksumSourceStreamable in
            guard let data = string.data(using: encoding) else {
                throw ChecksumError.stringEncodingFailed
            }
            return DataStreamableAdapter(data: data)
        })
    }
    
}
