import Foundation
import PrimeInterfaces

// MARK: - SimpleNetworkingService

final public actor SimpleNetworkingService {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
}

// MARK: - SimpleNetworkingServiceProtocol

extension SimpleNetworkingService: SimpleNetworkingServiceProtocol {
    
    public func executeRequest(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        try await session.data(for: request)
    }
    
}
