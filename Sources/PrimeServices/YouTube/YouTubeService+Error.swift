import PrimeInterfaces

extension YouTubeService {
    
    enum Error: Swift.Error {
        case noVideoIDs
        case cannotCreateURLRequest
        case networkingFailure(any Swift.Error)
        case decodingFailure(any Swift.Error)
    }
    
}
