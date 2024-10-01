import PrimeInterfaces

extension YouTubeService {
    
    struct SnippetsResponse: Decodable {
        let items: [YouTubeVideoSnippet]
    }
    
}
