/// The object that interacts with the YouTube API.
public protocol YouTubeServiceProtocol: Sendable {
    
    /// Fetches information about the videos with the corresponding IDs.
    func snippets(forVideoIDs videoIDs: [String]) async throws -> [YouTubeVideoSnippet]
    
}
