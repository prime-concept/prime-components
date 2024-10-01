import Foundation
import PrimeInterfaces

final public class SimpleNetworkingServiceMock {
    
    public var executeRequest_invocationCount = 0
    public var executeRequest_requests = [URLRequest]()
    public var executeRequest_result: Result<(Data, URLResponse), any Error>!
    
    public init() { }
    
}

extension SimpleNetworkingServiceMock: SimpleNetworkingServiceProtocol {
    
    public func executeRequest(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        executeRequest_invocationCount += 1
        executeRequest_requests.append(request)
        switch executeRequest_result! {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
}
