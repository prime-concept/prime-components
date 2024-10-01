import Foundation

/// A primitive service that enables basic networking.
///
/// + Keep in mind this service will be replaced with a full-fledged networking client in a future update.
public protocol SimpleNetworkingServiceProtocol: Sendable {
    
    /// Executes a data request.
    func executeRequest(_ request: URLRequest) async throws -> (data: Data, response: URLResponse)
    
}
