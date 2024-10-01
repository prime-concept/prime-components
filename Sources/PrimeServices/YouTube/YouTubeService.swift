import Foundation
import PrimeInterfaces

// MARK: - YouTubeService

final public actor YouTubeService {
    
    private let networkingService: any SimpleNetworkingServiceProtocol
    private let youTubeAPIKey: String
    
    private lazy var jsonDecoder = JSONDecoder()
    
    public init(
        networkingService: any SimpleNetworkingServiceProtocol,
        youTubeAPIKey: String
    ) {
        self.networkingService = networkingService
        self.youTubeAPIKey = youTubeAPIKey
    }
    
}

// MARK: - YouTubeServiceProtocol

extension YouTubeService: YouTubeServiceProtocol {
    
    public func snippets(forVideoIDs videoIDs: [String]) async throws -> [YouTubeVideoSnippet] {
        guard !videoIDs.isEmpty else { throw Error.noVideoIDs }
        
        guard let request = urlRequest(forVideoIDs: videoIDs) else {
            throw Error.cannotCreateURLRequest
        }
        
        let responseData: Data
        do {
            responseData = try await networkingService.executeRequest(request).data
        } catch {
            throw Error.networkingFailure(error)
        }
        
        let snippets: [YouTubeVideoSnippet]
        do {
            snippets = try jsonDecoder.decode(SnippetsResponse.self, from: responseData).items
        } catch {
            throw Error.decodingFailure(error)
        }
        
        return snippets
    }
    
    func urlRequest(forVideoIDs videoIDs: [String]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://www.googleapis.com/youtube/v3/videos") else {
            return nil
        }
        urlComponents.queryItems = [
            .init(name: "key", value: youTubeAPIKey),
            .init(name: "part", value: "snippet"),
            .init(name: "id", value: videoIDs.joined(separator: ",")),
        ]
        
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
}
